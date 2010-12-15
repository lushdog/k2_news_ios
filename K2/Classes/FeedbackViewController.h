//
//  FeedbackViewController.h
//
//  Created by matt on 10-09-15.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h> 

@interface FeedbackViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate>  {
	UITableView *feedbackTableView;
}

@property (nonatomic, retain) IBOutlet UITableView *feedbackTableView;

- (void)showFeedBackMailController;
- (void)showShareAppMailController;
- (void)showSendCouponMailController;
- (void)openFacebook;
- (void)callNumberOne;
- (void)callNumberTwo;
@end
