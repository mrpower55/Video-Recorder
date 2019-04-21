//
//  GeneralFunctions.m
//  VideoRecorderDemo
//
//  Created by Mahmoud Shurrab on 4/21/19.
//  Copyright © 2019 Zayn Innovations. All rights reserved.
//

#import "GeneralFunctions.h"
#import <AVFoundation/AVFoundation.h>

@implementation GeneralFunctions

+(instancetype)sharedInstance{
    static id sharedInstance = nil;
    @synchronized(self){
        if (sharedInstance == nil)
            sharedInstance = [self new];
    }
    
    return sharedInstance;
}

- (NSString *) md5:(NSString *) input{
    @try {
        const char *cStr = [input UTF8String];
        unsigned char digest[CC_MD5_DIGEST_LENGTH];
        CC_MD5( cStr, strlen(cStr), digest );
        
        NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
        
        for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
            [output appendFormat:@"%02x", digest[i]];
        
        return  output;
    } @catch (NSException *exception) {}
}

-(UIImage *)getThumbnailOfVideoURL:(NSURL *)VideoURL{
    @try {
        AVURLAsset *assetURL = [[AVURLAsset alloc] initWithURL:VideoURL options:nil];
        AVAssetImageGenerator *assetGenerator = [[AVAssetImageGenerator alloc] initWithAsset:assetURL];
        assetGenerator.appliesPreferredTrackTransform = YES;
        NSError *err = NULL;
        CMTime time = CMTimeMake(1, 2);
        CGImageRef imgRef = [assetGenerator copyCGImageAtTime:time actualTime:NULL error:&err];
        return [[UIImage alloc] initWithCGImage:imgRef];
    } @catch (NSException *exception) {}
}

-(NSString *)getDurationOfVideoURL:(NSURL *)VideoURL{
    @try {
        AVURLAsset *avUrl = [AVURLAsset assetWithURL:VideoURL];
        CMTime time = [avUrl duration];
        NSInteger seconds = ceil(time.value/time.timescale);
        return [NSString stringWithFormat:@"00:%ld",seconds];
    } @catch (NSException *exception) {}
}

@end
