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

@interface RecordViewController : UIViewController <AVAudioRecorderDelegate>
{
    AVAudioRecorder *pAudioRecorder; // AVAudioRecorder 멤버 변수
    AVAudioSession *pAudioSession; // AVAudioSession 멤버 변수
    
    IBOutlet UILabel *recordTimeDisplay;
    IBOutlet MeterGaugeView *pGaugeView;
    IBOutlet UIBarButtonItem *ListButton;
    
    NSTimer *timer;
    double plowPassResults; // 녹음레벨
    RecordDataBase *pDateBase; //데이터베이스 제어 클래스 변수
    
    // 데이터 베이스에 저장하기 위한 정보
    NSString *pRecordSeq;
    NSString *pRecordFileName;
    int pRecodingTime;
}

- (IBAction)audioRecordingClick:(id)sender; // 녹음 시작/멈춤 클릭시 발생하는 이벤트 함수
- (NSString *)getFileName; // 파일명을 구함
- (BOOL)SetAudioSession; // 오디오 세션 설정 함수
- (BOOL)AudioRecordingStart; // 녹음시작
- (void)ToolbarRecordButtonToogle:(int)index;
- (void)timerFired;

@property (nonatomic, strong) AVAudioRecorder *pAudioRecorder;
@property (nonatomic, strong) AVAudioSession *pAudioSession;

@end
