//
//  UIArcTimerView.h
//  Matematika
//
//  Created by Jan Damek on 28.05.14.
//  Copyright (c) 2014 PMQ-Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UIArcTimerView;

@protocol UIArcTimerViewDelegate <NSObject>

-(void)terminatedTimer:(UIArcTimerView*)timerView;

@end

@interface UIArcTimerView : UIView

@property float percent;

@property int timeToCount;
@property int timeLeft;

@property bool countDown;

@property (nonatomic, strong) UIColor *roundColor;
@property (nonatomic, strong) UIColor *fillColor;
@property (nonatomic, strong) UIColor *circleColor;
@property (nonatomic, strong) UIColor *textColor;

@property float timeAnimation;

@property id<UIArcTimerViewDelegate> delegate;

-(void)stopTimer;
-(void)startTimer;
-(void)startTimer:(int)timeToCount;
-(void)invalidateTimer;

@end
