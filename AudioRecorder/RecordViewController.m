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
    [_recordTimeDisplay setFont:[UIFont fontWithName:@"DBLCDTempBlack" size:40.0]]; // 폰트 설정
    _pDataBase = [[RecordDataBase alloc] init]; // 디비 초기화
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
            _gaugeView.value = 0;
            [[NSFileManager defaultManager] removeItemAtPath:[self.pAudioRecorder.url path] error:nil];
            [_gaugeView setNeedsDisplay]; // 오디오 레벨을 표시하는 계시판을 다시 그립니다.
            return;
        }
        // [self.pAudioRecorder release];
    }
    if ([self AudioRecordingStart]) // 녹음을 시작합니다.
    {
        [self toolbarRecordButtonToogle:1];
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.03f target:self selector:@selector(timerFired) userInfo:nil repeats:YES]; // 타이머를 설정합니다.
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

- (NSURL *)getAudioFilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    
    // 파일명을 구하고 파일결로를 합친후 NSURL객체로 변환합니다.
    NSURL *audioURL = [NSURL fileURLWithPath:[documentDirectory stringByAppendingPathComponent:[self getFileName]]];
    return audioURL;
}

- (NSString *)getFileName
{
    NSDateFormatter *fileNameFormat = [[NSDateFormatter alloc]init];
    [fileNameFormat setDateFormat:@"yyyyMMddHHmmss"];
    
    // 파일명을 구합니다.
    NSString *fileName = [[fileNameFormat stringFromDate:[NSDate date]] stringByAppendingString:@".aif"];
    // [fileNameFormat release];
    return fileName;
}

- (void)timerFired
{
    [self.pAudioRecorder updateMeters];
    
    double peak = pow(10, (0.05 * [self.pAudioRecorder peakPowerForChannel:0]));
    _plowPassResults = 0.05 * peak + (1.0 - 0.05) * _plowPassResults;
    // 녹음된 사간을 화면에 갱신합니다.
    _recordTimeDisplay.text = [NSString stringWithFormat:@"%@", [self recordTime:self.pAudioRecorder.currentTime]];
    _pRecodingTime = self.pAudioRecorder.currentTime;
    _gaugeView.value = _plowPassResults;
    
    [_gaugeView setNeedsDisplay]; // 계기판을 갱신합니다.
}

// 녹음된 시/분/초를 구합니다.
- (NSString *)recordTime:(int)num
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
    _pRecordSeq = [[recorder.url.path substringFromIndex:[recorder.url.path length] - 18] substringToIndex:14];
    _pRecordFileName = recorder.url.path;
    
    [_pDataBase insertRecordData:_pRecordSeq RecordingTM:_pRecodingTime RecordFileNM:_pRecordFileName];
    [self toolbarRecordButtonToogle:0];
    
    [_timer invalidate];
    _timer = nil;
}

// 녹음/멈춤 버튼 이미지 토글 처리
- (void)toolbarRecordButtonToogle:(int)index
{
    if (index == 0) {
        [_pRecordButton setImage:[UIImage imageNamed:@"record_on"] forState:UIControlStateNormal];
    }
    else {
        [_pRecordButton setImage:[UIImage imageNamed:@"record_off.png"] forState:UIControlStateNormal];
    }
}

@end
