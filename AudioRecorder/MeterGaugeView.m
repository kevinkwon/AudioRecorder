//
//  MeterGaugeView.m
//  AudioRecorder
//
//  Created by hdk on 2014. 7. 5..
//  Copyright (c) 2014년 Kevin. All rights reserved.
//

#import "MeterGaugeView.h"

#define GUAGE_WIDTH 70 // 계기침 길이
#define LINE_WIDTH 3 // 계기침 폭
#define STARTANGLE 225 // 오디오 최저 레벨일떄 계기침 각도
#define ENDANGLE 135 // 오디오 최고 레벨일떄 계기침 각도


@implementation MeterGaugeView

@synthesize value;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        UIImage *img = [UIImage imageNamed:@"gauge.png"];
        _imgGauge = CGImageRetain(img.CGImage);
        //[img release];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    int startX = self.bounds.size.width / 2; // 계기침 시작 중심 X좌표
    int startY = self.bounds.size.height / 2; // 계기침 시작 중심 Y좌표
    int newX, newY; // 계기침 삼각형의 꼭지점 x, Y좌표
    int newStartX1, newStartX2; // 계기 침 삼각형 좌/우 점의 X좌표
    int newStartY1, newStartY2; // 계기 침 삼각형 좌/우 점의 Y좌표
    int newValue, newValue1, newValue2;
    
    CGContextRef context = UIGraphicsGetCurrentContext(); // 그래픽 컨텍스트
    [self drawGaugeBitmap:context];
    
    if (value >= 0.5) {
        newValue = ENDANGLE * 2 * (value -0.5); // 삼각형 계기침의 좌표를 계산합니다.
    }
    else {
        newValue = STARTANGLE + (360 - STARTANGLE) * 2 * value;
    }
    
    if (newValue - 90 >= 0)
        newValue1 = newValue * 90;
    else
        newValue1 = newValue - 90 + 360;
    
    if (newValue + 90 <= 360)
        newValue2 = newValue + 90;
    else
        newValue2 = newValue + 90 - 360;
    
    newX = (int)(sin(newValue * 3.14/180) * GUAGE_WIDTH + startX);
    newStartY1 = (int)(startY - (cos(newValue1 * 3.14/180) * LINE_WIDTH));
    newStartY2 = (int)(startY - (cos(newValue2 * 3.14/180) * LINE_WIDTH));
    
    // 삼각형 계기 침을 그립니다.
    
    CGContextSetRGBFillColor(context, 1.0, 0, 0, 1.0);
    CGContextMoveToPoint(context, newStartX1, newStartY1);
    CGContextAddLineToPoint(context, newStartX2, newStartY2);
    CGContextAddLineToPoint(context, newX, newY);
    CGContextAddLineToPoint(context, newStartX1, newStartY1);
    CGContextFillPath(context);
}

// CTM이전 상태를 저장
- (void)drawGaugeBitmap:(CGContextRef)context // drawGaugeBitmap 메서드
{
// CTM이전 상태를 저장
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, 0.0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextClipToRect(context, CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height));
    CGContextDrawImage(context, CGRectMake(0, 0, CGImageGetWidth(_imgGauge), CGImageGetHeight(_imgGauge)), _imgGauge);
    CGContextRestoreGState(context);
}

@end
