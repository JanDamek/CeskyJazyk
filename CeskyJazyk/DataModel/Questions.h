//
//  Questions.h
//  calculations
//
//  Created by Jan Damek on 29.07.14.
//  Copyright (c) 2014 PMQ-Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Results, Tests;

@interface Questions : NSManagedObject

@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSNumber * last_answer;
@property (nonatomic, retain) NSNumber * time_of_answer;
@property (nonatomic, retain) NSNumber * lesson_id;
@property (nonatomic, retain) NSSet *relationship_result;
@property (nonatomic, retain) NSSet *relationship_test;
@end

@interface Questions (CoreDataGeneratedAccessors)

- (void)addRelationship_resultObject:(Results *)value;
- (void)removeRelationship_resultObject:(Results *)value;
- (void)addRelationship_result:(NSSet *)values;
- (void)removeRelationship_result:(NSSet *)values;

- (void)addRelationship_testObject:(Tests *)value;
- (void)removeRelationship_testObject:(Tests *)value;
- (void)addRelationship_test:(NSSet *)values;
- (void)removeRelationship_test:(NSSet *)values;

@end
