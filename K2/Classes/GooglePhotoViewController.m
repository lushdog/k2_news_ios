//
//  GoolgePhotoViewController.m
//  YurisApp
//
//  Created by Matt Moore on 11-04-02.
//  Copyright 2011 None. All rights reserved.
//

#import "GooglePhotoViewController.h"
#import "GDataPhotos.h"
#import "GooglePhotoAlbum.h"

@implementation GooglePhotoViewController

@synthesize scrollView, tagLabel, imageView, currentPhoto, googlePhotoAlbums;

/*- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
*/

- (id)initWithAlbums:(NSArray*)photoAlbums startAlbumIndex:(NSUInteger)albumIndex startPhotoIndex:(NSUInteger)photoIndex  {
    
    self = [super init];
    if (self) {
        currentAlbumIndex = albumIndex;
        currentPhotoIndex = photoIndex;
        googlePhotoAlbums = photoAlbums;
        currentPhoto = [((GooglePhotoAlbum*)[photoAlbums objectAtIndex:currentAlbumIndex]).photos objectAtIndex:currentPhotoIndex];
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    //TODO: support left swipe and right swipe for photos
    //      support up swipe and down swipe for albums
    //      add label at bottom for photo tag
    //      add label at top for album tag
    
    scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    [scrollView setClipsToBounds:YES];
    [scrollView setScrollEnabled:YES];
    [scrollView setMinimumZoomScale:1.0f];
    [scrollView setMaximumZoomScale:4.0f];
    [scrollView setBackgroundColor:[UIColor blackColor]];
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    
    UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(loadNextImage)];
    [leftSwipe setDirection:UISwipeGestureRecognizerDirectionLeft];
    [scrollView addGestureRecognizer:leftSwipe];
    [leftSwipe release];
    
    UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(loadPreviousImage)];
    [rightSwipe setDirection:UISwipeGestureRecognizerDirectionRight];
    [scrollView addGestureRecognizer:rightSwipe];
    [rightSwipe release];
    
    imageView = [[UIImageView alloc] initWithFrame:scrollView.frame];
    [imageView setBackgroundColor:[UIColor blackColor]];
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    
    [scrollView addSubview:imageView];
    
    [self loadCurrentPhoto];
    
    [super viewDidLoad];
}

-(void)loadPreviousImage {
    
    NSUInteger newPhotoIndex = currentPhotoIndex; 
    NSUInteger newAlbumIndex = currentAlbumIndex;
    
    if (currentPhotoIndex == 0) {
        if (currentAlbumIndex > 0)  {
            newAlbumIndex = currentAlbumIndex - 1; 
            
            NSUInteger numPhotosInNewAlbum = [((GooglePhotoAlbum*)[googlePhotoAlbums objectAtIndex:newAlbumIndex]).photos count];
            if (numPhotosInNewAlbum > 0)
                newPhotoIndex =  - 1;
        }//else: at start of photo list
    }
    else {
        newPhotoIndex = currentPhotoIndex - 1;
    }
    
    if (newPhotoIndex != currentPhotoIndex || newAlbumIndex != currentAlbumIndex)  {
        currentPhotoIndex = newPhotoIndex;
        currentAlbumIndex = newAlbumIndex;
        GooglePhotoAlbum *currentAlbum = ((GooglePhotoAlbum*)[googlePhotoAlbums objectAtIndex:currentAlbumIndex]);
        if ([currentAlbum.photos count] > 0)
        {
            currentPhoto = [currentAlbum.photos objectAtIndex:newPhotoIndex];
            [self loadCurrentPhoto];
        }
    }
}

-(void)loadNextImage  {
    
    NSUInteger newPhotoIndex = currentPhotoIndex; 
    NSUInteger newAlbumIndex = currentAlbumIndex;
    
    GooglePhotoAlbum *currentAlbum = [googlePhotoAlbums objectAtIndex:currentAlbumIndex];
    NSUInteger numPhotosInCurrentAlbum = [currentAlbum.photos count];
    
    if (currentPhotoIndex == numPhotosInCurrentAlbum - 1 || numPhotosInCurrentAlbum == 0) {
        if (currentAlbumIndex + 1 < [googlePhotoAlbums count])  {
            newAlbumIndex = currentAlbumIndex +1;
            newPhotoIndex = 0;
        } //else: at end of photo list
    }
    else {
        newPhotoIndex = currentPhotoIndex + 1;
    }
    
    if (newPhotoIndex != currentPhotoIndex || newAlbumIndex != currentAlbumIndex)  {
        currentPhotoIndex = newPhotoIndex;
        currentAlbumIndex = newAlbumIndex;
        GooglePhotoAlbum *currentAlbum = ((GooglePhotoAlbum*)[googlePhotoAlbums objectAtIndex:currentAlbumIndex]);
        if ([currentAlbum.photos count] > 0)
        {
            currentPhoto = [currentAlbum.photos objectAtIndex:newPhotoIndex];
            [self loadCurrentPhoto];
        }
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView  {
    return imageView;
}

- (void) loadCurrentPhoto  {
    NSArray *pictures = [[currentPhoto mediaGroup] mediaContents]; 
    NSString *imageURLString = [[pictures objectAtIndex:0] URLString];
    [self fetchImage:imageURLString];
}

- (void) fetchImage:(NSString*)urlString  {
    
    NSURL *imageURL = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:imageURL];
    GDataHTTPFetcher *fetcher = [GDataHTTPFetcher httpFetcherWithRequest:request];
    [fetcher beginFetchWithDelegate:self
                  didFinishSelector:@selector(imageFetcher:finishedWithData:)
                    didFailSelector:@selector(imageFetcher:failedWithError:)];
    
}

- (void)imageFetcher:(GDataHTTPFetcher *)fetcher finishedWithData:(NSData *)data {
	imageView.image = [UIImage imageWithData:data];
}

- (void)imageFetcher:(GDataHTTPFetcher *)fetcher failedWithError:(NSError *)error {
    NSLog(@"imageFetcher:%@ failedWithError:%@", fetcher,  error);       
}


- (void)viewDidUnload {
    
    [scrollView dealloc];
    [imageView dealloc];
    [tagLabel dealloc];
    [currentPhoto dealloc];
    [googlePhotoAlbums dealloc];
    
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
