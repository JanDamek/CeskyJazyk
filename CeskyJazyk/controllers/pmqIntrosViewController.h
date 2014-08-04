//
//  pmqPagesViewController.h
//  Matematika
//
//  Created by Jan Damek on 23.05.14.
//  Copyright (c) 2014 PMQ-Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "Intros.h"

@interface pmqIntrosViewController : UIViewController <AVAudioPlayerDelegate>

@property (nonatomic, strong) Intros *data;

@end
