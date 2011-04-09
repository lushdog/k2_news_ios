//
//  AppDelegate.h
//
//  Created by matt on 10-08-28.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "FeedViewController.h"
#import "CategoryViewController.h"
#import "FeedbackViewController.h"
#import "SplashScreenViewController.h"
#import "GoogleAlbumViewController.h"


@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    TabBarViewController *tabBarController;
	UINavigationController *homeViewNavigationController;
	FeedViewController *homeViewController;
	UINavigationController *feedNavigationController;
	FeedViewController *feedViewController;
	CategoryViewController *categoryViewController;
	FeedbackViewController *feedbackViewController;
    GoogleAlbumViewController *googleAlbumViewController;
    UINavigationController *photoNaviagationController;
	UINavigationController *feedbackNavigationController;
	NSMutableArray *feedList;
	SplashScreenViewController *splashScreenViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) TabBarViewController *tabBarController;
@property (nonatomic, retain) FeedViewController *homeViewController;
@property (nonatomic, retain) UINavigationController *homeViewNavigationController;
@property (nonatomic, retain) UINavigationController	*feedNavigationController;
@property (nonatomic, retain) CategoryViewController *categoryViewController;
@property (nonatomic, retain) NSMutableArray *feedList;
@property (nonatomic, retain) UINavigationController *feedbackNavigationController;
@property (nonatomic, retain) FeedbackViewController *feedbackViewController;
@property (nonatomic, retain) SplashScreenViewController *splashScreenViewController;
@property (nonatomic, retain) GoogleAlbumViewController *googleAlbumViewController;
@property (nonatomic, retain) UINavigationController *photoNavigationController;

@end

