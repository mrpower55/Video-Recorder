//
//  GeneralFunctions.h
//  VideoRecorderDemo
//
//  Created by Mahmoud Shurrab on 4/21/19.
//  Copyright © 2019 Zayn Innovations Company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <AVKit/AVKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GeneralFunctions : NSObject

+(instancetype)sharedInstance;

- (NSString *) md5:(NSString *) input;

- (UIImage *)getThumbnailOfVideoURL:(NSURL *)VideoURL;
- (NSString *)getDurationOfVideoURL:(NSURL *)VideoURL;

@end

NS_ASSUME_NONNULL_END
