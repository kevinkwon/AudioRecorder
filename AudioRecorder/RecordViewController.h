//
//  RecordViewController.h
//  AudioRecorder
//
//  Created by hdk on 2014. 7. 2..
//  Copyright (c) 2014년 Kevin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface RecordViewController : UIViewController <AVAudioRecorderDelegate>
{
    AVAudioRecorder *pAudioRecorder; // AVAudioRecorder 멤버 변수
    AVAudioSession *pAudioSession; // AVAudioSession 멤버 변수
    
}

@end
