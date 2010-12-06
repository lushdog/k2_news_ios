//
//  Feed.h
//
//  Created by matt on 10-09-05.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

@interface Feed : NSObject {
	NSString *feedName;
	NSString *feedUrl;
	NSString *feedImage;
}

@property (nonatomic, retain) NSString *feedName;
@property (nonatomic, retain) NSString *feedUrl;
@property (nonatomic, retain) NSString *feedImage;

- (id) initWithName:(NSString *)theName url:(NSString *)theUrl image:(NSString *)theImage;

@end
