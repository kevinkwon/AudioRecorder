//
//  RootViewController.h
//  AudioRecorder
//
//  Created by hdk on 2014. 7. 2..
//  Copyright (c) 2014년 Kevin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecordViewController.h"
#import "RecordListViewController.h"
#import "AudioRecorderInfo.h"

@interface RootViewController : UIViewController
{
    // property로 했기때문에 생략해도 무방함
//    RecordViewController *_recordViewController;
//    AudioRecorderInfo *_audioRecorderInfo;
//    RecordListViewController *pRecordListViewController;
//    IBOutlet UIButton *infoButton;
}

- (IBAction)recordInfoClick:(id)sender;
- (IBAction)audioListClick:(id)sender;

@property (nonatomic, strong) RecordViewController *recordViewController;
@property (nonatomic, strong) AudioRecorderInfo *audioRecorderInfo;
@property (nonatomic, strong) RecordListViewController *recordListViewController;
@property (nonatomic, strong) IBOutlet UIButton *infoButton;

@end
