//
//  Pages.h
//  ceskyjazyk
//
//  Created by Jan Damek on 27.08.14.
//  Copyright (c) 2014 PMQ-Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Intros;

@interface Pages : NSManagedObject

@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSNumber * fixed;
@property (nonatomic, retain) NSNumber * order;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) Intros *relationship_intro;

@end
