//
//  STADBasicUtil.m
//  STAD
//
//  Created by jinkai on 13-10-22.
//  Copyright (c) 2013年 jinkai. All rights reserved.
//

#import "STADBasicUtil.h"
#import "STADGTMBase64.h"
#import <AdSupport/ASIdentifierManager.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <SystemConfiguration/CaptiveNetwork.h>

#import <CommonCrypto/CommonCrypto.h>
#import "sys/utsname.h"

#import <sys/sysctl.h>
#include <sys/socket.h>
#include <net/if.h>
#include <net/if_dl.h>
#include <arpa/inet.h>
#include <net/if.h>
#include <ifaddrs.h>
#import <mach/mach.h>
#import <mach/mach_host.h>
#import <sys/xattr.h>

#define STAD_GET_OUTER_IPADDRESS @"STAD_GET_OUTER_IPADDRESS"
#define STAD_GET_OUTER_IPADDRESS_SERVER @"http://fw.qq.com/ipaddress"

@implementation STADBasicUtil

#pragma mark base64
+ (NSString*)encodeBase64String:(NSString* )input {
    NSData*data = [input dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    data = [STADGTMBase64 encodeData:data];
    NSString*base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    return base64String;
}

+ (NSString*)decodeBase64String:(NSString* )input {
    NSData*data = [input dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    data = [STADGTMBase64 decodeData:data];
    NSString*base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    return base64String;
}

+ (NSString*)encodeBase64Data:(NSData*)data {
    data = [STADGTMBase64 encodeData:data];
    NSString* base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    return base64String;
}

+ (NSString*)decodeBase64Data:(NSData*)data {
    data = [STADGTMBase64 decodeData:data];
    NSString* base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] ;
    
    return base64String;
}


@end

