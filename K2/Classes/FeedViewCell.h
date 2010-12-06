
#import <UIKit/UIKit.h>


@interface FeedViewCell : UITableViewCell {
	
	UILabel *titleLabel;
	UILabel *descriptionLabel;
	UIImageView *imageBox;
}

@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet UILabel *descriptionLabel;
@property (nonatomic, retain) IBOutlet UIImageView *imageBox;
@end
