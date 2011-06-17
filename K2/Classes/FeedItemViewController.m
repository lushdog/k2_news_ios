
#import "FeedItemViewController.h"
#import "MWFeedItem.h"
#import "NSString+HTML.h"
#import "asyncimageview.h"

@implementation FeedItemViewController

@synthesize feedItem, formatter, feedItemImage, 
			feed, feedItemTableView, loadingBackground, loadingSpinner;

#define CELL_HEIGHT 44.0f
#define CELL_WIDTH 270.0f
#define IMAGE_CELL_HEIGHT 250.0f

#define TITLE_LABEL_FONT_SIZE     17
#define CONTENT_LABEL_FONT_SIZE   15
#define UITEXTVIEW_PADDING		  16


static UIFont *contentFont;
static UIFont *titleFont;

- (UIFont*) TitleFont;
{
	if (!titleFont) titleFont = [UIFont boldSystemFontOfSize:TITLE_LABEL_FONT_SIZE];
	return titleFont;
}


- (UIFont*) ContentFont;
{
	if (!contentFont) contentFont = [UIFont systemFontOfSize:CONTENT_LABEL_FONT_SIZE];
	return contentFont;
}

//TODO: the width of control should be sent rather than full CELL_WIDTH - magic number 17 :(
- (int) heightOfCellWithText :(NSString*)text andFont:(UIFont*)font {
	
	CGSize textSize = {0, 0};
	
	if (text && ![text isEqualToString:@""]) 
		textSize = [text sizeWithFont:font 
						  constrainedToSize:CGSizeMake(CELL_WIDTH - 17, 9999) 
							  lineBreakMode:UILineBreakModeWordWrap];
	return textSize.height + font.ascender - font.descender;
}

#pragma mark -
#pragma mark tableView

// Display customization

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;

// Variable height support

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  {
	

	NSInteger rowNum = indexPath.row;
	CGFloat height;
	switch (rowNum) {
		case 0: {  //feed title
			height = [self heightOfCellWithText:feedItem.title andFont:[self TitleFont]];
			break;
		}
		case 1: { //date			
			height =  CELL_HEIGHT;
			break;
		}
		case 2:  { //image
			if (feedItemImage == nil && (feedItem.img == nil || feedItem.img == @""))
					height =  0;
			else					
				height = IMAGE_CELL_HEIGHT;					
			break;
		}
		case 3 : { //content
			if (feedItem.content || feedItem.summary)  {
				NSString *stringToUse;
				if (feedItem.content) stringToUse = feedItem.content;
				else stringToUse = feedItem.summary;
				height =  [self heightOfCellWithText:[stringToUse stringByConvertingHTMLToTextFieldContent] andFont:[self ContentFont]];
			}
			else height = 0;
			break;	
		}	
		default:
			height =  CELL_HEIGHT;
			break;
	}	
	
		
	return height;
}
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
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
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

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section  {
	
	return 5;		
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath  {
	
	NSInteger rowNum = indexPath.row;
	NSString *cellIdentifier = [NSString stringWithFormat:@"Cell%d", rowNum];
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	
	if (cell == nil)  {
		
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];	
		
		switch (rowNum) {
			case 0: {  //title
				if (feedItem.title)  {
					UILabel *feedTitle = [[UILabel alloc] initWithFrame:CGRectMake(20,5,250,[self heightOfCellWithText:feedItem.title andFont:[self TitleFont] ])];
					feedTitle.lineBreakMode = UILineBreakModeWordWrap;
					feedTitle.numberOfLines = 0;
					feedTitle.font = [self TitleFont]; 
					feedTitle.text = feedItem.title;
					[cell addSubview:feedTitle];
					[feedTitle release];
				}
				break;
			}
			case 1: { //date
				
				//TODO: implement, '3 hours ago' 'yesterday' etc. for FeedItemView date cell
				if (feedItem.date) {				 
					UILabel *feedDate = [[UILabel alloc] initWithFrame:CGRectMake(20,5,CELL_WIDTH, CELL_HEIGHT - 10)];
					feedDate.lineBreakMode = UILineBreakModeWordWrap;
					feedDate.numberOfLines = 0;
					feedDate.font = [self ContentFont];
					feedDate.text = [formatter stringFromDate:feedItem.date];
					[cell addSubview:feedDate];
					[feedDate release];
				}
				break;
			}
			case 2:  { //image
				
				if (feedItemImage == nil) {	 
					if (feedItem.img != nil && feedItem.img != @"") {
						//feedItem's image was clicked before image loaded
						AsyncImageView *asyncImage = [[[AsyncImageView alloc] initWithFrame:CGRectMake(20, 5, CELL_WIDTH, IMAGE_CELL_HEIGHT - 10)] autorelease];
						asyncImage.contentMode =  UIViewContentModeScaleAspectFit;	
						[cell addSubview:asyncImage];	
						[asyncImage loadImageFromURL:[NSURL URLWithString:feedItem.img]];	
					}
				}
				else  {
					UIImageView *feedItemImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 5, CELL_WIDTH, IMAGE_CELL_HEIGHT - 10)];
					feedItemImageView.image = feedItemImage;
					feedItemImageView.contentMode = UIViewContentModeScaleAspectFit;	
					[cell addSubview:feedItemImageView];
					[feedItemImageView release];					
				}
				break;				
			}
			case 3 : { //content
				if (feedItem.content || feedItem.summary)  {                                                                                                                                     
					
					NSString * convertedText = @"";
					
					//MWFeedParser will wipe RSS content and copy to .summary if no description element
					if (feedItem.content)
						convertedText = [feedItem.content stringByConvertingHTMLToTextFieldContent];
					else
						convertedText = [feedItem.summary stringByConvertingHTMLToTextFieldContent];
					
					UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(20, 5, CELL_WIDTH, [self heightOfCellWithText:convertedText andFont:[self ContentFont]] )];      
					textView.text = convertedText;
					textView.dataDetectorTypes = UIDataDetectorTypeAll;
					textView.scrollEnabled = NO;
					textView.font = [self ContentFont];
					textView.editable = NO;
					textView.showsHorizontalScrollIndicator = NO;
					textView.showsVerticalScrollIndicator = NO;
					textView.userInteractionEnabled = YES;
					textView.contentInset = UIEdgeInsetsMake(-4,-8,0,0);
					[cell addSubview:textView];
					[textView release];
					break;
				}				
			}
			case 4 : { //link
				if (feedItem.link) {
					UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect]; 
					button.frame = CGRectMake(20, 5, CELL_WIDTH, CELL_HEIGHT - 10);
					[button addTarget:self action:@selector(openFeedItemLink) forControlEvents:UIControlEventTouchUpInside];
					[button setTitle:@"Link to article" forState:UIControlStateNormal];
					[button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
					[cell addSubview:button];
					//[button release];  //throws bad access b/c UIButton is autorelease						
				}
			}
			default:
				break;
		}
	}	
	
	//[cellIdentifier release];  //throws bad access
	cell.selectionStyle= UITableViewCellSelectionStyleNone;
	return cell;
}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;              // Default is 1 if not implemented

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
#pragma mark FeedItemLink

