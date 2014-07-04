//
//  MeterGaugeView.h
//  AudioRecorder
//
//  Created by hdk on 2014. 7. 5..
//  Copyright (c) 2014년 Kevin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeterGaugeView : UIView
{
    CGImageRef imgGauge;
    double value; // 오디오 레벨값을 저장하는 변수
}

- (void)drawGuageBitmap:(CGContextRef)context;
@property double value;

@end
