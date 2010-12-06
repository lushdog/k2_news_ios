//
//  CategoryViewCell.h
//
//  Created by matt on 10-09-19.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CategoryViewCell : UITableViewCell {
	
	UILabel *categoryLabel;
	UIImageView *categoryImageView;
}

@property(nonatomic, retain) IBOutlet UILabel *categoryLabel;
@property(nonatomic, retain) IBOutlet UIImageView *categoryImageView;

@end
