//
//  VideosCollectionViewController.m
//  VideoRecorderDemo
//
//  Created by Mahmoud Shurrab on 4/21/19.
//  Copyright © 2019 Zayn Innovations. All rights reserved.
//

#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>

#import "VideosCollectionViewController.h"
#import "VideoCollectionViewCell.h"

#import "GeneralFunctions.h"

#define MySharedGlobal [GeneralFunctions sharedInstance]

@interface VideosCollectionViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) NSURL *videoURL;
@property (strong, nonatomic) AVPlayerViewController *videoController;

@end

@implementation VideosCollectionViewController{
    NSArray *VideosData;
}

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    @try {
        [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
        [self RefreshVideosData];
    } @catch (NSException *exception) {}
}

-(void)RefreshVideosData{
    @try {
        NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        
        VideosData = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:documentsURL includingPropertiesForKeys:nil options:NSDirectoryEnumerationSkipsHiddenFiles error:nil];
        
        [self.collectionView reloadData];
    } @catch (NSException *exception) {}
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    @try {
        if(VideosData.count == 0){
            self.collectionView.backgroundView = _NoResultsView;
            return 0;
        }
        
        self.collectionView.backgroundView = nil;
        return 1;
    } @catch (NSException *exception) {}
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    @try {
        return VideosData.count;
    } @catch (NSException *exception) {}
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    @try {
        VideoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"VideoCollectionViewCell" forIndexPath:indexPath];
        
        [cell.videoThumbnail setImage:[MySharedGlobal getThumbnailOfVideoURL:VideosData[indexPath.row]]];
        [cell.videoDuration setText:[MySharedGlobal getDurationOfVideoURL:VideosData[indexPath.row]]];
        
        return cell;
    } @catch (NSException *exception) {}
}

#pragma mark <UICollectionViewDelegate>
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    @try {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        NSInteger CellWidth = result.width - 35;
        CellWidth = CellWidth / 2;
        
        return CGSizeMake(CellWidth, CellWidth);
    } @catch (NSException *exception) {}
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    @try {
        _videoController = [[AVPlayerViewController alloc] init];
        _videoController.player = [AVPlayer playerWithURL:VideosData[indexPath.row]];
        
        [self presentViewController:_videoController animated:YES completion:^{
            [self->_videoController.player play];
        }];
    } @catch (NSException *exception) {}
}

- (IBAction)RecordVideoBtnTouchedUp:(UIBarButtonItem *)sender {
    [self StartRecording];
}

- (IBAction)RecordFirstVideoBtnTouchedUp:(UIButton *)sender {
    [self StartRecording];
}

-(void)StartRecording{
    @try {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.videoQuality = UIImagePickerControllerQualityTypeMedium;
            picker.videoMaximumDuration = 30.0f;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
            
            [self presentViewController:picker animated:YES completion:NULL];
        }
    } @catch (NSException *exception) {}
}

- (IBAction)DeleteBtnTouchedUp:(UIButton *)sender {
    @try {
        CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.collectionView];
        NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:buttonPosition];
        
        NSString *DeleteMessage = @"Are You Want To Delete This Video?";
        UIAlertController *AlertController = [UIAlertController alertControllerWithTitle:nil message:DeleteMessage preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *OkAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action){
            [[NSFileManager defaultManager] removeItemAtPath:self->VideosData[indexPath.row] error:nil];
            [self RefreshVideosData];
        }];
        
        UIAlertAction *CancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
        
        [AlertController addAction:OkAction];
        [AlertController addAction:CancelAction];
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            AlertController.modalPresentationStyle = UIModalPresentationPopover;
            AlertController.popoverPresentationController.sourceView = self.view;
            [self presentViewController:AlertController animated:YES completion:nil];
            
            UIPopoverPresentationController *popController = [AlertController popoverPresentationController];
            popController.permittedArrowDirections = UIPopoverArrowDirectionUp;
            popController.barButtonItem = nil;
        }else{
            [self presentViewController:AlertController animated:YES completion:nil];
        }
    } @catch (NSException *exception) {}
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    @try {
        [self dismissViewControllerAnimated:NO completion:nil];
        NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
        
        if ([type isEqualToString:(NSString *)kUTTypeVideo] || [type isEqualToString:(NSString *)kUTTypeMovie]){
            _videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
            NSData *videoData = [NSData dataWithContentsOfURL:_videoURL];
            
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"dd-MM-yyyyHH:mm:SS"];
            NSDate *now = [[NSDate alloc] init];
            NSString *theDate = [dateFormat stringFromDate:now];
            NSString *videoName = [[NSString alloc] initWithString:[NSString stringWithFormat:@"%@.mov",[MySharedGlobal md5:theDate]]];
            
            NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
            documentsURL = [documentsURL URLByAppendingPathComponent:videoName];
            
            [videoData writeToURL:documentsURL atomically:YES];
            
            [self RefreshVideosData];
        }
    } @catch (NSException *exception) {}
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    @try {
        [picker dismissViewControllerAnimated:YES completion:NULL];
    } @catch (NSException *exception) {}
}

@end
