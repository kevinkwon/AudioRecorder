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

- (IBAction)audioRecordingClick:(id)sender
{
    if (self.pAudioRecorder != nil)
    {
        if (self.pAudioRecorder.recording) { // 레코딩 중일 경우
            [self.pAudioRecorder stop]; // 녹음을 중지합니다.
            pGaugeView.value = 0;
            [[NSFileManager defaultManager] removeItemAtPath:[self.pAudioRecorder.url path] error:nil];
            [pGaugeView setNeedsDisplay]; // 오디오 레벨을 표시하는 계시판을 다시 그립니다.
            return;
        }
        // [self.pAudioRecorder release];
    }
    if ([self AudioRecordingStart]) // 녹음을 시작합니다.
    {
        [self ToolBarRecordButtonToogle:1];
        timer = [NSTimer scheduledTimerWithTimeInterval:0.03f invocation:self repeats:@selector(timerFired) userInfo:nil repeats:YES]; // 타이머를 설정합니다.
    }
}

// 녹음을 시작합니다.
- (BOOL)AudioRecordingStart
{
    // 녹음을 위한 설정
    NSMutableDictionary *AudioSetting = [NSMutableDictionary dictionary];
    [AudioSetting setValue:[NSNumber numberWithInt:kAudioFormatLinearPCM] forKeyPath:AVFormatIDKey];
    [AudioSetting setValue:[NSNumber numberWithFloat:11025] forKeyPath:AVSampleRateKey];
    [AudioSetting setValue:[NSNumber numberWithInt:1] forKeyPath:AVNumberOfChannelsKey];
    [AudioSetting setValue:[NSNumber numberWithInt:16] forKeyPath:AVLinearPCMBitDepthKey];
    [AudioSetting setValue:[NSNumber numberWithBool:NO] forKeyPath:AVLinearPCMIsBigEndianKey];
    [AudioSetting setValue:[NSNumber numberWithBool:NO] forKeyPath:AVLinearPCMIsFloatKey];
    //  녹음된 오디오가 저장된 파일의 NSURL
    NSURL *url = [self getAudioFilePath];
    
    // AVAudioRecorder 객체 생성
    self.pAudioRecorder = [[AVAudioRecorder alloc]initWithURL:url settings:AudioSetting error:nil];
    
    if (!self.pAudioRecorder)
        return NO;
    
    self.pAudioRecorder.meteringEnabled = YES; // 모니터링 여부를 설정
    self.pAudioRecorder.delegate = self;
    
    if (![self.pAudioRecorder prepareToRecord]) // 녹음 준비 여부 확인
    {
     return NO;
    }
    
    if (![self.pAudioRecorder record]) // 녹음 시작
    {
     return NO;
    }
    
    return YES;
}

- (NSString *)getAudioFilePath
{
    NSDateFormatter *fileNameFormat = [[NSDateFormatter alloc]init];
    [fileNameFormat setDateFormat:@"yyyyMddHHmmss"];
    
    // 파일명을 구합니다.
    NSString *fileName = [[fileNameFormat stringFromDate:[NSDate date]] stringByAppendingString:@".aif"];
    // [fileNameFormat release];
    return fileName;
}

- (void)timeFired
{
    [self.pAudioRecorder updateMeters];
    double peak = pow(10, (0.05 * [self.pAudioRecorder peakPowerForChannel:0]));
    plowPassResults = 0.05 * peak + (1.0 - 0.05) *plowPassResults;
    // 녹음된 사간을 화면에 갱신합니다.
    recordTimeDisplay.text = [NSString stringWithFormat:@"%@", [self RecordTime:self.pAudioRecorder.currentTime]];
    pRecodingTime = self.pAudioRecorder.currentTime;
    pGaugeView.value = plowPassResults;
    [pGuageView setNeedDisplay]; // 계기판을 갱신합니다.
}

// 녹음된 시/분/초를 구합니다.
- (NSString *)RecordTime:(int)num
{
    int secs = num % 60; // 녹음시간 : 초
    int min = (num % 3600) / 60; // 녹음시간 : 분
    int hour = (num / 3600); // 녹음시간 : 시
    
    return [NSString stringWithFormat:@"%02d:%02d:%02d", hour, min, secs];
}

#pragma mark - AVAudioRecorder Delegate Method
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    // 데이터 베이스 저장
    pRecordSeq = [[recorder.url.path substringFromIndex:[recorder.url.path length] - 18] substringToIndex:14];
    pRecordFileName = recorder.url.path;
    
    [pDataBase insertRecordData:pRecordSeq RecordingTM:pRecodingTime RecordFileNM:pRecordFileName];
    [self ToolbarRecordButtonToogle:0];
    
    [timer invalidate];
    timer = nil;
}

// 녹음/멈춤 버튼 이미지 토글 처리
- (void)ToolbarRecordButtonToogle:(int)index
{
    if (index == 0) {
        [pRecordButton setImage:[UIImage imageNamed:@"record_on.png"] forState:UIControlStateNormal];
    }
    else {
        [pRecordButton setImage:[UIImage imageNamed:@"record_off.png"] forState:UIControlStateNormal];
    }
}

@end
