//
//  Intros.h
//  ceskyjazyk
//
//  Created by Jan Damek on 04.09.14.
//  Copyright (c) 2014 PMQ-Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Lessons, Pages;

@interface Intros : NSManagedObject

@property (nonatomic, retain) NSNumber * order;
@property (nonatomic, retain) Lessons *relationship_lesson;
@property (nonatomic, retain) NSSet *relationship_pages;
@end

@interface Intros (CoreDataGeneratedAccessors)

- (void)addRelationship_pagesObject:(Pages *)value;
- (void)removeRelationship_pagesObject:(Pages *)value;
- (void)addRelationship_pages:(NSSet *)values;
- (void)removeRelationship_pages:(NSSet *)values;

@end
