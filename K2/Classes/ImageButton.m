//
//  ImageButton.m
//  YurisApp
//
//  Created by Matt Moore on 11-04-02.
//  Copyright 2011 None. All rights reserved.
//

#import "ImageButton.h"


@implementation ImageButton

@synthesize photo, indexPath, currentPhotoIndex, currentAlbumIndex;

-(void) dealloc  {
    
    [photo dealloc];
    [indexPath dealloc];
    [super dealloc];
}

@end
