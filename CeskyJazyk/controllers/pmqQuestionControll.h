//
//  pmqQuestionControll.h
//  ceskyjazyk
//
//  Created by Jan Damek on 26.08.14.
//  Copyright (c) 2014 PMQ-Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIArcTimerView.h"

enum qcShowState { qcQuestion, qcOnTime, qcAnswer, qcAnswerBad, qcHideAll };

@interface pmqQuestionControll : UIView

@property float maxFontPointSize;

@property (strong, nonatomic, readonly) NSString *firstPartQuestion;
@property (strong, nonatomic, readonly) NSString *secondPartQuestion;
@property (strong, nonatomic, readonly) NSString *correctAnswer;

@property (strong, nonatomic) IBOutlet UIArcTimerView *questionTimer;

@property enum qcShowState showState;

@property id<UIArcTimerViewDelegate> delegate;

-(void)setQuestion:(NSString*)firstPartQuestion secondPartQuestion:(NSString*)secondPartQuestion correctAnswer:(NSString*)correctAnswer onTime:(BOOL)onTime timeToAnwser:(int)timeToAnswer;
-(void)setTimerHeight:(float)height;

@end