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

    [self setAudioSession]; // 오디오 동작 설명
    [_recordTimeDisplay setFont:[UIFont fontWithName:@"DBLCDTempBlack" size:40.0]]; // 폰트 설정
    _dataBase = [[RecordDataBase alloc] init]; // 디비 초기화
    
    // 레코드 시간 화면부분을 초기화 한다. 이부분은 IB ATTRIBUTE에서도 설정이 가능하다.
    _recordTimeDisplay.text = @"00:00:00"; // 레코드 시간 초기화
    _recordTimeDisplay.textAlignment = NSTextAlignmentCenter; // 가운데 정렬
    _recordTimeDisplay.font = [UIFont systemFontOfSize:64]; // 레코드 타임 폰트 설정
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 추가된 함수
- (BOOL)setAudioSession
{
    self.audioSession = [AVAudioSession sharedInstance];
    
    // 오디오 카테고리를 설정합니다.
    if (![self.audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil]) {
        return NO;
    }
    // 오디오 세션이 활성화 됩니다.
    if (![self.audioSession setActive:YES error:nil]) {
        return NO;
    }
    
//    return self.audioSession.inputIsAvailable; deprecate 되었기 때문에 아래 함수를 사용한다.
    return self.audioSession.inputAvailable;
}

- (IBAction)audioRecordingClick:(id)sender
{
    // audioRecorder 객체가 있는지 확인
    if (self.audioRecorder != nil)
    {
        NSLog(@"녹음을 종료합니다.");
        if (self.audioRecorder.recording) { // 레코딩 중일 경우
            [self.audioRecorder stop];      // 녹음을 중지합니다.
            _gaugeView.value = 0;
            [_gaugeView setNeedsDisplay]; // 오디오 레벨을 표시하는 계시판을 다시 그립니다.
            return;
        }
        // [self.adioRecorder release];
        [[NSFileManager defaultManager] removeItemAtPath:[self.audioRecorder.url path] error:nil];
        NSLog(@"녹음을 파일을 삭제합니다.");
    }
    if ([self audioRecordingStart]) // 녹음을 시작합니다.
    {
        [self toolbarRecordButtonToogle:1];
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.03f target:self selector:@selector(timerFired) userInfo:nil repeats:YES]; // 타이머를 설정합니다.
    }
}

// 녹음을 시작합니다.
- (BOOL)audioRecordingStart
{
    NSError *error = nil;
    NSLog(@"녹음을 시작합니다.");
    // 녹음을 위한 설정
    NSMutableDictionary *AudioSetting = [NSMutableDictionary dictionary];
    [AudioSetting setValue:[NSNumber numberWithInt:kAudioFormatLinearPCM] forKeyPath:AVFormatIDKey];
    [AudioSetting setValue:[NSNumber numberWithFloat:44100.0] forKeyPath:AVSampleRateKey];
    [AudioSetting setValue:[NSNumber numberWithInt:2] forKeyPath:AVNumberOfChannelsKey];
    [AudioSetting setValue:[NSNumber numberWithInt:16] forKeyPath:AVLinearPCMBitDepthKey];
    [AudioSetting setValue:[NSNumber numberWithBool:NO] forKeyPath:AVLinearPCMIsBigEndianKey];
    [AudioSetting setValue:[NSNumber numberWithBool:NO] forKeyPath:AVLinearPCMIsFloatKey];
    //  녹음된 오디오가 저장된 파일의 NSURL
    NSURL *url = [self getAudioFilePath];
    NSLog(@"녹음이 저장된 오디오파일의 경로는 %@", url.absoluteString);
    
    // AVAudioRecorder 객체 생성
    NSLog(@"오디오 레코드 객체를 초기화");
    self.audioRecorder = [[AVAudioRecorder alloc]initWithURL:url settings:AudioSetting error:&error];
    
    if (!self.audioRecorder) {
        NSLog(@"오디오 레코드 생성에 실패했습니다.");
        return NO;
    }
    
    self.audioRecorder.delegate = self;
    self.audioRecorder.meteringEnabled = YES; // 모니터링 여부를 설정
    
    if (![self.audioRecorder prepareToRecord]) // 녹음 준비 여부 확인
    {

        NSLog(@"녹음시작 준비 실패 종료 : %@ %d %@", error.domain, error.code, error.userInfo);
        return NO;
    }
    
    if (![self.audioRecorder record]) // 녹음 시작
    {
        NSLog(@"녹음시작 실패 종료");
        return NO;
    }
    
    return YES;
}

- (NSURL *)getAudioFilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
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
    [self.audioRecorder updateMeters];
    
    double peak = pow(10, (0.05 * [self.audioRecorder peakPowerForChannel:0]));
    _lowPassResults = 0.05 * peak + (1.0 - 0.05) * _lowPassResults;
    // 녹음된 사간을 화면에 갱신합니다.
    _recordTimeDisplay.text = [NSString stringWithFormat:@"%@", [self recordTime:self.audioRecorder.currentTime]];
    _recodingTime = self.audioRecorder.currentTime;
    _gaugeView.value = _lowPassResults;
    
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
    NSLog(@"오디로 레코딩이 중지됨");
    // 데이터 베이스 저장
    _recordSeq = [[recorder.url.path substringFromIndex:[recorder.url.path length] - 18] substringToIndex:14];
    _recordFileName = recorder.url.path;
    
    [_dataBase insertRecordData:_recordSeq RecordingTM:_recodingTime RecordFileNM:_recordFileName];
    [self toolbarRecordButtonToogle:0];
    
    [_timer invalidate];
    _timer = nil;
}

// 녹음/멈춤 버튼 이미지 토글 처리
- (void)toolbarRecordButtonToogle:(int)index
{
    if (index == 0) {
        [_recordButton setImage:[UIImage imageNamed:@"record_on"] forState:UIControlStateNormal];
    }
    else {
        [_recordButton setImage:[UIImage imageNamed:@"record_off.png"] forState:UIControlStateNormal];
    }
}

@end
