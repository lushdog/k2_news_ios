
#import <UIKit/UIKit.h>

@interface CategoryViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	NSMutableArray *feedList;
	UITableView *categoryTableView;
}

@property (nonatomic, retain) NSMutableArray *feedList;
@property (nonatomic, retain) IBOutlet UITableView *categoryTableView;

@end