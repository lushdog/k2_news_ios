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

#ifndef DEBUG
	NSDictionary *settingsDictionary = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Config" ofType:@"plist"]];
	NSString *videoFile = [[NSString alloc] initWithString:[settingsDictionary objectForKey:@"IntroVideo"]];
    NSArray *chunks = [videoFile componentsSeparatedByString: @"."];
    NSString *path = [[NSBundle mainBundle] pathForResource:[chunks objectAtIndex:0  ] ofType:[chunks objectAtIndex:1]];
	NSURL *url = [NSURL fileURLWithPath:path];
	player = [[MPMoviePlayerController alloc] initWithContentURL:url];
	player.view.frame = self.view.frame;
	player.fullscreen = YES;
	player.controlStyle = MPMovieControlStyleNone;
	[self.view addSubview:player.view];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endPlay:) name:MPMoviePlayerPlaybackDidFinishNotification object:player];
	[player play];
    [settingsDictionary release];
    [videoFile release];
#endif
    
#ifdef DEBUG
    
    [tabControllerContainer performSelector:@selector(removeSplashScreen) withObject:nil afterDelay:1];

#endif
    
    [super viewDidLoad];		
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
