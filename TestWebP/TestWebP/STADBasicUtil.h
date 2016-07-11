//
//  STADBasicUtil.h
//  STAD
//
//  Created by jinkai on 13-10-22.
//  Copyright (c) 2013年 jinkai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STADBasicUtil : NSObject

+ (NSString *)encodeBase64String:(NSString *)input;
+ (NSString *)decodeBase64String:(NSString *)input;
+ (NSString *)encodeBase64Data:(NSData *)data;
+ (NSString *)decodeBase64Data:(NSData *)data;

@end
