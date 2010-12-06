
#import "FeedViewController.h"
#import "NSString+HTML.h"
#import "MWFeedParser.h"
#import "FeedViewCell.h"
#import "asyncimageview.h"
#import "Feed.h"
#import "FeedItemViewController.h"

@implementation FeedViewController

@synthesize parsedFeeds;
@synthesize feedParser;
@synthesize feedTableView;
@synthesize loadingSpinner;
@synthesize defaultFeedImage;
@synthesize imageCache;
@synthesize feed;
@synthesize loadingOverlay;
@synthesize adViewController; 

#pragma mark -
#pragma mark TableViewDelegate
 
// Display customization

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;

// Variable height support

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;

// Section header & footer information. Views are preferred over title should you decide to provide both

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;   // custom view for header. will be adjusted to default or specified header height

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section;   // custom view for footer. will be adjusted to default or specified footer height

// Accessories (disclosures). 

//- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_NA,__MAC_NA,__IPHONE_2_0,__IPHONE_3_0);

//- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath;

// Selection

// Called before the user changes the selection. Return a new indexPath, or nil, to change the proposed selection.
//- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath;

//- (NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);

// Called after the user changes the selection.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath  {

	MWFeedItem *selectedItem = [parsedFeeds objectAtIndex:indexPath.row];
	AsyncImageView *asyncImage = (AsyncImageView *)[imageCache objectForKey:[NSString stringWithFormat:@"%d", indexPath.row]];
	FeedItemViewController *feedItemViewController = [[FeedItemViewController alloc] initWithNibName:@"FeedItemView" bundle:[NSBundle mainBundle] feedItem:selectedItem feed:feed feedImage:asyncImage.image];
	[self.navigationController pushViewController:feedItemViewController animated:YES];
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
#pragma mark TableViewDataSource

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section  {

	return parsedFeeds.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *CellIdentifier = @"FeedViewCell";
	FeedViewCell *cell = (FeedViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil) {		
		NSArray *topLevelObjects = [[NSBundle mainBundle]loadNibNamed:CellIdentifier owner:nil options:nil];
		cell = (FeedViewCell*)[topLevelObjects objectAtIndex:0];
	}
	else  {
		AsyncImageView* oldImage = (AsyncImageView*)[cell.contentView viewWithTag:999];
		if (oldImage != nil)
			[oldImage removeFromSuperview];
		else 
			cell.imageView.image = nil;
	}
	
	if (parsedFeeds.count > 0) {
		MWFeedItem *item = [parsedFeeds objectAtIndex:indexPath.row];
		if (item) {
			cell.titleLabel.text = item.title;
			cell.descriptionLabel.text = [item.summary stringByConvertingHTMLToPlainText];	
			
			if (item.img == nil || item.img == @"") {
				[cell.imageView initWithImage:defaultFeedImage];				
			}
			else  {
				AsyncImageView *asyncImage = (AsyncImageView *)[imageCache objectForKey:[NSString stringWithFormat:@"%d", indexPath.row]];
				if (asyncImage == nil) {
					asyncImage = [[[AsyncImageView alloc] initWithFrame:cell.imageBox.frame] autorelease];
					asyncImage.tag = 999;
					[asyncImage loadImageFromURL:[NSURL URLWithString:item.img]];
				}
						
				[cell.imageBox addSubview:asyncImage];	
				
				//TODO: set limit on size image cache in FeedView so doesn't consume too much mem?
				[imageCache setValue:asyncImage forKey:[NSString stringWithFormat:@"%d", indexPath.row]];
			}			  
		}
	}
	
	return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

	return 1;	
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;    // fixed font style. use custom view (UILabel) if you want something different

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
#pragma mark MWFeedParser

-(void)startParsing:(NSString *)url  {
	loadingOverlay.hidden = NO;
	[loadingSpinner startAnimating];
	feedTableView.allowsSelection = NO;
	feedParser = [[MWFeedParser alloc] initWithFeedURL:url];
	feedParser.delegate = self;
	feedParser.feedParseType = ParseTypeFull;
	feedParser.connectionType = ConnectionTypeAsynchronously;
	[feedParser parse];	
}

- (void)feedParserDidStart:(MWFeedParser *)parser {
	
	NSLog(@"Started Parsing: %@", parser.url);
}

- (void)feedParser:(MWFeedParser *)parser didParseFeedInfo:(MWFeedInfo *)info {

	NSLog(@"Parsed Feed Info: “%@”", info.title);
}

- (void)feedParser:(MWFeedParser *)parser didParseFeedItem:(MWFeedItem *)item {
	
	NSLog(@"Parsed Feed Item: “%@”", item.title);
	if (item) [parsedFeeds addObject:item];
}

- (void)feedParserDidFinish:(MWFeedParser *)parser {

	NSLog(@"Finished Parsing");	
	
	[feedTableView reloadData];
	[loadingSpinner stopAnimating];
	feedTableView.allowsSelection = YES;
	loadingOverlay.hidden = YES;	
}

- (void) showParsingError:(NSError *) error  {
	
	[loadingSpinner stopAnimating];
	loadingOverlay.hidden = YES;
	UIAlertView *alertView = [[UIAlertView alloc] init];
	alertView.title = @"Failed to load news feed...";
	alertView.message = [error localizedDescription];
	alertView.delegate = self;
	[alertView addButtonWithTitle:@"Retry"];
	[alertView addButtonWithTitle:@"Cancel"];
	[alertView show];
	[alertView release];
}
- (void)feedParser:(MWFeedParser *)parser didFailWithError:(NSError *)error {
	NSLog(@"Finished Parsing With Error: %@", error);
	[self showParsingError:error];	
}

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0) {
		[self startParsing:feed.feedUrl];
	}
}

#pragma mark -
#pragma mark view

//The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil feed:(Feed *)feedToParse  {
	if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
		self.feed = feedToParse;
	}
	return self;
}		

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    
	[super viewDidLoad];
	defaultFeedImage = [UIImage imageNamed:@"appicon.png"];

	parsedFeeds = [[NSMutableArray alloc] init];
	[self startParsing:feed.feedUrl];
	
	imageCache = [[NSMutableDictionary alloc] initWithCapacity:10];	
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


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
	[feedParser release];
	[parsedFeeds release];
	[feedTableView release];
	[loadingSpinner release];
	[defaultFeedImage release];
	[imageCache release];
	[feed release];
	[loadingOverlay release];
	[adViewController release];
    [super dealloc];
}


#pragma mark -
#pragma mark testNSURLRequest

/*
 -(IBAction)testNSURLRequest {
 
 
 NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.google.com"] 
 cachePolicy:NSURLRequestUseProtocolCachePolicy 
 timeoutInterval:30.0];
 NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
 
 if(connection) {	
 dataReceived = [[NSMutableData data] retain];
 }
 else {
 
 UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Hello World" 
 message:@"My message..." 
 delegate:nil 
 cancelButtonTitle:@"Cancel" 
 otherButtonTitles:nil];
 
 [alert show];
 [alert release];
 }
 
 }
 
 -(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
 
 [dataReceived setLength:0];
 
 }
 
 -(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
 
 [dataReceived appendData:data];
 }
 
 -(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
 
 [connection release];
 [dataReceived release];	
 NSLog(@"Error - %@ : %@", [error localizedDescription], [[error userInfo] objectForKey:NSURLErrorFailingURLErrorKey]);
 }
 
 -(void)connectionDidFinishLoading:(NSURLConnection *)connection {
 
 NSLog(@"Received %d bytes of data", [dataReceived length]);
 [connection release];
 [dataReceived release];		
 }
 
 */


@end
