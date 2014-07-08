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
    CGImageRef _imgGauge;
    double _value; // 오디오 레벨값을 저장하는 변수
}

- (void)drawGaugeBitmap:(CGContextRef)context;
@property (nonatomic, assign) double value;

@end
