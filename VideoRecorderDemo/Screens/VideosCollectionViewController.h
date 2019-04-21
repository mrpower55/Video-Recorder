//
//  VideosCollectionViewController.h
//  VideoRecorderDemo
//
//  Created by Mahmoud Shurrab on 4/21/19.
//  Copyright © 2019 Zayn Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VideosCollectionViewController : UICollectionViewController

@property (strong, nonatomic) IBOutlet UIView *NoResultsView;

- (IBAction)RecordVideoBtnTouchedUp:(UIBarButtonItem *)sender;
- (IBAction)RecordFirstVideoBtnTouchedUp:(UIButton *)sender;
- (IBAction)DeleteBtnTouchedUp:(UIButton *)sender;

@end

NS_ASSUME_NONNULL_END
