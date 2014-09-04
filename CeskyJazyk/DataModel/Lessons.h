//
//  Lessons.h
//  ceskyjazyk
//
//  Created by Jan Damek on 04.09.14.
//  Copyright (c) 2014 PMQ-Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Intros, Tests;

@interface Lessons : NSManagedObject

@property (nonatomic, retain) NSNumber * demo;
@property (nonatomic, retain) NSNumber * lesson_id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * order;
@property (nonatomic, retain) NSString * purchase;
@property (nonatomic, retain) NSNumber * rating;
@property (nonatomic, retain) NSSet *relationship_intro;
@property (nonatomic, retain) Tests *relationship_test;
@end

@interface Lessons (CoreDataGeneratedAccessors)

- (void)addRelationship_introObject:(Intros *)value;
- (void)removeRelationship_introObject:(Intros *)value;
- (void)addRelationship_intro:(NSSet *)values;
- (void)removeRelationship_intro:(NSSet *)values;

@end
