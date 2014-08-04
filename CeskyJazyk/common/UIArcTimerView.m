//
//  UIArcTimerView.m
//  Matematika
//
//  Created by Jan Damek on 28.05.14.
//  Copyright (c) 2014 PMQ-Software. All rights reserved.
//

#import "UIArcTimerView.h"

@interface UIArcTimerView () {
    
    UILabel *_text;
    
    NSTimer *_timer;
    
    CGFloat startAngle;
    CGFloat endAngle;
}

@end

@implementation UIArcTimerView

@synthesize percent = _percent;
@synthesize timeToCount = _timeToCount;
@synthesize timeLeft = _timeLeft;
@synthesize countDown = _countDown;

@synthesize roundColor = _roundColor;
@synthesize fillColor = _fillColor;
@synthesize circleColor = _circleColor;

@synthesize delegate = _delegate;

#pragma mark - initialization

-(void)maindeclare{
    // Initialization code
   
    _timer = nil;
    
    float size;
    if (self.frame.size.width > self.frame.size.height){
        size = self.frame.size.height;
    }else{
        size = self.frame.size.width;
    }
    float fontSize = size / 3;
    float fontWith = fontSize * 1.6;
    CGRect textRect = CGRectMake((self.frame.size.width / 2.0) - fontWith/2.0, (self.frame.size.height / 2.0) - fontSize/2.0, fontWith, fontSize);
    _text = [[UILabel alloc] initWithFrame:textRect];
    [self addSubview:_text];
    
    _text.font = [UIFont fontWithName: @"Helvetica-Bold" size: fontSize * 0.95];
    [_text setTextAlignment:NSTextAlignmentCenter];
    
    // Determine our start and stop angles for the arc (in radians)
    startAngle = M_PI * 1.5;
    endAngle = startAngle + (M_PI * 2);
    
    _roundColor = [UIColor grayColor];
    _fillColor = [UIColor clearColor];
    _circleColor = [UIColor whiteColor];
    _textColor = [UIColor whiteColor];
    [_text setTextColor:_textColor];
    
    
    _timeLeft = 0;
    _timeToCount = 10;
    _countDown = YES;
    
    _timeAnimation = 0.3;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self maindeclare];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self maindeclare];
    }
    return self;
}

-(id)init{
    self = [super init];
    if (self) {
        [self maindeclare];
    }
    return self;
}

#pragma mark - propertis

-(void)setTextColor:(UIColor *)textColor{
    _textColor = textColor;
    _text.textColor = _textColor;
    [self setNeedsDisplay];
}

-(float)percent{
    return _percent;
}

-(void)setPercent:(float)percent{
    _percent = percent;
    if (_percent>=100){
        _percent = 100;
        [self stopTimer];
    }
    [self setNeedsDisplay];
}

-(int)timeToCount{
    return _timeToCount;
}

-(void)setTimeToCount:(int)timeToCount{
    _timeToCount = timeToCount;
    _timeLeft = _timeToCount;
    self.percent = 0;
}

#pragma mark - draw

