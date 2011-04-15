//
//  YurisAppViewController.m
//  YurisApp
//
//  Created by matt on 11-03-11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import "GoogleAlbumViewController.h"
#import "GDataPhotos.h"
#import "GooglePhotoAlbum.h"
#import "ImageButton.h"
#import <QuartzCore/QuartzCore.h>
#import "GooglePhotoViewController.h"
#import "TestViewController.h"

@implementation GoogleAlbumViewController

@synthesize photoService, tableView, albums;


- (void)viewDidLoad {  
    
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 460) style:UITableViewStyleGrouped];
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];

	[self startLoadingTable];
    
    [super viewDidLoad];
    
    //TODO: fix height of table as can't scroll to end of list
}

- (void)startLoadingTable  {
    
    //TODO: show loading screen
	
	albums = [[NSMutableArray alloc] initWithCapacity:5];
	
	photoService = [[GDataServiceGooglePhotos alloc] init];
    //TODO:put username and pass as props that get filles by .plist values
	[photoService setUserCredentialsWithUsername:@"k2martialartsottawa" 
										password:@"k2martialarts@123"];
	NSURL *feedUrl = [GDataServiceGooglePhotos photoFeedURLForUserID:@"k2martialartsottawa" albumID:nil albumName:nil photoID:nil kind:@"album" access:nil];
	[photoService fetchFeedWithURL:feedUrl delegate:self didFinishSelector:@selector(ticket:finishedWithAlbumsFeed:error:)];
    
}

#pragma mark -
#pragma mark TableData

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section  {

	NSInteger photoCount = [((GooglePhotoAlbum *)[albums objectAtIndex:section]).photos count];
    NSUInteger numRows =  (photoCount / 2) + (photoCount % 2);
    return numRows;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath  {
	
    NSInteger rowNum = [indexPath row];
	NSString *reuseId = @"PhotoCell";
	UITableViewCell *cell = [theTableView dequeueReusableCellWithIdentifier:reuseId];
	
	if (cell == nil) {
        
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, 320, 111)] autorelease];
        
        ImageButton *image1 = [[ImageButton alloc] initWithFrame:CGRectMake(30, 0, 110, 110)];
        [[image1 layer] setBorderColor: [[UIColor blackColor] CGColor]];
        [[image1 layer] setBorderWidth: 1.0];
        [image1 setTag:1];
        [image1 addTarget:self action:@selector(imageClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:image1];
        
        ImageButton *image2 = [[ImageButton alloc] initWithFrame:CGRectMake(160, 0, 110, 110)];
        [image2.layer setBorderColor: [[UIColor blackColor] CGColor]];
        [image2.layer setBorderWidth: 1.0];
        [image2 setTag:2];
        [image2 addTarget:self action:@selector(imageClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:image2];
        
        //[image1 release];
        //[image2 release];
    }
    
	[reuseId release];
	
    GooglePhotoAlbum *photoAlbum = [albums objectAtIndex:[indexPath section]];
   
    GDataEntryPhoto *photo1 = (GDataEntryPhoto*)[photoAlbum.photos objectAtIndex:rowNum * 2];
    NSArray *thumbs1 = [[photo1 mediaGroup] mediaThumbnails];
    NSString *thumbURLString1 = [[thumbs1 objectAtIndex:0] URLString];
    ImageButton *image1 = (ImageButton*)[cell viewWithTag:1];
    [image1 setPhoto:photo1];
    [image1 setCurrentAlbumIndex:[indexPath section]];
    [image1 setCurrentPhotoIndex :rowNum * 2];
    [self fetchThumbnail:thumbURLString1 loadThumbnailInView:image1];
   
    if ([photoAlbum.photos count] > rowNum * 2 + 1 )  {
        GDataEntryPhoto *photo2 = (GDataEntryPhoto*)[photoAlbum.photos objectAtIndex:rowNum * 2 + 1];
        NSArray *thumbs2 = [[photo2 mediaGroup] mediaThumbnails];
        NSString *thumbURLString2 = [[thumbs2 objectAtIndex:0] URLString];
        ImageButton *image2 = (ImageButton*)[cell viewWithTag:2];
        [image2 setPhoto:photo2];
        [image2 setCurrentAlbumIndex:[indexPath section]];
        [image2 setCurrentPhotoIndex:rowNum * 2 + 1];
        [self fetchThumbnail:thumbURLString2 loadThumbnailInView:image2];
    }
    
    return cell;
}

