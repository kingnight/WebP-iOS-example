//
//  WebviewController.m
//  TestWebP
//
//  Created by jinkai on 16/7/11.
//  Copyright © 2016年 Carson McDonald. All rights reserved.
//

#import "WebviewController.h"
#import <WebP/decode.h>
#import "STADBasicUtil.h"

#define IMG_CENTER_HTML @"<html><head><script type=\"text/javascript\"> function loaderror(){ document.location = ('staderror://imgloaderror');} </script></head><style>*{margin: 0;padding: -1}</style><img src=\"%@\" onerror=\"loaderror();\" width=\"100%%\" height=\"100%%\"></img></html>"

@implementation WebviewController
{
    NSArray *webpImages;
    WebPDecoderConfig config;
}

- (void)viewDidLoad
{
    webpImages = [[NSBundle mainBundle] pathsForResourcesOfType:@"webp" inDirectory:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self displayImage:[webpImages objectAtIndex:0]];
}

#pragma mark - WebP example

/*
 This gets called when the UIImage gets collected and frees the underlying image.
 */
static void free_image_data(void *info, const void *data, size_t size)
{
    if(info != NULL)
    {
        WebPFreeDecBuffer(&(((WebPDecoderConfig *)info)->output));
    }
    else
    {
        free((void *)data);
    }
}

- (void)displayImage:(NSString *)filePath
{
    NSLog(@"* * * * * * * * * * *");
    
    NSDate *startTime = [NSDate date];
    
    // Find the path of the selected WebP image in the bundle and read it into memory
    NSData *myData = [NSData dataWithContentsOfFile:filePath];
    
    NSLog(@"Time to read data: %0.2fms", [startTime timeIntervalSinceNow] * -1000.0);
    
    // Get the current version of the WebP decoder
    int rc = WebPGetDecoderVersion();
    
    NSLog(@"Version: %d", rc);
    
    startTime = [NSDate date];
    
    // Get the width and height of the selected WebP image
    int width = 0;
    int height = 0;
    WebPGetInfo([myData bytes], [myData length], &width, &height);
    
    NSLog(@"Time to read info: %0.2fms", [startTime timeIntervalSinceNow] * -1000.0);
    
    NSLog(@"Image Width: %d Image Height: %d", width, height);
    
    CGDataProviderRef provider;
    
//    if(_bypassFilteringSwitch.on || _noFancyUpsamplingSwitch.on || _useThreadsSwitch.on )
//    {
//        WebPInitDecoderConfig(&config);
//        
//        config.options.no_fancy_upsampling = _noFancyUpsamplingSwitch.on ? 1 : 0;
//        config.options.bypass_filtering = _bypassFilteringSwitch.on ? 1 : 0;
//        config.options.use_threads = _useThreadsSwitch.on ? 1 : 0;
//        config.output.colorspace = MODE_RGBA;
//        
//        NSLog(@"Settings: no_fancy_upsampling=%d, bypass_filtering=%d, use_threads=%d", config.options.no_fancy_upsampling, config.options.bypass_filtering, config.options.use_threads);
//        
//        startTime = [NSDate date];
//        
//        // Decode the WebP image data into a RGBA value array
//        WebPDecode([myData bytes], [myData length], &config);
//        
//        NSLog(@"Time to decode WebP data: %0.2fms", [startTime timeIntervalSinceNow] * -1000.0);
//        
//        startTime = [NSDate date];
//        
//        // Construct a UIImage from the decoded RGBA value array
//        provider = CGDataProviderCreateWithData(&config, config.output.u.RGBA.rgba, width*height*4, free_image_data);
//    }
    //else
    {
        startTime = [NSDate date];
        
        // Decode the WebP image data into a RGBA value array
        uint8_t *data = WebPDecodeRGBA([myData bytes], [myData length], &width, &height);
        
        NSLog(@"Time to decode WebP data: %0.2fms", [startTime timeIntervalSinceNow] * -1000.0);
        
        startTime = [NSDate date];
        
        // Construct a UIImage from the decoded RGBA value array
        provider = CGDataProviderCreateWithData(NULL, data, width*height*4, free_image_data);
    }
    
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
    CGImageRef imageRef = CGImageCreate(width, height, 8, 32, 4*width, colorSpaceRef, bitmapInfo, provider, NULL, NO, renderingIntent);
    UIImage *newImage = [UIImage imageWithCGImage:imageRef];
    
    NSLog(@"Time to contruct UIImage from RGBA: %0.2fms", [startTime timeIntervalSinceNow] * -1000.0);
    
    NSData *ImageData = UIImagePNGRepresentation(newImage);
    NSString *ImageDataBase64 = [STADBasicUtil encodeBase64Data:ImageData];
    NSString *result = [NSString stringWithFormat: @"data:image/png;base64,%@", ImageDataBase64];
    
    NSString * htmlString = [NSString stringWithFormat:IMG_CENTER_HTML,result];
    [self.myWebview loadHTMLString:htmlString baseURL:nil];
    
    // Set the image into the image view and make image view and the scroll view to the correct size
//    self.testImageView.frame = CGRectMake(0, 0, width, height);
//    self.testImageView.image = newImage;
    
    //self.imageScrollView.contentSize = CGSizeMake(width, height);
    
    CGImageRelease(imageRef);
    CGColorSpaceRelease(colorSpaceRef);
    CGDataProviderRelease(provider);
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return webpImages.count;
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [[webpImages[row] componentsSeparatedByString:@"/"] lastObject];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self displayImage:webpImages[row]];
}

@end
