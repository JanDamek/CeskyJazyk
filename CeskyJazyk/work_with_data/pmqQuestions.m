//
//  pmgQuestions.m
//  Matematika
//
//  Created by Jan Damek on 22.05.14.
//  Copyright (c) 2014 PMQ-Software. All rights reserved.
//

#import "pmqQuestions.h"

@interface pmqQuestions()

@end

@implementation pmqQuestions

@synthesize q = _q;
@synthesize answers = _answers;
@synthesize corect_answer = _corect_answer;
@synthesize fistPartQuestion = _fistPartQuestion;
@synthesize secondPartQuestion = _secondPartQuestion;


#pragma mark - getters for property


-(void)setQ:(Questions *)q{
    _q = q;
    [self doParseContent];
}

-(NSString *)resultQuestion{
    NSString *co;
    if ([_q.last_answer boolValue]){
        co = _corect_answer;
    } else
        co = @"?";
    
    return [NSString stringWithFormat:@"%@%@%@", self.fistPartQuestion, co, self.secondPartQuestion ];
}

#pragma mark - parse question content

-(void) doParseContent{
    NSString *s = [_q.content stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\n "]];
    NSArray * question = [s componentsSeparatedByString:@"[...]"];
    s = [[question objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\n "]];
    NSArray *q = [s componentsSeparatedByString:@"[?]"];
    _fistPartQuestion = [q objectAtIndex:0];
    _secondPartQuestion = [q objectAtIndex:1];
    s = [[question objectAtIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\n "]];
    NSMutableArray *_a = [[s componentsSeparatedByString:@" "] mutableCopy];
    NSUInteger correct_index=-1;
    NSString *ca = @"";
    for (NSString *s in _a) {
        if ([s hasPrefix:@"*"]) {
            _corect_answer = [s substringFromIndex:1];
            ca = s;
            correct_index = [_a indexOfObject:s];
        }
    }
    [_a removeObjectAtIndex:correct_index];
    
    int count_question = 0;
    int test_length = 6;
    NSMutableArray *a = [[NSMutableArray alloc]init];
    while (count_question<test_length) {
        int div;
        if ([_a count] > 0) {
            div = RAND_MAX / [_a count];
        } else div = 1;
        int index = rand() / div;
        NSString *q;
        if (index<[_a count]) {
            q = [_a objectAtIndex:index];
        } else q = nil;
        
        if (q && ![q isEqualToString:_corect_answer]){
            [a addObject:q];
        }
        count_question++;
        [_a removeObject:q];
    }
    if ([a count]>=6){
        int div = RAND_MAX / [a count];
        int index = rand() / div;
        [a replaceObjectAtIndex:index withObject:ca];
    } else
    {
        int index = 0;
        if ([a count]>1){
            int div = RAND_MAX / [a count];
            index = rand() / div;
        } else {
            int div = RAND_MAX / [a count];
            index = rand() / (div / 10);
            index = (index+5) / 10;
        }
        [a insertObject:ca atIndex:index];
    }
    _answers = [[NSArray alloc] initWithArray:a];
}


@end
