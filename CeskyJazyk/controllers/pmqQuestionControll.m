//
//  pmqQuestionControll.m
//  ceskyjazyk
//
//  Created by Jan Damek on 26.08.14.
//  Copyright (c) 2014 PMQ-Software. All rights reserved.
//

#import "pmqQuestionControll.h"

@interface pmqQuestionControll(){
    float fontSize;
}

@property (strong, nonatomic) UIImage *questionMark;

@end

@implementation pmqQuestionControll

@synthesize maxFontPointSize = _maxFontPointSize;
@synthesize firstPartQuestion = _firstPartQuestion;
@synthesize secondPartQuestion = _secondPartQuestion;
@synthesize correctAnswer = _correctAnswer;
@synthesize questionMark = _questionMark;
@synthesize questionTimer = _questionTimer;
@synthesize showState = _showState;


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    float mid = rect.size.width / 2;
    CGRect first;
    CGRect second;
    CGRect f;
    CGRect correct;
    float first_x=0;
    float mark_x=0;
    float second_x=0;
    float mark_width=0;
    float all=0;
    
    UILabel *l = [[UILabel alloc] init];
    fontSize = _maxFontPointSize;
    
    while (all<=0) {
        [l setFont:[UIFont systemFontOfSize:fontSize]];
        [l setText:_firstPartQuestion];
        [l sizeToFit];
        
        f = l.frame;
        first = f;
        
        [l setText:_secondPartQuestion];
        [l sizeToFit];
        second = l.frame;
        
        [l setText:_correctAnswer];
        [l sizeToFit];
        correct = l.frame;
        
        if (f.size.width==0){
            f = second;
        }
        f.size.height = f.size.height;
        mark_width = f.size.height * 0.6;
        
        first_x = 0;
        mark_x = first.size.width;
        if (_showState==qcOnTime){
            second_x = mark_x + f.size.height;
        }else if (_showState==qcQuestion){
            second_x = mark_x + mark_width;
        }else {
            second_x = mark_x + correct.size.width;
        }
        all = second_x + second.size.width;
        
        all = mid - ( all / 2);
        
        fontSize = fontSize * 0.9;
    }
    
    first_x += all;
    second_x += all;
    mark_x += all;
    
    [_questionTimer setHidden:YES];
    if (_showState==qcOnTime){
        [_questionTimer setHidden:NO];
        
        f.size.width = f.size.height;
        f.origin.x = mark_x;
        
        [_questionTimer setFrame:f];
        [self setTimerHeight:f.size.height];
        
    }else if (_showState==qcQuestion){
        f.size.width = mark_width;
        f.origin.x = mark_x;
        [_questionMark drawInRect:f];
    }
    
    [[UIColor whiteColor] set];
    [_firstPartQuestion drawAtPoint:CGPointMake(first_x, 0) withFont:[UIFont systemFontOfSize:fontSize*1.1]];
    [_secondPartQuestion drawAtPoint:CGPointMake(second_x, 0) withFont:[UIFont systemFontOfSize:fontSize*1.1]];
    if ((_showState==qcAnswer) || (_showState==qcAnswerBad)){
        [_correctAnswer drawAtPoint:CGPointMake(mark_x, 0) withFont:[UIFont systemFontOfSize:fontSize*1.1]];
    }
}


-(void)createViews{
    //TODO: vytvoreni prvku
    _maxFontPointSize = 75;
    
    _questionMark       = [UIImage imageNamed:@"question_mark"];
    
    _questionTimer.roundColor = [UIColor darkGrayColor];
    [self setTimerHeight:100];
}

-(void)setTimerHeight:(float)height{
    CGRect f = _questionTimer.frame;
    f.size.width = height;
    f.size.height = height;
    [_questionTimer setFrame:f];
    
    UIImage *img = [UIImage imageNamed:@"timer_fg.png"];
    CGSize size = CGSizeMake(_questionTimer.frame.size.width,_questionTimer.frame.size.height);
    UIGraphicsBeginImageContext(size);
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage * newimage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    _questionTimer.fillColor = [UIColor colorWithPatternImage:newimage];
}

-(instancetype)init{
    [self createViews];
    return [super init];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    [self createViews];
    return [super initWithCoder:aDecoder];
}

-(instancetype)initWithFrame:(CGRect)frame{
    [self createViews];
    return [super initWithFrame:frame];
}

-(void)setDelegate:(id<UIArcTimerViewDelegate>)delegate{
    _questionTimer.delegate = delegate;
    if (!delegate){
        [_questionTimer invalidateTimer];
    }
}

-(id<UIArcTimerViewDelegate>)delegate{
    return _questionTimer.delegate;
}

-(void)hideAll{
    [_questionTimer setHidden:YES];
}


//-(void)realignView{
//    int midl = self.frame.size.width / 2;
//
//    CGRect q1 = _questionFirstPart.frame;
//    CGRect q2 = _questionSecondPart.frame;
//    CGRect qM = _questionMark.frame;
//    CGRect ti = _questionTimer.frame;
//    CGRect lA = _questionAnswer.frame;
//
//    int size = q1.size.width;
//
//    if (!_questionAnswer.isHidden){
//        size += lA.size.width;
//    } else
//        if (!_questionMark.isHidden){
//            size += qM.size.width;
//        } else
//            if (!_questionTimer.isHidden){
//                size += ti.size.width;
//            }else{
//                //chyba definice, sem to nesmi dojid
//                size +=qM.size.width;
//            };
//
//    size += q2.size.width;
//    q1.origin.x = midl - (size / 2);
//    if (q1.origin.x<10)
//    {
//        [self setMenorFont];
//    }else{
//        size = q1.origin.x + q1.size.width;
//
//        if (!_questionAnswer.isHidden){
//            lA.origin.x = size;
//            size += lA.size.width;
//        } else
//            if (!_questionMark.isHidden){
//                qM.origin.x = size;
//                size += qM.size.width;
//            } else
//                if (!_questionTimer.isHidden){
//                    ti.origin.x = size;
//                    size += ti.size.width;
//                };
//
//        q2.origin.x = size;
//
//        _questionFirstPart.frame = q1;
//        _questionSecondPart.frame = q2;
//        _questionMark.frame = qM;
//        _questionTimer.frame = ti;
//        _questionAnswer.frame = lA;
//    }
//}

-(void)setQuestion:(NSString*)firstPartQuestion secondPartQuestion:(NSString*)secondPartQuestion correctAnswer:(NSString*)correctAnswer onTime:(BOOL)onTime timeToAnwser:(int)timeToAnswer{
    //TODO: vytvoreni otazky
    _showState = qcQuestion;
    
    _firstPartQuestion = firstPartQuestion;
    _secondPartQuestion = secondPartQuestion;
    _correctAnswer = correctAnswer;
    
    if (onTime){
        [_questionTimer startTimer:timeToAnswer];
    }
    
    fontSize = _maxFontPointSize;
    
    [self setNeedsDisplay];
}

-(void)setShowState:(enum qcShowState)showState{
    _showState = showState;
    [self setNeedsDisplay];
}

-(enum qcShowState)showState{
    return _showState;
}

@end
