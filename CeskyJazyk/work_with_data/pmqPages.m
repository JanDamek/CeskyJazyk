//
//  pmqPages.m
//  Matematika
//
//  Created by Jan Damek on 26.05.14.
//  Copyright (c) 2014 PMQ-Software. All rights reserved.
//

#import "pmqPages.h"

@interface pmqPages(){
    
    NSInteger _drawToIndex;
    
    NSMutableArray *_charAtPos;
    NSArray *_rows;
}

@end

@implementation pmqPages

@synthesize data = _data;
@synthesize numOfRows = _numOfRows;
@synthesize numOfColumns = _numOfColumns;
@synthesize actualIndex = _actualIndex;
@synthesize numOfItems = _numOfItems;

#pragma mark - property getters

-(void)setData:(Pages *)data{
    _data = data;
    [self prepareData];
}

-(NSInteger)numOfItems{
    return _numOfItems;
}
-(NSInteger)numOfRows{
    return _numOfRows;
}
-(NSInteger)numOfColumns{
    return _numOfColumns;
}
-(NSString *)actualChar{
    return [_charAtPos objectAtIndex:_actualIndex-1];
}

#pragma mark - methodts for work with data

-(BOOL)next{
    
    _actualIndex++;
    
    if (_actualIndex<=_numOfColumns){
        NSString *item = [_charAtPos objectAtIndex:_actualIndex-1];
        if ([item isEqualToString:@" "] && _actualIndex<=_numOfColumns)
            [self next];
    }
    if (_actualIndex<=_numOfColumns){
        _drawToIndex = _numOfItems;
        return YES;
    } else return NO;
}

-(id)objectForItemIndex:(NSInteger)index{
    NSString *item = [_charAtPos objectAtIndex:index];
    NSArray *test_pos = [item componentsSeparatedByString:@":"];
    if ([test_pos count]>1) {
        _drawToIndex = [[test_pos objectAtIndex:0] intValue];
        item = [test_pos objectAtIndex:1];
    }
    if ((_drawToIndex ==_numOfItems) |
        ((_drawToIndex)<=_actualIndex)
        ) {
        if ([item hasSuffix:@"#"]) {
            return [UIImage imageNamed:item];
        } else {
            
            if ([item hasSuffix:@"."]){
                return @"";
            } else
                return item;
        }
    }else return @"";
}

#pragma mark - preparation of data

-(void)prepareData{
    _actualIndex = 0;
    
    if ([_data.type isEqualToString:@"html"]) {
        _numOfColumns = 1;
        _charAtPos = [[NSMutableArray alloc]init];
        [_charAtPos addObject:_data.content];
    }else{
        _numOfColumns = -1;
        _charAtPos = [[NSMutableArray alloc]init];
        
        NSString *r = [_data.content stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\n "]];
        
        _rows = [r componentsSeparatedByString:@"\n"];
        for (NSString *s in _rows) {
            NSString *item = [s stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\n "]];
            item = [item stringByReplacingOccurrencesOfString:@"   " withString:@" "];
            item = [item stringByReplacingOccurrencesOfString:@"  " withString:@" "];
            item = [item stringByReplacingOccurrencesOfString:@"  " withString:@" "];
            item = [item stringByReplacingOccurrencesOfString:@"  " withString:@" "];
            NSArray *item_in_row = [item componentsSeparatedByString:@" "];
            NSInteger i = [item_in_row count];
            if (_numOfColumns < i ) {
                _numOfColumns = i;
            }
        }
        for (NSString *s in _rows) {
            NSString *item = [s stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\n "]];
            item = [item stringByReplacingOccurrencesOfString:@"   " withString:@" "];
            item = [item stringByReplacingOccurrencesOfString:@"  " withString:@" "];
            item = [item stringByReplacingOccurrencesOfString:@"  " withString:@" "];
            item = [item stringByReplacingOccurrencesOfString:@"  " withString:@" "];
            NSArray *item_in_row = [item componentsSeparatedByString:@" "];
            NSInteger i = [item_in_row count];
            [_charAtPos addObjectsFromArray:item_in_row];
            for (NSInteger y=i; y<_numOfColumns; y++) {
                [_charAtPos addObject:@" "];
            }
        }
    }
    _numOfRows = [_rows count];
    _numOfItems = [_charAtPos count];
    _drawToIndex = _numOfItems;
}

@end
