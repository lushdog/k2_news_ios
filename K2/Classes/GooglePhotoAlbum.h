//
//  GooglePhotoAlbum.h
//  YurisApp
//
//  Created by matt on 11-03-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataPhotos.h"

@interface GooglePhotoAlbum : NSObject {
	
	GDataEntryPhotoAlbum *album;
	NSMutableArray *photos;
}

@property (nonatomic, retain) GDataEntryPhotoAlbum *album;
@property (nonatomic, retain) NSMutableArray *photos;

- (GooglePhotoAlbum *)init;

@end
