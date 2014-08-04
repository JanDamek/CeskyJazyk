//
//  pmqExpleinCell.m
//  Matematika
//
//  Created by Jan Damek on 25.05.14.
//  Copyright (c) 2014 PMQ-Software. All rights reserved.
//

#import "pmqExpleinCell.h"

@interface pmqExpleinCell()

@end

@implementation pmqExpleinCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)highlite{
    if (![self.lab.text isEqualToString:@""]) {
        
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
        [scaleAnimation setDuration: .5];
        
        // animate your layer = rock and roll!
        [[self layer] addAnimation:scaleAnimation forKey:@"scaleText"];
        
    }
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
