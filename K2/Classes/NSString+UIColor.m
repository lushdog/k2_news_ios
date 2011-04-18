//
//  NSString+UIColor.m
//  K2
//
//  Created by Matt Moore on 11-04-18.
//  Copyright 2011 Matt Moore. All rights reserved.
//

#import "NSString+UIColor.h"


@implementation NSString (NSStringToUIColor)

- (UIColor *)toUIColor {
    unsigned int c;
    if ([self characterAtIndex:0] == '#') {
        [[NSScanner scannerWithString:[self substringFromIndex:1]] scanHexInt:&c];
    } else {
        [[NSScanner scannerWithString:self] scanHexInt:&c];
    }
    return [UIColor colorWithRed:((c & 0xff0000) >> 16)/255.0 green:((c & 0xff00) >> 8)/255.0 blue:(c & 0xff)/255.0 alpha:1.0];
}
@end

