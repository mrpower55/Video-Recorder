//
//  VideoCollectionViewCell.h
//  VideoRecorderDemo
//
//  Created by Mahmoud Shurrab on 4/21/19.
//  Copyright © 2019 Zayn Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VideoCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *videoThumbnail;
@property (weak, nonatomic) IBOutlet UILabel *videoDuration;

@end

NS_ASSUME_NONNULL_END
