//
//  pmqLessonTableViewCell.m
//  Matematika
//
//  Created by Jan Damek on 01.06.14.
//  Copyright (c) 2014 PMQ-Software. All rights reserved.
//

#import "pmqLessonTableViewCell.h"

@interface pmqLessonTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *ratingImage;
@property (weak, nonatomic) IBOutlet UIImageView *bgImage;

@end

@implementation pmqLessonTableViewCell

@synthesize ratingImage = _ratingImage;
@synthesize bgImage = _bgImage;
@synthesize rowNumber = _rowNumber;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - methods

-(NSInteger)rowNumber{
    return _rowNumber;
}

-(void)setRowNumber:(NSInteger)rowNumber{
//    UIView *v = [[UIView alloc] initWithFrame:self.frame];
    if (rowNumber % 2){
        _bgImage.image = [UIImage imageNamed:@"bg_list_320_even.png"];

//        UIImageView *s = [[UIImageView alloc] initWithFrame:v.frame];
//        s.image = [UIImage imageNamed:@"bg_list_odd.9.png"];
//        [v addSubview:s];
        
//        self.selectedBackgroundView = v;
    }else{
        _bgImage.image = [UIImage imageNamed:@"bg_list_320_odd.png"];        

//        UIImageView *s = [[UIImageView alloc] initWithFrame:v.frame];
//        s.image = [UIImage imageNamed:@"bg_list_even.9.png"];
//        [v addSubview:s];
        
//        self.selectedBackgroundView = v;
    }
    _rowNumber = rowNumber;
}

-(void)setLock{
    _ratingImage.image = [UIImage imageNamed:@"status_locked"];
}

-(void)setRating:(int)rate{
    switch (rate) {
        case 1:
            _ratingImage.image = [UIImage imageNamed:@"status_1star"];
            break;
        case 2:
            _ratingImage.image = [UIImage imageNamed:@"status_2star"];
            break;
        case 3:
            _ratingImage.image = [UIImage imageNamed:@"status_3star"];
            break;
        case 4:
            _ratingImage.image = [UIImage imageNamed:@"status_4star"];
            break;
        case 5:
            _ratingImage.image = [UIImage imageNamed:@"status_5star"];
            break;
            
        default:
            _ratingImage.image = [UIImage imageNamed:@"status_0star"];
            break;
    }
}


@end
