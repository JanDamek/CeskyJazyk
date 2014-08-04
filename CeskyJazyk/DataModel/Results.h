//
//  Results.h
//  Matematika
//
//  Created by Jan Damek on 17.07.14.
//  Copyright (c) 2014 PMQ-Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Questions, Tests;

@interface Results : NSManagedObject

@property (nonatomic, retain) NSNumber * bad_answers;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * rate;
@property (nonatomic, retain) NSNumber * total_time;
@property (nonatomic, retain) NSSet *relationship_questions;
@property (nonatomic, retain) Tests *relationship_test;
@end

@interface Results (CoreDataGeneratedAccessors)

- (void)addRelationship_questionsObject:(Questions *)value;
- (void)removeRelationship_questionsObject:(Questions *)value;
- (void)addRelationship_questions:(NSSet *)values;
- (void)removeRelationship_questions:(NSSet *)values;

@end
