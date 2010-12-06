//
//  Feed.m
//  Created by matt on 10-09-05.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Feed.h"


@implementation Feed

@synthesize feedName;
@synthesize feedUrl;
@synthesize feedImage;

- (id) initWithName:(NSString *)theName url:(NSString *)theUrl image:(NSString *)theImage  {
		
	self.feedName = theName;
	self.feedUrl = theUrl;
	self.feedImage = theImage;	
	return self;
}


- (void)dealloc {
	[feedName release];
	[feedUrl release];
	[feedImage release];
    [super dealloc];
}


@end