//TODO: Back/Forward etc. buttons for UIWebView
- (void) openFeedItemLink {
	UIViewController *viewController = [[[UIViewController alloc] init] autorelease];
	UIWebView *webView = [[[UIWebView alloc] initWithFrame:CGRectMake(0,0,320,367)] autorelease];
	webView.delegate = self;
	webView.scalesPageToFit = YES;
	webView.multipleTouchEnabled = YES;
	webView.scalesPageToFit = YES;
	webView.userInteractionEnabled = YES;
	
	loadingBackground = [[UIView alloc] initWithFrame:CGRectMake(0,0,320,367)];
	[loadingBackground setBackgroundColor:[UIColor darkGrayColor]];
	loadingSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	CGRect lsFrame= loadingSpinner.frame;
	CGPoint spinnerOrigin = {self.view.center.x - (loadingSpinner.frame.size.height/2), self.view.center.y - (loadingSpinner.frame.size.width/2)};
	lsFrame.origin = spinnerOrigin;
	loadingSpinner.frame = lsFrame;
	loadingSpinner.hidesWhenStopped = YES;
	[loadingSpinner startAnimating];
	[loadingBackground addSubview:loadingSpinner];
	
	
	[viewController.view addSubview:webView];	
	[viewController.view addSubview:loadingBackground];	
	[[self navigationController] pushViewController:viewController animated:YES];	
	[webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:feedItem.link]]];	
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {	
	loadingBackground.hidden = YES;
	[loadingSpinner stopAnimating];	
}


#pragma mark -
#pragma mark initializer

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil feedItem:(MWFeedItem *)theFeedItem feed:(Feed *)theFeed feedImage:(UIImage *)theFeedImage {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
		feedItem = theFeedItem;
		feed = theFeed;
		feedItemImage = theFeedImage;
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
	feedItemTableView.separatorColor = [UIColor whiteColor];
	formatter = [[NSDateFormatter alloc] init];
	[formatter setDateStyle:NSDateFormatterShortStyle];
	[formatter setTimeStyle:NSDateFormatterShortStyle];	
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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[feedItem release];
	[formatter release];
	[feedItemImage release];
	[feed release];
	[feedItemTableView release];
	[loadingBackground release];
	[loadingSpinner release];
    [super dealloc];
}


@end
