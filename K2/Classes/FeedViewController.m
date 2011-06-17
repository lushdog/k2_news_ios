
#import "FeedViewController.h"
#import "NSString+HTML.h"
#import "MWFeedParser.h"
#import "FeedViewCell.h"
#import "asyncimageview.h"
#import "Feed.h"
#import "FeedItemViewController.h"
#import "AppSettings.h"
#import <QuartzCore/QuartzCore.h>

@implementation FeedViewController

@synthesize parsedFeeds;
@synthesize feedParser;
@synthesize feedTableView;
@synthesize loadingSpinner;
@synthesize defaultFeedImage;
@synthesize imageCache;
@synthesize feed;
@synthesize loadingOverlay;

#pragma mark -
#pragma mark TableViewDelegate

// Called after the user changes the selection.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath  {

	MWFeedItem *selectedItem = [parsedFeeds objectAtIndex:indexPath.row];
	AsyncImageView *asyncImage = (AsyncImageView *)[imageCache objectForKey:[NSString stringWithFormat:@"%d", indexPath.row]];
	FeedItemViewController *feedItemViewController = [[FeedItemViewController alloc] initWithNibName:@"FeedItemView" bundle:[NSBundle mainBundle] feedItem:selectedItem feed:feed feedImage:asyncImage.image];
	[self.navigationController pushViewController:feedItemViewController animated:YES];
}

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
        cell.titleLabel.textColor = [AppSettings textColor1];
        cell.descriptionLabel.textColor = [AppSettings textColor2];
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
    feedTableView.backgroundColor = [AppSettings rowColor];
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
    [super dealloc];
}

@end
