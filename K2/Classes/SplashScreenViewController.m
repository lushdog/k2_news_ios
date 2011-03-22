//
//  SplashScreenViewController.m
//
//  Created by matt on 10-09-18.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SplashScreenViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "GDataPhotos.h"

@implementation SplashScreenViewController

@synthesize player, tabControllerContainer;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    
	GDataServiceGooglePhotos *photoService = [[GDataServiceGooglePhotos alloc] init];
	[photoService setUserCredentialsWithUsername:@"k2martialartsottawa" 
										password:@"k2martialarts@123"];
	NSURL *feedUrl = [GDataServiceGooglePhotos photoFeedURLForUserID:@"k2martialartsottawa" albumID:nil albumName:nil photoID:nil kind:@"album" access:nil];
	GDataServiceTicket *ticket = [photoService fetchFeedWithURL:feedUrl delegate:self didFinishSelector:@selector(ticket:finishedWithFeed:error:)];
		
	//TODO: load from .plist
	NSString *path = [[NSBundle mainBundle] pathForResource:@"intro" ofType:@"m4v"];
	NSURL *url = [NSURL fileURLWithPath:path];
	player = [[MPMoviePlayerController alloc] initWithContentURL:url];
	player.view.frame = self.view.frame;
	player.fullscreen = YES;
	player.controlStyle = MPMovieControlStyleNone;
	[self.view addSubview:player.view];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endPlay:) name:MPMoviePlayerPlaybackDidFinishNotification object:player];
	[player play];
	[super viewDidLoad];		
}

- (void)ticket:(GDataServiceTicket *)ticket 
		finishedWithFeed:(GDataFeedPhotoAlbum *)feed 
		error:(NSError *) error  {
	
	if (error)
		NSLog(@"Error retrieving photo albums: %@", error);
	else {
		NSArray *albums = [feed entries];
		for(GDataEntryPhotoAlbum *album in albums)  {
			NSLog(@"Found album: %@", [[album title] contentStringValue]);
		}
	}	
}

- (void)endPlay:(NSNotification*)notification {

	[tabControllerContainer performSelector:@selector(removeSplashScreen) withObject:nil afterDelay:1];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[player	dealloc];
    [super dealloc];
}


@end
