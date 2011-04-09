//
//  AppDelegate.m
//
//  Created by matt on 10-08-28.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "AppDelegate.h"
#import "FeedViewController.h"
#import "CategoryViewController.h"
#import "SplashScreenViewController.h"
#import "TabBarViewController.h"
#import <MessageUI/MessageUI.h> 
#import <MediaPlayer/MediaPlayer.h>

@implementation AppDelegate

@synthesize window;
@synthesize tabBarController, homeViewController, homeViewNavigationController, 
feedNavigationController, categoryViewController, feedList, feedbackViewController, 
feedbackNavigationController, splashScreenViewController, googleAlbumViewController, photoNavigationController;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.
	// Add the view controller's view to the window and display.
    
	splashScreenViewController = [[SplashScreenViewController alloc] initWithNibName:@"SplashScreenView" bundle:[NSBundle mainBundle]];
	
	tabBarController = [[TabBarViewController alloc] initWithNibName:nil bundle:nil];	
	
	NSDictionary *settingsDictionary = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Config" ofType:@"plist"]];
	NSArray *feedNames = [[NSArray alloc] initWithArray:[settingsDictionary objectForKey:@"FeedNames"]];
	NSArray *feedUrls =[[NSArray alloc] initWithArray:[settingsDictionary objectForKey:@"FeedUrls"]];
	NSArray *feedImages = [[NSArray alloc] initWithArray:[settingsDictionary objectForKey:@"FeedImages"]];
	
	feedList = [[NSMutableArray alloc] init];
	for (int i=0; i < feedNames.count; i++) {
		Feed *feed = [[Feed alloc] initWithName:(NSString *)[feedNames objectAtIndex:i] url:(NSString *)[feedUrls objectAtIndex:i] image:(NSString *)[feedImages objectAtIndex:i]];
		[feedList addObject:feed];
	}
	
    //TODO: preload controllers during playing of movie
    
	homeViewController = [[FeedViewController alloc] initWithNibName:@"FeedView" bundle:[NSBundle mainBundle] feed:[feedList objectAtIndex:0]];
	homeViewController.title = @"Home";
	homeViewController.tabBarItem.image = [UIImage imageNamed:@"home.png"];
	homeViewNavigationController = [[UINavigationController alloc] initWithRootViewController:homeViewController]; 
	
	categoryViewController  = [[CategoryViewController alloc] initWithNibName:@"CategoryView" bundle:[NSBundle mainBundle]] ;
	categoryViewController.feedList = feedList;
	categoryViewController.title = @"Categories";
	categoryViewController.tabBarItem.image = [UIImage imageNamed:@"categories.png"];
    feedNavigationController = [[UINavigationController alloc] initWithRootViewController:categoryViewController];
	
    googleAlbumViewController = [[GoogleAlbumViewController alloc] init];
    googleAlbumViewController.title = @"Photos";
    googleAlbumViewController.tabBarItem.image = [UIImage imageNamed:@"photos.png"];
    photoNavigationController = [[UINavigationController alloc] initWithRootViewController:googleAlbumViewController];
    
	feedbackViewController = [[FeedbackViewController alloc] initWithNibName:@"FeedbackView" bundle:[NSBundle mainBundle]];
	feedbackViewController.title = @"Share";
	feedbackViewController.tabBarItem.image = [UIImage imageNamed:@"more.png"];
	feedbackNavigationController = [[UINavigationController alloc] initWithRootViewController:feedbackViewController];
	
	NSArray *tabItems = [NSArray arrayWithObjects:homeViewNavigationController, feedNavigationController, googleAlbumViewController, feedbackNavigationController, nil];
	[tabBarController setViewControllers:tabItems];	
	[tabItems release];
	
	[window addSubview:tabBarController.view];
	splashScreenViewController.tabControllerContainer = tabBarController;
		
	if ( kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iPhoneOS_3_2 ) {
		[tabBarController presentModalViewController:splashScreenViewController animated:NO];
	}
	
	[window makeKeyAndVisible];
	return YES;
}
	
					   
					   
- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    [window release];
	[tabBarController release];
	[homeViewController release];
	[homeViewNavigationController release];
	[feedNavigationController release];
	[feedList release];
	[feedbackViewController release];
	[feedbackNavigationController release];
	[splashScreenViewController release];
    [googleAlbumViewController release];
    [photoNavigationController release];
    [super dealloc];
}


@end
