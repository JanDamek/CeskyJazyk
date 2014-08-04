//
//  pmqResultViewController.h
//  Matematika
//
//  Created by Jan Damek on 01.06.14.
//  Copyright (c) 2014 PMQ-Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Results.h"

@interface pmqResultViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UIPopoverController *masterPopoverController;

@end
