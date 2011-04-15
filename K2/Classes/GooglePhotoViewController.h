//
//  GoolgePhotoViewController.h
//  YurisApp
//
//  Created by Matt Moore on 11-04-02.
//  Copyright 2011 None. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDataPhotos.h"
#import "GooglePhotoAlbum.h"

@interface GooglePhotoViewController : UIViewController <UIScrollViewDelegate> {
 
    UIScrollView *scrollView;
    UILabel *tagLabel;
    UIImageView *imageView;
    NSArray *googlePhotoAlbums;
    NSUInteger currentAlbumIndex;
    NSUInteger currentPhotoIndex;
    UILabel *photoTagLabel;
    UIView *loadingScreen;
    UIActivityIndicatorView *loadingSpinner;
}

@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UILabel *tagLabel;
@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) NSArray *googlePhotoAlbums;
@property (nonatomic, retain) UILabel *photoTagLabel;
@property (nonatomic, retain) UIView *loadingScreen;
@property (nonatomic, retain) UIView *loadingSpinner;

- (void) fetchImage:(NSString*)urlString;
- (void) loadCurrentPhoto;
- (void) loadPreviousImage;
- (void) loadNextImage;
- (id) initWithAlbums:(NSArray*)photoAlbums startAlbumIndex:(NSUInteger)albumIndex startPhotoIndex:(NSUInteger)photoIndex;
- (void) showLoadingScreen;
- (void) hideLoadingScreen;
- (GDataEntryPhoto*) getCurrentPhoto;
- (GooglePhotoAlbum*) getCurrentAlbum;

@end
