//
//  AppDelegate.h
//
//  Created by matt on 10-08-28.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedViewController.h"
#import "CategoryViewController.h"
#import "FeedbackViewController.h"
#import "SplashScreenViewController.h"


@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    UITabBarController *tabBarController;
	UINavigationController *homeViewNavigationController;
	FeedViewController *homeViewController;
	UINavigationController *feedNavigationController;
	FeedViewController *feedViewController;
	CategoryViewController *categoryViewController;
	FeedbackViewController *feedbackViewController;
	UINavigationController *feedbackNavigationController;
	NSMutableArray *feedList;
	SplashScreenViewController *splashScreenViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain) IBOutlet FeedViewController *homeViewController;
@property (nonatomic, retain) IBOutlet UINavigationController *homeViewNavigationController;
@property (nonatomic, retain) IBOutlet UINavigationController	*feedNavigationController;
@property (nonatomic, retain) IBOutlet CategoryViewController *categoryViewController;
@property (nonatomic, retain) NSMutableArray *feedList;
@property (nonatomic, retain) IBOutlet UINavigationController *feedbackNavigationController;
@property (nonatomic, retain) IBOutlet FeedbackViewController *feedbackViewController;
@property (nonatomic, retain) IBOutlet SplashScreenViewController *splashScreenViewController;

@end

