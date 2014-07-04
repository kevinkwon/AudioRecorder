//
//  UIMemoListCell.h
//  AudioRecorder
//
//  Created by hdk on 2014. 7. 5..
//  Copyright (c) 2014년 Kevin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIMemoListCell : UITableViewCell {
    IBOutlet UILabel *dateLabel;
    IBOutlet UILabel *timeLabel;
    IBOutlet UILabel *recordingTimeLabel;
}

@property (nonatomic, strong) IBOutlet UILabel *dateLabel;
@property (nonatomic, strong) IBOutlet UILabel *timeLabel;
@property (nonatomic, strong) IBOutlet UILabel *recordingTimeLabel;

@end
