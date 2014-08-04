//
//  pmqExpleinCell.h
//  Matematika
//
//  Created by Jan Damek on 25.05.14.
//  Copyright (c) 2014 PMQ-Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface pmqExpleinCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *lab;

-(void)highlite;

@end
