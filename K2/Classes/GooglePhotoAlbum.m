//
//  GooglePhotoAlbum.m
//  YurisApp
//
//  Created by matt on 11-03-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GooglePhotoAlbum.h"

@implementation GooglePhotoAlbum

@synthesize album, photos;

- (GooglePhotoAlbum*) init {
	
	self = [super init];
	if (self)  {		
		photos = [[NSMutableArray alloc] initWithCapacity:5];
		album = [[GDataEntryPhotoAlbum alloc] init];
		return self;	
	}	
	return self;
}

-(void) dealloc {
    
    [photos dealloc];
    [album dealloc];
    [super dealloc];
}

@end
