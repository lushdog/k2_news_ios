
#import <UIKit/UIKit.h>
#import "MWFeedItem.h"
#import "asyncimageview.h"
#import "Feed.h"


@interface FeedItemViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UIWebViewDelegate> {

	/*UILabel *titleLabel;
	UILabel *sourceLabel;
	UILabel *authorLabel;
	UILabel *dateLabel;
	UIImageView *feedImageView;
	UILabel *feedContent;
	UIScrollView *scrollView;*/
	
	NSDateFormatter *formatter;
	MWFeedItem *feedItem;
	Feed *feed;
	UIImage *feedItemImage;
	UITableView *feedItemTableView;
	UIView *loadingBackground;
	UIActivityIndicatorView *loadingSpinner;
}
/*
@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet UILabel *sourceLabel;
@property (nonatomic, retain) IBOutlet UILabel *authorLabel;
@property (nonatomic, retain) IBOutlet UILabel *dateLabel;
@property (nonatomic, retain) IBOutlet UIImageView *feedImageView;
@property (nonatomic, retain) IBOutlet UILabel *feedContent;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
*/

@property (nonatomic, retain) MWFeedItem *feedItem;
@property (nonatomic, retain) NSDateFormatter *formatter;
@property (nonatomic, retain) UIImage *feedItemImage;
@property (nonatomic, retain) Feed *feed;
@property (nonatomic, retain) IBOutlet UITableView *feedItemTableView;
@property (nonatomic, retain) UIView *loadingBackground;
@property (nonatomic, retain) UIActivityIndicatorView *loadingSpinner;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil feedItem:(MWFeedItem *)theFeedItem feed:(Feed *)theFeed feedImage:(UIImage *)theFeedImage;
- (int) heightOfCellWithText :(NSString*)text andFont:(UIFont*)font;

@end