- (void)imageClicked:(id)sender  {
    
    ImageButton *photoButton = (ImageButton*)sender;
    GooglePhotoViewController *photoViewController = [[[GooglePhotoViewController alloc] initWithAlbums:albums startAlbumIndex:photoButton.currentAlbumIndex startPhotoIndex:photoButton.currentPhotoIndex] autorelease];
    [self.navigationController pushViewController: photoViewController animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView  {

	return [albums count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

    return [[((GooglePhotoAlbum*)[albums objectAtIndex:section]).album title] contentStringValue];
    
}

//- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section;

// Editing

// Individual rows can opt out of having the -editing property set for them. If not implemented, all rows are assumed to be editable.
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath;

// Moving/reordering

// Allows the reorder accessory view to optionally be shown for a particular row. By default, the reorder control will be shown only if the datasource implements -tableView:moveRowAtIndexPath:toIndexPath:
//- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath;

// Index

//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView;                                                    // return list of section titles to display in section index view (e.g. "ABCD...Z#")
//- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index;  // tell table which section corresponds to section title/index (e.g. "B",1))

// Data manipulation - insert and delete support

// After a row has the minus or plus button invoked (based on the UITableViewCellEditingStyle for the cell), the dataSource must commit the change
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath;

// Data manipulation - reorder / moving support

//- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath;

#pragma mark -
#pragma mark TableDisplay

// Display customization

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;

// Variable height support

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  {
	return 112;	
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section  {
	//return 20;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;

// Section header & footer information. Views are preferred over title should you decide to provide both

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;   // custom view for header. will be adjusted to default or specified header height
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section;   // custom view for footer. will be adjusted to default or specified footer height

// Accessories (disclosures). 

//- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath  {
	//return UITableViewCellAccessoryDisclosureIndicator;
//}


//- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath;

// Selection

// Called before the user changes the selection. Return a new indexPath, or nil, to change the proposed selection.
//- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath;
//- (NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
// Called after the user changes the selection.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath  {
    
    //TODO: return white background so no selection look
    
}
//- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);

// Editing

// Allows customization of the editingStyle for a particular cell located at 'indexPath'. If not implemented, all editable cells will have UITableViewCellEditingStyleDelete set for them when the table has editing property set to YES.
//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath;
//- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);

// Controls whether the background is indented while editing.  If not implemented, the default is YES.  This is unrelated to the indentation level below.  This method only applies to grouped style table views.
//- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath;

// The willBegin/didEnd methods are called whenever the 'editing' property is automatically changed by the table (allowing insert/delete/move). This is done by a swipe activating a single row
//- (void)tableView:(UITableView*)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath;
//- (void)tableView:(UITableView*)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath;

// Moving/reordering

// Allows customization of the target row for a particular row as it is being moved/reordered
//- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath;               

// Indentation

//- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath; // return 'depth' of row for hierarchies

#pragma mark -
#pragma mark GooglePhotoFetch

- (void) fetchThumbnail:(NSString*)urlString loadThumbnailInView:(UIButton*)button  {
    
    NSURL *thumbURL = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:thumbURL];
    GDataHTTPFetcher *fetcher = [GDataHTTPFetcher httpFetcherWithRequest:request];
    [fetcher setUserData:button];
    [fetcher beginFetchWithDelegate:self
                  didFinishSelector:@selector(imageFetcher:finishedWithData:)
                    didFailSelector:@selector(imageFetcher:failedWithError:)];
    
}

- (void)ticket:(GDataServiceTicket *)ticket 
finishedWithAlbumsFeed:(GDataFeedPhotoAlbum *)feed 
error:(NSError *) error  {
	
	if (error)
		NSLog(@"Error retrieving photo albums: %@", error);
	else if ([[feed entries] count] == 0) 
		NSLog(@"No albums found");
	else {
		
        numAlbumsLeftToParse = [[feed entries] count];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(albumParsed) name:@"FinishedParsingAlbum" object:nil];
		
        for(GDataEntryPhotoAlbum *album in [feed entries])  {
			
			NSLog(@"Found album: %@", [[album title] contentStringValue]);
			
			GooglePhotoAlbum *newAlbum = [[GooglePhotoAlbum alloc] init];
			newAlbum.album = album;
			[albums addObject:newAlbum];
			
			NSURL *feedUrl = [GDataServiceGooglePhotos photoFeedURLForUserID:@"k2martialartsottawa" albumID:[album GPhotoID] albumName:nil photoID:nil kind:nil access:nil];
			[photoService fetchFeedWithURL:feedUrl delegate:self didFinishSelector:@selector(ticket:finishedWithPhotosFeed:error:)];
		}
	}
}
	
- (void)ticket:(GDataServiceTicket *)ticket 
finishedWithPhotosFeed:(GDataFeedPhoto *)feed 
error:(NSError *)error  {
	
	if (error)
		NSLog(@"Error retrieveing photos from album %@: %@", [feed title], error);
	else if ([[feed entries] count] == 0) 
		NSLog(@"No photos for album: %@", [feed title]);
	else {
		NSArray *photos = [feed entries];
		for (GDataEntryPhoto *photo in photos)  {
			
			NSLog(@"Found photo: '%@' with tag '%@' and id '%@'", 
				  [[photo title] contentStringValue], 
				  [[photo photoDescription] contentStringValue],
				  [photo GPhotoID]);
			
			GooglePhotoAlbum *matchingAlbum;
			for (GooglePhotoAlbum *photoAlbum in albums) {
				if ([[photoAlbum.album GPhotoID] isEqualToString:[photo albumID]]) {
					matchingAlbum = photoAlbum;
					break;
				}
			}
			[matchingAlbum.photos addObject:photo];
		}
	}
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FinishedParsingAlbum" object:nil];
}

- (void)albumParsed  {
    
    numAlbumsLeftToParse--;
    if (numAlbumsLeftToParse == 0)  {
        
        //TODO: Hide loading screen
        
        [tableView reloadData];
        
        for (GooglePhotoAlbum *album in albums)  {
            NSLog(@"album name: %@", [album.album title]);
            for (GDataEntryPhoto *photo in album.photos) {
                NSLog(@"photo name: %@", [photo	title]);
            }		
        }
    }
}
		
- (void)imageFetcher:(GDataHTTPFetcher *)fetcher finishedWithData:(NSData *)data {
	
    UIButton *button = (UIButton*)[fetcher userData];
    [button setBackgroundImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
	
}
		
- (void)imageFetcher:(GDataHTTPFetcher *)fetcher failedWithError:(NSError *)error {
	NSLog(@"imageFetcher:%@ failedWithError:%@", fetcher,  error);       
}
		
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	
	[photoService dealloc];
	[tableView dealloc];
	[albums dealloc];
    [super dealloc];
}

@end
