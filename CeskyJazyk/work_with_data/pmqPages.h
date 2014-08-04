//
//  pmqPages.h
//  Matematika
//
//  Created by Jan Damek on 26.05.14.
//  Copyright (c) 2014 PMQ-Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Pages.h"

@interface pmqPages : NSObject

@property (nonatomic, strong) Pages *data;

@property (readonly) NSInteger numOfRows;
@property (readonly) NSInteger numOfColumns;
@property (readonly) NSInteger numOfItems;
@property (readonly) NSInteger actualIndex;
@property (readonly) NSString *actualChar;

-(BOOL)next;
-(id)objectForItemIndex:(NSInteger)index;

@end
