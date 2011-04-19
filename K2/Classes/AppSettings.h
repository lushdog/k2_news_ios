//
//  AppSettings.h
//  K2
//
//  Created by Matt Moore on 11-04-18.
//  Copyright 2011 Matt Moore. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AppSettings : NSObject {
}



+ (AppSettings *)instance;

+ (NSDictionary *)settingsDictionary;

+ (NSString *)couponImageURL;
+ (NSString *)couponLinkURL;
+ (NSString *)couponSubject;

+ (NSString *)facebookURL;

+ (NSString *)feedbackSubject;
+ (NSString *)feedbackToAddress;

+ (NSArray *)feedImages;
+ (NSArray *)feedURLs;
+ (NSArray *)feedNames;

+ (NSString *)introVideo;

+ (NSString *)itunesURL;

+ (NSString *)phoneNumber1;
+ (NSString *)phoneNumber2;

+ (NSString *)picasaUsername;
+ (NSString *)picasaPassword;

+ (NSString *)shareAppBody;
+ (NSString *)shareAppSubject;

+ (UIColor *)backgroundColor;
+ (UIColor *)rowColor;
+ (UIColor *)textColor1;
+ (UIColor *)textColor2;


@end
