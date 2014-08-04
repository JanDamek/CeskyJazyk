//
//  pmqLessonTableViewCell.h
//  Matematika
//
//  Created by Jan Damek on 01.06.14.
//  Copyright (c) 2014 PMQ-Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface pmqLessonTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lessonName;
@property NSInteger rowNumber;

-(void)setLock;
-(void)setRating:(int)rate;

@end
