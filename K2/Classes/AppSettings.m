//
//  AppSettings.m
//  K2
//
//  Created by Matt Moore on 11-04-18.
//  Copyright 2011 Matt Moore. All rights reserved.
//

#import "AppSettings.h"
#import "NSString+UIColor.h"


@implementation AppSettings 

+ (AppSettings *)instance  {
    
	static AppSettings *instance;
	
	@synchronized(self) {
		if(!instance) {
			instance = [[AppSettings alloc] init];
		}
	}
    
	return instance;
}

+ (NSDictionary *)settingsDictionary  {
    return [[[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Config" ofType:@"plist"]] autorelease];
}

+ (NSString *)couponImageURL  {
    return [[[self settingsDictionary] objectForKey:@"Coupon"] objectForKey:@"ImageUrl"];
}

+ (NSString *)couponLinkURL {
    return [[[self settingsDictionary] objectForKey:@"Coupon"] objectForKey:@"LinkUrl"];
}

+ (NSString *)couponSubject {
    return [[[self settingsDictionary] objectForKey:@"Coupon"] objectForKey:@"Subject"];
}

+ (NSString *)facebookURL {
    return [[self settingsDictionary] objectForKey:@"FacebookUrl"];
}

+ (NSString *)feedbackSubject { 
    return [[[self settingsDictionary] objectForKey:@"FeedBack"] objectForKey:@"Subject"]; 
}

+ (NSString *)feedbackToAddress; { 
    return [[[self settingsDictionary] objectForKey:@"FeedBack"] objectForKey:@"To"]; 
}

+ (NSArray *)feedImages {
    return [[self settingsDictionary] objectForKey:@"FeedImages"];
}

+ (NSArray *)feedURLs {
    return [[self settingsDictionary] objectForKey:@"FeedUrls"];
}

+ (NSArray *)feedNames {
    return [[self settingsDictionary] objectForKey:@"FeedNames"];}

+ (NSString *)introVideo {
    return [[self settingsDictionary] objectForKey:@"IntroVideo"];
}

+ (NSString *)itunesURL  {
    return [[self settingsDictionary] objectForKey:@"iTunesLink"];
}

+ (NSString *)phoneNumber1 {
    return [[self settingsDictionary] objectForKey:@"PhoneNumber1"];
}

+ (NSString *)phoneNumber2 {
    return [[self settingsDictionary] objectForKey:@"PhoneNumber2"];
}

+ (NSString *)picasaUsername {
   return [[[self settingsDictionary] objectForKey:@"PicasaCreds"] objectForKey:@"PicasaUsername"];
}

+ (NSString *)picasaPassword {
    return [[[self settingsDictionary] objectForKey:@"PicasaCreds"] objectForKey:@"PicasaPassword"];}

+ (NSString *)shareAppBody  {
    return [[[self settingsDictionary] objectForKey:@"ShareApp"] objectForKey:@"Body"];
}

+ (NSString *)shareAppSubject {
    return  [[[self settingsDictionary] objectForKey:@"ShareApp"] objectForKey:@"Subject"];
}

+ (UIColor *)backgroundColor {
    return  [(NSString*)[[self settingsDictionary] objectForKey:@"BackgroundColor"] toUIColor];
}

+ (UIColor *)rowColor {
    return  [(NSString*)[[self settingsDictionary] objectForKey:@"RowColor"] toUIColor];
}

+ (UIColor *)textColor1 {
    return  [(NSString*)[[self settingsDictionary] objectForKey:@"TextColor1"] toUIColor];
}

+ (UIColor *)textColor2 {
    return  [(NSString*)[[self settingsDictionary] objectForKey:@"TextColor2"] toUIColor];
}



@end
