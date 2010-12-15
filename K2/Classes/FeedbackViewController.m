    //
//  FeedbackViewController.m
//
//  Created by matt on 10-09-15.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FeedbackViewController.h"
#import <MessageUI/MessageUI.h> 

@implementation FeedbackViewController

@synthesize feedbackTableView;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section  {
	
	return 6;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath  {

	NSInteger rowNum = indexPath.row;
	NSString *cellIdentifier = [NSString stringWithFormat:@"Cell%d", rowNum];
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

	if (cell == nil)  {
	
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];	
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		switch (rowNum) {
			case 0: {
				UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 200, 30)];
				label.text = @"Send Us Your Feedback";
				label.font = [UIFont systemFontOfSize:17.0f];
				[cell.contentView addSubview:label];
				[label release];
				break;
				
			}
			case 1: {
				UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 200, 30)];
				label.text = @"Share App With A Friend";
				label.font = [UIFont systemFontOfSize:17.0f];
				[cell.contentView addSubview:label];
				[label release];
				break;
				
			}
			case 2: {
				UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 200, 30)];
				label.text = @"Send Friend A Coupon";
				label.font = [UIFont systemFontOfSize:17.0f];
				[cell.contentView addSubview:label];
				[label release];			
				break;
			}				
			case 3: {
				UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 200, 30)];
				label.text = @"Facebook Page";
				label.font = [UIFont systemFontOfSize:17.0f];
				[cell.contentView addSubview:label];
				[label release];			
				break;
			}
			case 4: {
				UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 200, 30)];
				label.text = @"Call Ottawa Dojo";
				label.font = [UIFont systemFontOfSize:17.0f];
				[cell.contentView addSubview:label];
				[label release];			
				break;
			}
			case 5: {
				UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 200, 30)];
				label.text = @"Call Parkdale Dojo";
				label.font = [UIFont systemFontOfSize:17.0f];
				[cell.contentView addSubview:label];
				[label release];			
				break;
			}
			default:
				break;
		}
	}	
	
	return cell;
	[cellIdentifier release];

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

// Display customization

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;

// Variable height support

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  {	
//	return 100.0f;	
//}

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
	if (indexPath.row == 0)  
		[self showFeedBackMailController];		
	else if (indexPath.row == 1)
		[self showShareAppMailController];
	else if (indexPath.row == 2)
		[self showSendCouponMailController];
	else if (indexPath.row == 3)
		[self openFacebook];
	else if (indexPath.row == 4)
		[self callNumberOne];
	else if (indexPath.row == 5)
		[self callNumberTwo];

	
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


- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	[self becomeFirstResponder];
	[self dismissModalViewControllerAnimated:YES];
	[self.navigationController popViewControllerAnimated:YES];	
}

- (void)showFeedBackMailController {
	
	NSDictionary *settingsDictionary = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Config" ofType:@"plist"]];
	NSString *subject = [[settingsDictionary objectForKey:@"FeedBack"] objectForKey:@"Subject"];
	NSString *to = [[settingsDictionary objectForKey:@"FeedBack"] objectForKey:@"To"];
	
	MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
	controller.mailComposeDelegate = self;
	[controller setBccRecipients:nil];
	[controller setCcRecipients:nil];
	[controller setSubject:subject];
	[controller setMessageBody:@"" isHTML:NO]; 
	[controller setToRecipients:[NSArray arrayWithObject:to]];
	[self presentModalViewController:controller animated:YES];
	[controller release];
	
}

- (void)showShareAppMailController {
	
	NSDictionary *settingsDictionary = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Config" ofType:@"plist"]];
	NSString *subject = [[settingsDictionary objectForKey:@"ShareApp"] objectForKey:@"Subject"];
	NSString *body = [[settingsDictionary objectForKey:@"ShareApp"] objectForKey:@"Body"];
	NSString *appUrl = [settingsDictionary objectForKey:@"iTunesLink"];
	NSString *contents = [NSString stringWithFormat:@"%@%@<a href=\"%@\">%@</a>", body, @"\n\n", appUrl, appUrl];
	
	MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
	controller.mailComposeDelegate = self;
	[controller setBccRecipients:nil];
	[controller setCcRecipients:nil];
	[controller setSubject:subject];
	[controller setMessageBody:contents isHTML:YES]; 
	[self presentModalViewController:controller animated:YES];
	[controller release];
	
}

- (void)showSendCouponMailController {
	
	NSDictionary *settingsDictionary = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Config" ofType:@"plist"]];
	NSString *subject = [[settingsDictionary objectForKey:@"Coupon"] objectForKey:@"Subject"];
	NSString *imageUrl = [[settingsDictionary objectForKey:@"Coupon"] objectForKey:@"ImageUrl"];
	NSString *linkUrl = [[settingsDictionary objectForKey:@"Coupon"] objectForKey:@"LinkUrl"];
	NSString *contents = [NSString stringWithFormat:@"Here's something I'd think you'd be interested in.  Click <a href=\"%@\">here</a> to visit the website.", linkUrl];
	
	NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:imageUrl]
											  cachePolicy:NSURLRequestUseProtocolCachePolicy
										  timeoutInterval:20.0];
	
	NSData *couponImageData = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:nil error:nil];
	MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
	controller.mailComposeDelegate = self;
	[controller setBccRecipients:nil];
	[controller setCcRecipients:nil];
	[controller setSubject:subject];
	[controller setMessageBody:contents isHTML:YES];
	
	if (couponImageData)  {
		[controller addAttachmentData:couponImageData mimeType:@"img/png" fileName:@"coupon.jpg"];
		
	}
	
	[self presentModalViewController:controller animated:YES];
	[controller release];
	
}

-(void)openFacebook {
	NSDictionary *settingsDictionary = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Config" ofType:@"plist"]];
	NSString *facebookUrl = [settingsDictionary objectForKey:@"FacebookUrl"];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:facebookUrl]];	
}

-(void) callNumberOne {
	NSDictionary *settingsDictionary = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Config" ofType:@"plist"]];
	NSString *phoneNumber = [settingsDictionary objectForKey:@"PhoneNumber1"];
	NSString *fullPhoneNumber = [NSString stringWithFormat:@"tel:%@", phoneNumber];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:fullPhoneNumber]];	
	NSLog(@"Phoning: %@", fullPhoneNumber);
}


-(void) callNumberTwo {
	NSDictionary *settingsDictionary = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Config" ofType:@"plist"]];
	NSString *phoneNumber = [settingsDictionary objectForKey:@"PhoneNumber2"];
	NSString *fullPhoneNumber = [NSString stringWithFormat:@"tel:%@", phoneNumber];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:fullPhoneNumber]];	
	NSLog(@"Phoning: %@", fullPhoneNumber);
}

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

-(void)viewDidLoad  {
    [super viewDidLoad];
		
}

- (void)dealloc {
	[feedbackTableView release];
	[super dealloc];
}


@end
