//
//  pmgParseXMLToData.m
//  Matematika
//
//  Created by Jan Damek on 22.05.14.
//  Copyright (c) 2014 PMQ-Software. All rights reserved.
//

#import "pmqParseXMLToData.h"
#import "pmqAppDelegate.h"
#import "XMLReader.h"
#import "Lessons.h"
#import "pmqData.h"

@interface pmqParseXMLToData()

@property (readonly, strong, getter = getD) pmqData *d;

@end

@implementation pmqParseXMLToData

@synthesize d = _d;

-(pmqData*)getD{
    if (!_d){
        pmqAppDelegate *delegate = (pmqAppDelegate*)[[UIApplication sharedApplication]delegate];
        _d = delegate.data;
    }
    return _d;
}

-(void)doParse{
    NSInteger lesson_order = 1;
    NSInteger intros_order = 1;
    NSInteger pages_order = 1;
    
    NSString *filePath = [ [ NSBundle mainBundle ] pathForResource: @"game_definition" ofType: @"xml" ];
    NSString *xml = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
    NSDictionary *in_data = [[XMLReader dictionaryForXMLString:xml error:NULL] valueForKey:@"PMQcalculations"];
    
    
    for (NSDictionary *i in [in_data valueForKey:@"lesson"]) {
        
        int lesson_id = [[i valueForKey:@"id"] intValue] ;
        Lessons *l = [self.d newLessons];
        l.lesson_id = [NSNumber numberWithInt:lesson_id];
        l.demo = [NSNumber numberWithInt:[[i valueForKey:@"demo"] intValue]];
        l.name = [i valueForKey:@"name"];
        l.rating = [NSNumber numberWithInt:0];
        l.name = [l.name stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\n "]];
        l.order = [NSNumber numberWithInteger:lesson_order];
        lesson_order++;
        
        Tests *test = [self.d newTests];
        l.relationship_test = test;
        
        Intros *intros = [self.d newIntros];
        intros.order = [NSNumber numberWithInteger:intros_order];
        intros_order++;
        [l addRelationship_introObject:intros];
        
        NSDictionary *intr = [i valueForKey:@"intro"];
        id pp = [intr valueForKey:@"page"];
        if ([pp isKindOfClass:[NSArray class] ]) {
            for (NSDictionary *page in pp) {
                Pages *p = [self.d newPages];
                
                p.order = [NSNumber numberWithInteger:pages_order];
                int fixed;
                @try {
                    fixed = [[page valueForKey:@"fixed"] intValue];
                }
                @catch (NSException *exception) {
                    fixed = 0;
                }
                p.fixed = [NSNumber numberWithInt:fixed];
                @try {
                    p.type = [page valueForKey:@"type"];
                }
                @catch (NSException *exception) {
                    
                }
                @try {
                    p.content = [page valueForKey:@"text"];
                }
                @catch (NSException *exception) {
                    p.content = @"";
                }
                p.content = [p.content stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\n "]];
                
                [intros addRelationship_pagesObject:p];
                pages_order++;
                [self.d savePages];
            }
        } else
        {
            Pages *p = [self.d newPages];
            
            p.order = [NSNumber numberWithInteger:pages_order];
            int fixed;
            @try {
                fixed = [[pp valueForKey:@"fixed"] intValue];
            }
            @catch (NSException *exception) {
                fixed = 0;
            }
            p.fixed = [NSNumber numberWithInt:fixed];
            @try {
                p.type = [pp valueForKey:@"type"];
            }
            @catch (NSException *exception) {
                
            }
            @try {
                p.content = [pp valueForKey:@"text"];
            }
            @catch (NSException *exception) {
                p.content = @"";
            }
            p.content = [p.content stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\n "]];
            [intros addRelationship_pagesObject:p];
            pages_order++;
            [self.d savePages];
        }
        [self.d saveIntros];
        
        NSDictionary *te = [i valueForKey:@"test"];
        test.time_limit = [NSNumber numberWithInt:[[te valueForKey:@"timeLimit"] intValue]];
        test.welcome_sound = [te valueForKey:@"welcomeSound"];
        test.test_length = [NSNumber numberWithInt:[[in_data valueForKey:@"testLength"] intValue]];
        for (NSDictionary *question in [te valueForKey:@"question"]) {
            Questions *q = [self.d newQuestions];
            [test addRelationship_questionObject:q];
            
            q.content = [question valueForKey:@"text"];
            q.lesson_id = [NSNumber numberWithInt:lesson_id];
            q.content = [q.content stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\n "]];
            [self.d saveQuestions];
        }
        [self.d saveTests];
    }
    
    [self.d saveLessons];
    
    [self makeOneOfAll];
}

-(void)makeOneOfAll{
    NSError *error =nil;
    [self.d.lessons performFetch:&error];
    NSAssert(!error, @"Error performing fetch request: %@", error);
    
    [self.d.intros performFetch:&error];
    NSAssert(!error, @"Error performing fetch request: %@", error);
    
    [self.d.questions performFetch:&error];
    NSAssert(!error, @"Error performing fetch request: %@", error);
    
    
    Lessons *l = [_d newLessons];
    l.name = NSLocalizedString(@"allQuestion", nil);
    l.demo = [NSNumber numberWithInt:1];
    l.order = [NSNumber numberWithInt:16959];
    
    l.relationship_test = [_d newTests];
    l.relationship_test.time_limit = [NSNumber numberWithInt:12];
    l.relationship_test.test_length = [NSNumber numberWithInt:12];
    
    for (Questions *q in [_d.questions fetchedObjects]) {
        [l.relationship_test addRelationship_questionObject:q];
    }
    
    [_d saveLessons];
    
    [self.d.lessons performFetch:&error];
    NSAssert(!error, @"Error performing fetch request: %@", error);
}

@end
