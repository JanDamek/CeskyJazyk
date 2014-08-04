//
//  pmqResultCell.h
//  Matematika
//
//  Created by Jan Damek on 04.06.14.
//  Copyright (c) 2014 PMQ-Software. All rights reserved.
//

#import "pmqLessonTableViewCell.h"

@interface pmqResultCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lessonName;
@property (weak, nonatomic) IBOutlet UILabel *dateOfTest;
@property (weak, nonatomic) IBOutlet UILabel *testOk;
@property (weak, nonatomic) IBOutlet UILabel *testCount;
@property (weak, nonatomic) IBOutlet UILabel *testTime;
@property (weak, nonatomic) IBOutlet UIButton * btnTest;

@property NSInteger rowNumber;

@end
