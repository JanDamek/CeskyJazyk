//
//  pmqResultInfoViewController.h
//  Matematika
//
//  Created by Jan Damek on 05.06.14.
//  Copyright (c) 2014 PMQ-Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Results.h"
#import <AVFoundation/AVFoundation.h>

@interface pmqResultInfoViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, AVAudioPlayerDelegate>

@property (strong, nonatomic) Results *dataResult;

@end
