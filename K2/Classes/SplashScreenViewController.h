//
//  SplashScreenViewController.h
//  Created by matt on 10-09-18.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "TabBarViewController.h"
@interface SplashScreenViewController : UIViewController {

	MPMoviePlayerController *player;
	TabBarViewController *tabControllerContainer;}

@property (nonatomic, retain) MPMoviePlayerController *player;
@property (nonatomic, retain) TabBarViewController *tabControllerContainer;

@end
