//
//  pmqQuestionMarkCell.m
//  Matematika
//
//  Created by Jan Damek on 27.05.14.
//  Copyright (c) 2014 PMQ-Software. All rights reserved.
//

#import "pmqQuestionMarkCell.h"

@interface pmqQuestionMarkCell ()

@property (weak, nonatomic) IBOutlet UIImageView *img;

@end

@implementation pmqQuestionMarkCell

@synthesize correct = _correct;
@synthesize img = _img;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(BOOL)correct{
    return _correct;
}

-(void)setCorrect:(BOOL)correct{
    _correct = correct;
    if (correct){
        _img.image = [UIImage imageNamed:@"star_ok"];
    }else{
        _img.image = [UIImage imageNamed:@"star_err"];
    }
}

-(void)noAnswer{
    _img.image = [UIImage imageNamed:@"star_bg"];
}


@end
