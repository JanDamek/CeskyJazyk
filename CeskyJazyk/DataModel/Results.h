//
//  Results.h
//  ceskyjazyk
//
//  Created by Jan Damek on 04.09.14.
//  Copyright (c) 2014 PMQ-Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Questions, Tests;

@interface Results : NSManagedObject

@property (nonatomic, retain) NSNumber * answer1;
@property (nonatomic, retain) NSNumber * answer2;
@property (nonatomic, retain) NSNumber * answer3;
@property (nonatomic, retain) NSNumber * answer4;
@property (nonatomic, retain) NSNumber * answer5;
@property (nonatomic, retain) NSNumber * answer6;
@property (nonatomic, retain) NSNumber * answer7;
@property (nonatomic, retain) NSNumber * answer8;
@property (nonatomic, retain) NSNumber * answer9;
@property (nonatomic, retain) NSNumber * answer10;
@property (nonatomic, retain) NSNumber * answer11;
@property (nonatomic, retain) NSNumber * answer12;
@property (nonatomic, retain) NSNumber * bad_answers;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * rate;
@property (nonatomic, retain) NSNumber * total_time;
@property (nonatomic, retain) Questions *relationship_questions1;
@property (nonatomic, retain) Questions *relationship_questions2;
@property (nonatomic, retain) Questions *relationship_questions3;
@property (nonatomic, retain) Questions *relationship_questions4;
@property (nonatomic, retain) Questions *relationship_questions5;
@property (nonatomic, retain) Questions *relationship_questions6;
@property (nonatomic, retain) Questions *relationship_questions7;
@property (nonatomic, retain) Questions *relationship_questions8;
@property (nonatomic, retain) Questions *relationship_questions9;
@property (nonatomic, retain) Questions *relationship_questions10;
@property (nonatomic, retain) Questions *relationship_questions11;
@property (nonatomic, retain) Questions *relationship_questions12;
@property (nonatomic, retain) Tests *relationship_test;

@end