-(void)setAnimationScale:(CALayer*)layer{
    CAKeyframeAnimation *scaleAnimation =
    [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    
    // Set the animation's delegate to self so that we can add callbacks if we want
    scaleAnimation.delegate = self;
    
    // Create the transform; we'll scale x and y by 1.5, leaving z alone
    // since this is a 2D animation.
    CATransform3D transform = CATransform3DMakeScale(1.5, 1.5, 1); // Scale in x and y
    
    // Add the keyframes.  Note we have to start and end with CATransformIdentity,
    // so that the label starts from and returns to its non-transformed state.
    [scaleAnimation setValues:[NSArray arrayWithObjects:
                               [NSValue valueWithCATransform3D:CATransform3DIdentity],
                               [NSValue valueWithCATransform3D:transform],
                               [NSValue valueWithCATransform3D:CATransform3DIdentity],
                               nil]];
    
    // set the duration of the animation
    [scaleAnimation setDuration: _timeAnimation];
    
    // animate your layer = rock and roll!
    [layer addAnimation:scaleAnimation forKey:@"scaleText"];
}

- (void)drawRect:(CGRect)rect
{
    float size;
    if (rect.size.width > rect.size.height){
        size = rect.size.height;
    }else{
        size = rect.size.width;
    }
    float okraj = size * 0.05;
    
    if (_countDown){
        NSString *old = _text.text;
        _timeLeft = _timeToCount * ((99-_percent)/100)+1;
        _text.text = [NSString stringWithFormat:@"%d", _timeLeft];
        
        if (![old isEqualToString:_text.text]){
            [self setAnimationScale:[_text layer]];
        }
    } else
        _text.text = [NSString stringWithFormat:@"%d", (int)self.percent];
    
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    // Create our arc, with the correct angles
    [bezierPath addArcWithCenter:CGPointMake(rect.size.width / 2, rect.size.height / 2)
                          radius:size / 4 - (okraj/2)
                      startAngle:startAngle
                        endAngle:(endAngle - startAngle) * (_percent / 100.0) + startAngle
                       clockwise:YES];
    // Set the display for the path, and stroke it
    bezierPath.lineWidth = size / 2 - okraj;
    [_fillColor setStroke];
    [bezierPath stroke];
    
    UIBezierPath* bezierPathSmall = [UIBezierPath bezierPath];
    // Create our arc, with the correct angles
    [bezierPathSmall addArcWithCenter:CGPointMake(rect.size.width / 2, rect.size.height / 2)
                          radius:size/2 - okraj
                      startAngle:startAngle
                        endAngle:(endAngle - startAngle) * (_percent / 100.0) + startAngle
                       clockwise:YES];
    // Set the display for the path, and stroke it
    bezierPathSmall.lineWidth = okraj;
    [_roundColor setStroke];
    [bezierPathSmall stroke];

    UIBezierPath* bezierPath1 = [UIBezierPath bezierPath];
    // Create our arc, with the correct angles
    [bezierPath1 addArcWithCenter:CGPointMake(rect.size.width / 2, rect.size.height / 2)
                               radius:size/2 - (okraj/2)
                           startAngle:startAngle
                             endAngle:endAngle
                            clockwise:YES];
    // Set the display for the path, and stroke it
    bezierPath1.lineWidth = 1;
    [_circleColor setStroke];
    [bezierPath1 stroke];

    UIBezierPath* bezierPath2 = [UIBezierPath bezierPath];
    // Create our arc, with the correct angles
    [bezierPath2 addArcWithCenter:CGPointMake(rect.size.width / 2, rect.size.height / 2)
                           radius:size/2 - (okraj*1.5)
                       startAngle:startAngle
                         endAngle:endAngle
                        clockwise:YES];
    // Set the display for the path, and stroke it
    bezierPath2.lineWidth = 1;
    [_circleColor setStroke];
    [bezierPath2 stroke];
    
    float fontSize = size / 3;
    float fontWith = fontSize * 1.6;
    CGRect textRect = CGRectMake((self.frame.size.width / 2.0) - fontWith/2.0, (self.frame.size.height / 2.0) - fontSize/2.0, fontWith, fontSize);
    _text.frame = textRect;
}

#pragma mark - metods

-(void)onTimer:(NSTimer*)timer{
    self.percent = _percent + 0.1;
}

-(void)invalidateTimer{
    [_timer invalidate];
}

-(void)stopTimer{
    if (_timer){
        [_timer invalidate];
        _timer = nil;
        if ([_delegate respondsToSelector:@selector(terminatedTimer:)]){
            [_delegate terminatedTimer:self];
        }
    }
}

-(void)startTimer{
    [_timer invalidate];
    
   
    float timeBeat = (float)_timeToCount / 1000;
    _timer = [NSTimer scheduledTimerWithTimeInterval:timeBeat target:self selector:@selector(onTimer:) userInfo:nil repeats:YES];
}

-(void)startTimer:(int)timeToCount{
    self.timeToCount = timeToCount;
    [self startTimer];
}

@end
