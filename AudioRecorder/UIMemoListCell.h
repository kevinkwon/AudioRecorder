//
//  UIMemoListCell.h
//  AudioRecorder
//
//  Created by hdk on 2014. 7. 5..
//  Copyright (c) 2014년 Kevin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIMemoListCell : UITableViewCell {
    UILabel *_dateLabel;
    UILabel *_timeLabel;
    UILabel *_recordingTimeLabel;
}

@property (nonatomic, strong) IBOutlet UILabel *dateLabel;
@property (nonatomic, strong) IBOutlet UILabel *timeLabel;
@property (nonatomic, strong) IBOutlet UILabel *recordingTimeLabel;

@end
