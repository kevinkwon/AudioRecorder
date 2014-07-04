//
//  RecordViewController.m
//  AudioRecorder
//
//  Created by hdk on 2014. 7. 2..
//  Copyright (c) 2014년 Kevin. All rights reserved.
//

#import "RecordViewController.h"

@interface RecordViewController ()

@end

@implementation RecordViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self SetAudioSession]; // 오디오 동작 설명
    [recordTimeDisplay setFont:[UIFont fontWithName:@"DBLCDTempBlack" size:40.0]]; // 폰트 설정
    pDateBase = [[RecordDataBase alloc] init]; // 디비 초기화
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 추가된 함수
- (BOOL)SetAudioSession
{
    self.pAudioSession = [AVAudioSession sharedInstance];
    
    // 오디오 카테고리를 설정합니다.
    if (![self.pAudioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil]) {
        return NO;
    }
    // 오디오 세션이 활성화 됩니다.
    if (![self.pAudioSession setActive:YES error:nil]) {
        return NO;
    }
    
    return self.pAudioSession.inputIsAvailable;
}

@end
