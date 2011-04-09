//
//  ImageButton.h
//  YurisApp
//
//  Created by Matt Moore on 11-04-02.
//  Copyright 2011 None. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataPhotos.h"


@interface ImageButton : UIButton {
    
    GDataEntryPhoto *photo;
    NSUInteger currentAlbumIndex;
    NSUInteger currentPhotoIndex;
}

@property (nonatomic, retain) GDataEntryPhoto *photo;
@property (nonatomic, retain) NSIndexPath *indexPath;
@property NSUInteger currentAlbumIndex;
@property NSUInteger currentPhotoIndex;

@end
