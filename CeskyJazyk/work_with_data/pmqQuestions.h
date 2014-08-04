//
//  pmgQuestions.h
//  Matematika
//
//  Created by Jan Damek on 22.05.14.
//  Copyright (c) 2014 PMQ-Software. All rights reserved.
//

#import "Questions.h"

@interface pmqQuestions : NSObject

@property (retain, nonatomic) Questions *q;

@property (readonly, nonatomic, getter = getCorrect) NSString* corect_answer;
@property (readonly, nonatomic) NSArray* answers;
@property (readonly, nonatomic) NSString *fistPartQuestion;
@property (readonly, nonatomic) NSString *secondPartQuestion;

@property (readonly, nonatomic) NSString *resultQuestion;

@end
