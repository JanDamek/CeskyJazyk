//
//  pmqData.h
//  Matematika
//
//  Created by Jan Damek on 22.05.14.
//  Copyright (c) 2014 PMQ-Software. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Lessons.h"
#import "Pages.h"
#import "Results.h"
#import "Intros.h"
#import "Tests.h"
#import "Questions.h"

@interface pmqData : NSObject

-(void)testParseXMLGameData;

#pragma mark - Lesson definition

@property (strong, nonatomic, getter = getLessons) NSFetchedResultsController *lessons;
-(Lessons*)newLessons;
-(void)saveLessons;
-(Lessons*)findLessonId:(int)lesson_id;

#pragma mark - Pages definition

@property (strong, nonatomic, getter = getPages) NSFetchedResultsController *pages;
-(Pages*)newPages;
-(void)savePages;

#pragma mark - Results definition

@property (strong, nonatomic, getter = getResults) NSFetchedResultsController *results;
-(Results*)newResults;
-(void)saveResults;

#pragma mark - Intros definition

@property (strong, nonatomic, getter = getIntros) NSFetchedResultsController *intros;
-(Intros*)newIntros;
-(void)saveIntros;

#pragma mark - Tests definition

@property (strong, nonatomic, getter = getTest) NSFetchedResultsController *tests;
-(Tests*)newTests;
-(void)saveTests;

#pragma mark - Questions definition

@property (strong, nonatomic, getter = getQuestions) NSFetchedResultsController *questions;
-(Questions*)newQuestions;
-(void)saveQuestions;

@end
