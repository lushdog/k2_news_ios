
#import <UIKit/UIKit.h>
#import "MWFeedParser.h"
#import "Feed.h"
#import "AdViewController.h"

@interface FeedViewController : UIViewController <MWFeedParserDelegate, UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate> {
	
	NSMutableArray *parsedFeeds;	
	MWFeedParser *feedParser;
	Feed *feed;
	NSUInteger numFeedsParsed;
	UITableView *feedTableView;
	UIActivityIndicatorView *loadingSpinner;
	UIImage *defaultFeedImage;	
	NSDictionary *imageCache;
	UIImageView *loadingOverlay;
	AdViewController *adViewController;
}

@property (nonatomic, retain) MWFeedParser *feedParser;
@property (nonatomic, retain) NSMutableArray *parsedFeeds;
@property (nonatomic, retain) IBOutlet UITableView *feedTableView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *loadingSpinner;
@property (nonatomic, retain) IBOutlet UIImage *defaultFeedImage;
@property (nonatomic, retain) NSDictionary *imageCache;
@property (nonatomic, retain) Feed *feed;
@property (nonatomic, retain) IBOutlet UIImageView *loadingOverlay;
@property (nonatomic, retain) IBOutlet AdViewController *adViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil feed:(Feed *)feedToParse;
- (void)startParsing:(NSString *)url;

	
@end