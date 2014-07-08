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
#import "AudioRecorderInfoViewController.h"

@interface RootViewController : UIViewController
{
    // property로 했기때문에 생략해도 무방함
//    RecordViewController *_recordViewController;
//    AudioRecorderInfoViewController *_audioRecorderInfoViewController;
//    RecordListViewController *_recordListViewController;
//    UIButton *_infoButton;
}

@property (nonatomic, strong) RecordViewController *recordViewController; // 녹음기 화면
@property (nonatomic, strong) AudioRecorderInfoViewController *audioRecorderInfoViewController; // 녹음기 정보 화면 , AudioRecorderInfo 클래스 이름을 변경함
@property (nonatomic, strong) RecordListViewController *recordListViewController; // 녹음된 파일 목록 화면
@property (nonatomic, strong) IBOutlet UIButton *infoButton; // 정보를 보는 버튼

/** - (IBAction)recordInfoClick:(id)sender; 이름 변경함 infoButton을 누르면 아래 메서드가 실행됨 */
- (IBAction)infoButtonPressed:(id)sender;
/** - (IBAction)audioListClick:(id)sender; 이름 변경함 하단 툴발의 "show list" 버튼을 누르면 이 메서드가 실행됨 */
 - (IBAction)audioListButtonPressed:(id)sender;
@end
