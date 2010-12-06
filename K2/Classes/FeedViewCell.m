
#import "FeedViewCell.h"


@implementation FeedViewCell

@synthesize titleLabel, descriptionLabel, imageBox;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        // Initialization code
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)dealloc {
	[titleLabel release];
	[descriptionLabel release];
	[imageBox release];
    [super dealloc];
}


@end
