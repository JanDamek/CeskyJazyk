//
//  Questions.h
//  ceskyjazyk
//
//  Created by Jan Damek on 04.09.14.
//  Copyright (c) 2014 PMQ-Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Results, Tests;

@interface Questions : NSManagedObject

@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSNumber * last_answer;
@property (nonatomic, retain) NSNumber * lesson_id;
@property (nonatomic, retain) NSNumber * time_of_answer;
@property (nonatomic, retain) Results *relationship_result1;
@property (nonatomic, retain) Results *relationship_result2;
@property (nonatomic, retain) Results *relationship_result3;
@property (nonatomic, retain) Results *relationship_result4;
@property (nonatomic, retain) Results *relationship_result5;
@property (nonatomic, retain) Results *relationship_result6;
@property (nonatomic, retain) Results *relationship_result7;
@property (nonatomic, retain) Results *relationship_result8;
@property (nonatomic, retain) Results *relationship_result9;
@property (nonatomic, retain) Results *relationship_result10;
@property (nonatomic, retain) Results *relationship_result11;
@property (nonatomic, retain) Results *relationship_result12;
@property (nonatomic, retain) NSSet *relationship_test;
@end

@interface Questions (CoreDataGeneratedAccessors)

- (void)addRelationship_testObject:(Tests *)value;
- (void)removeRelationship_testObject:(Tests *)value;
- (void)addRelationship_test:(NSSet *)values;
- (void)removeRelationship_test:(NSSet *)values;

@end
