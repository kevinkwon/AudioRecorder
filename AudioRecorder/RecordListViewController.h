//
//  RecordListViewController.h
//  AudioRecorder
//
//  Created by hdk on 2014. 7. 2..
//  Copyright (c) 2014년 Kevin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MessageUI/MessageUI.h>
#import "RecordDataBase.h"

@interface RecordListViewController : UIViewController <AVAudioPlayerDelegate, MFMailComposeViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>
{
    RecordDateBase *pDataBase;
    IBOutlet UITableView *pListView;
    IBOutlet UIBarButtonItem *playerButton; // 듣기 버튼
    AVAudioPlayer *pAudioPlayer;
}

- (void)ReloadRecordList;


@end
