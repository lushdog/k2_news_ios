    //
//  CategoryViewCell.m
//
//  Created by matt on 10-09-19.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CategoryViewCell.h"


@implementation CategoryViewCell

@synthesize categoryLabel, categoryImageView;

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
	[categoryLabel release];
	[categoryImageView release];
    [super dealloc];
}


@end
