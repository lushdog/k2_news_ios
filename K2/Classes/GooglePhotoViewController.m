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
#import "AppSettings.h"

@implementation GooglePhotoViewController

@synthesize scrollView, tagLabel, imageView, googlePhotoAlbums,
            photoTagLabel, loadingScreen, loadingSpinner;

- (id)initWithAlbums:(NSArray*)photoAlbums startAlbumIndex:(NSUInteger)albumIndex startPhotoIndex:(NSUInteger)photoIndex  {
    
    self = [super init];
    if (self) {
        currentAlbumIndex = albumIndex;
        currentPhotoIndex = photoIndex;
        googlePhotoAlbums = photoAlbums;
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

- (void)loadView 
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 420)];
    self.view = view;
    self.view.autoresizesSubviews = YES;
    [view release];
}

- (void)viewDidLoad
{
    scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    [scrollView setClipsToBounds:YES];
    [scrollView setScrollEnabled:YES];
    [scrollView setMinimumZoomScale:1.0f];
    [scrollView setMaximumZoomScale:4.0f];
    [scrollView setBackgroundColor:[AppSettings backgroundColor]];
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    
    photoTagLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];photoTagLabel.textColor = [AppSettings textColor1];
    photoTagLabel.backgroundColor = [AppSettings backgroundColor];
    photoTagLabel.textAlignment = UITextAlignmentCenter;
    photoTagLabel.alpha = 0.75f;
    [self.view addSubview:photoTagLabel];
    
    loadingScreen = [[UIView alloc] initWithFrame:scrollView.frame];
    loadingScreen.backgroundColor = [UIColor grayColor];
    loadingScreen.alpha = 0.75f;
    [self.view addSubview:loadingScreen];
    
    loadingSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    loadingSpinner.frame = CGRectMake(scrollView.center.x - loadingSpinner.frame.size.width/2, scrollView.center.y - loadingSpinner.frame.size.height / 2, loadingSpinner.frame.size.width, loadingSpinner.frame.size.height);
    loadingSpinner.hidesWhenStopped = YES;
    [loadingSpinner stopAnimating];
    [self.view addSubview:loadingSpinner];
                    
    UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(loadNextImage)];
    [leftSwipe setDirection:UISwipeGestureRecognizerDirectionLeft];
    [scrollView addGestureRecognizer:leftSwipe];
    [leftSwipe release];
    
    UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(loadPreviousImage)];
    [rightSwipe setDirection:UISwipeGestureRecognizerDirectionRight];
    [scrollView addGestureRecognizer:rightSwipe];
    [rightSwipe release];
    
    imageView = [[UIImageView alloc] initWithFrame:scrollView.frame];
    [imageView setBackgroundColor:[AppSettings backgroundColor]];
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    
    [scrollView addSubview:imageView];
    
    [self loadCurrentPhoto];
    
    [super viewDidLoad];
}

-(void)loadPreviousImage {
    
    NSLog(@"Swiped previous image.");
    
    NSUInteger newPhotoIndex = currentPhotoIndex; 
    NSUInteger newAlbumIndex = currentAlbumIndex;
    
    if (currentPhotoIndex == 0) {
        if (currentAlbumIndex > 0)  {
            newAlbumIndex = currentAlbumIndex - 1; 
            
            NSUInteger numPhotosInNewAlbum = [((GooglePhotoAlbum*)[googlePhotoAlbums objectAtIndex:newAlbumIndex]).photos count];
            if (numPhotosInNewAlbum > 0)
                newPhotoIndex =  numPhotosInNewAlbum - 1;
        }//else: at start of photo list
    }
    else {
        newPhotoIndex = currentPhotoIndex - 1;
    }
    
    if (newPhotoIndex != currentPhotoIndex || newAlbumIndex != currentAlbumIndex)  {
        currentPhotoIndex = newPhotoIndex;
        currentAlbumIndex = newAlbumIndex;
        if ([[self getCurrentAlbum].photos count] > 0)
        {
            [self loadCurrentPhoto];
        }
    }
}

-(void)loadNextImage  {
    
    NSLog(@"Swiped next image.");
    
    NSUInteger newPhotoIndex = currentPhotoIndex; 
    NSUInteger newAlbumIndex = currentAlbumIndex;
    NSUInteger numPhotosInCurrentAlbum = [[self getCurrentAlbum].photos count];
    
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
        if ([[self getCurrentAlbum].photos count] > 0)
        {
            [self loadCurrentPhoto];
        }
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView  {
    return imageView;
}

- (void) loadCurrentPhoto  {
    [self showLoadingScreen];
    photoTagLabel.text =  [[[self getCurrentPhoto] photoDescription] contentStringValue];
    self.title = [[[self getCurrentAlbum].album title] stringValue];
    NSArray *pictures = [[[self getCurrentPhoto] mediaGroup] mediaContents]; 
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
    [self hideLoadingScreen];
}

- (void)imageFetcher:(GDataHTTPFetcher *)fetcher failedWithError:(NSError *)error {
    NSLog(@"imageFetcher:%@ failedWithError:%@", fetcher,  error);       
    [self hideLoadingScreen];
}

- (void) showLoadingScreen  {
    
    loadingScreen.hidden = NO;
    [loadingSpinner startAnimating];
    
}

- (void) hideLoadingScreen  {
    
    loadingScreen.hidden = YES;
    [loadingSpinner stopAnimating];
    
}

- (GDataEntryPhoto*) getCurrentPhoto  {
    
    return [((GooglePhotoAlbum*)[googlePhotoAlbums objectAtIndex:currentAlbumIndex]).photos objectAtIndex:currentPhotoIndex];
}

- (GooglePhotoAlbum*) getCurrentAlbum  {
    
    return (GooglePhotoAlbum*)[googlePhotoAlbums objectAtIndex:currentAlbumIndex];
    
}

- (void)viewDidUnload {
    
    [scrollView dealloc];
    [imageView dealloc];
    [tagLabel dealloc];
    [googlePhotoAlbums dealloc];
    [loadingScreen dealloc];
    [loadingSpinner dealloc];
    [photoTagLabel dealloc];
    
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
