//
//  GoolgePhotoViewController.h
//  YurisApp
//
//  Created by Matt Moore on 11-04-02.
//  Copyright 2011 None. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDataPhotos.h"

@interface GooglePhotoViewController : UIViewController <UIScrollViewDelegate> {
 
    UIScrollView *scrollView;
    UILabel *tagLabel;
    UIImageView *imageView;
    NSArray *googlePhotoAlbums;
    GDataEntryPhoto *currentPhoto;
    NSUInteger currentAlbumIndex;
    NSUInteger currentPhotoIndex;
}

@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UILabel *tagLabel;
@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) NSArray *googlePhotoAlbums;
@property (nonatomic, retain) GDataEntryPhoto *currentPhoto;

- (void) fetchImage:(NSString*)urlString;
- (void) loadCurrentPhoto;
- (void) loadPreviousImage;
- (void) loadNextImage;
- (id) initWithAlbums:(NSArray*)photoAlbums startAlbumIndex:(NSUInteger)albumIndex startPhotoIndex:(NSUInteger)photoIndex;

@end
