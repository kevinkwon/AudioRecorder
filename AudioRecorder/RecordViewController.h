//
//  RecordViewController.h
//  AudioRecorder
//
//  Created by hdk on 2014. 7. 2..
//  Copyright (c) 2014년 Kevin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "MeterGaugeView.h"
#import "RecordDataBase.h"

@interface RecordViewController : UIViewController <AVAudioRecorderDelegate>
{
    AVAudioRecorder *_audioRecorder; // AVAudioRecorder 멤버 변수
    AVAudioSession *_audioSession; // AVAudioSession 멤버 변수
    IBOutlet UIButton *_recordButton; // 녹음 제어 버튼에 대한 변수
    
    // 녹음 시간을 화면에 표시하는 라벨에 대한 참조 변수
    IBOutlet UILabel *_recordTimeDisplay;
    IBOutlet MeterGaugeView *_gaugeView;
    IBOutlet UIBarButtonItem *_listButton;
    
    NSTimer *_timer;
    double _lowPassResults; // 녹음레벨
    RecordDataBase *_dataBase; //데이터베이스 제어 클래스 변수
    
    // 데이터 베이스에 저장하기 위한 정보
    NSString *_recordSeq;
    NSString *_recordFileName;
    int _recodingTime;
}

- (IBAction)audioRecordingClick:(id)sender; // 녹음 시작/멈춤 클릭시 발생하는 이벤트 함수

- (NSString *)getFileName;

- (NSURL *)getAudioFilePath; // 파일명을 구함

- (BOOL)setAudioSession; // 오디오 세션 설정 함수

- (BOOL)audioRecordingStart; // 녹음시작

- (void)toolbarRecordButtonToogle:(int)index;

- (void)timerFired;

@property (nonatomic, strong) AVAudioRecorder *audioRecorder;

@property (nonatomic, strong) AVAudioSession *audioSession;

@end
