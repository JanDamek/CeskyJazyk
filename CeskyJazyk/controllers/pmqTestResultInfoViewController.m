//
//  pmqTestResultInfoViewController.m
//  Matematika
//
//  Created by Jan Damek on 05.06.14.
//  Copyright (c) 2014 PMQ-Software. All rights reserved.
//

#import "pmqTestResultInfoViewController.h"
#import "pmqResultInfoViewController.h"
#import "Tests.h"
#import <QuartzCore/QuartzCore.h>
#import "pmqAppDelegate.h"

@interface pmqTestResultInfoViewController (){
    AVAudioPlayer *_player;
    int playStatus;
}

@property (weak, nonatomic) IBOutlet UIImageView *resultImage;
@property (weak, nonatomic) IBOutlet UIImageView *starsResult;
@property (weak, nonatomic) IBOutlet UILabel *badAnswer;
@property (weak, nonatomic) IBOutlet UILabel *totalQuestion;
@property (weak, nonatomic) IBOutlet UILabel *inTime;
@property (weak, nonatomic) IBOutlet UILabel *labelResult;

@property (weak, nonatomic) IBOutlet UIButton *btnTestResult;
@property (weak, nonatomic) IBOutlet UIButton *btnRetry;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;
@end

@implementation pmqTestResultInfoViewController

@synthesize result = _result;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)nextAction:(UIButton *)sender {
    int i = [self.navigationController.viewControllers count]-2;
    pmqTestingViewController *c = [self.navigationController.viewControllers objectAtIndex:i];
    c.isNew = YES;
    
    if (c.testMode==tmPractice){
        c.testMode = tmTestOnTime;
    }else{
        Lessons *l = c.data.relationship_lesson;
        pmqAppDelegate *d = [[UIApplication sharedApplication]delegate];
        NSIndexPath *i = [d.data.lessons indexPathForObject:l];
        int r = i.row;
        r++;
        i = [NSIndexPath indexPathForRow:r inSection:i.section];
        l = [d.data.lessons objectAtIndexPath:i];
        
        c.data = l.relationship_test;
        c.isNew = YES;
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)repeatAction:(UIButton *)sender {
    int i = [self.navigationController.viewControllers count]-2;
    pmqTestingViewController *c = [self.navigationController.viewControllers objectAtIndex:i];
    c.isNew = YES;
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    //proces pri ukonceni
}

- (IBAction)backBtnAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    
//    self.btnNext.layer.cornerRadius = 10;
//    self.btnRetry.layer.cornerRadius = 10;
//    self.btnTestResult.layer.cornerRadius = 10;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self setViews];
}

-(void)setViews{
    int r = [_result.rate intValue];
    
    self.starsResult.image = [UIImage imageNamed:[NSString stringWithFormat:@"5stars_fg%i_684x148", r ]];
    self.resultImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"boy%i1", r ]];
    
    if (r<=1){
        self.resultImage.animationImages = [NSArray arrayWithObjects:
                                            [UIImage imageNamed:@"boy51.png"],
                                            [UIImage imageNamed:@"boy52.png"],
                                            [UIImage imageNamed:@"boy53.png"],
                                            [UIImage imageNamed:@"boy54.png"],
                                            [UIImage imageNamed:@"boy55.png"],
                                            [UIImage imageNamed:@"boy54.png"],
                                            [UIImage imageNamed:@"boy53.png"],
                                            [UIImage imageNamed:@"boy52.png"],
                                            nil
                                            ];
    } else
        if (r==2){
            self.resultImage.animationImages = [NSArray arrayWithObjects:
                                                [UIImage imageNamed:@"boy41.png"],
                                                [UIImage imageNamed:@"boy42.png"],
                                                [UIImage imageNamed:@"boy43.png"],
                                                [UIImage imageNamed:@"boy44.png"],
                                                [UIImage imageNamed:@"boy45.png"],
                                                [UIImage imageNamed:@"boy44.png"],
                                                [UIImage imageNamed:@"boy43.png"],
                                                [UIImage imageNamed:@"boy42.png"],
                                                nil
                                                ];
        }else
            if (r==3){
                self.resultImage.animationImages = [NSArray arrayWithObjects:
                                                    [UIImage imageNamed:@"boy31.png"],
                                                    [UIImage imageNamed:@"boy32.png"],
                                                    [UIImage imageNamed:@"boy33.png"],
                                                    [UIImage imageNamed:@"boy34.png"],
                                                    [UIImage imageNamed:@"boy35.png"],
                                                    [UIImage imageNamed:@"boy34.png"],
                                                    [UIImage imageNamed:@"boy33.png"],
                                                    [UIImage imageNamed:@"boy32.png"],
                                                    nil
                                                    ];
            } else
                if (r==4){
                    self.resultImage.animationImages = [NSArray arrayWithObjects:
                                                        [UIImage imageNamed:@"boy21.png"],
                                                        [UIImage imageNamed:@"boy22.png"],
                                                        [UIImage imageNamed:@"boy23.png"],
                                                        [UIImage imageNamed:@"boy24.png"],
                                                        [UIImage imageNamed:@"boy25.png"],
                                                        [UIImage imageNamed:@"boy24.png"],
                                                        [UIImage imageNamed:@"boy23.png"],
                                                        [UIImage imageNamed:@"boy22.png"],
                                                        nil
                                                        ];
                } else {
                    self.resultImage.animationImages = [NSArray arrayWithObjects:
                                                        [UIImage imageNamed:@"boy11.png"],
                                                        [UIImage imageNamed:@"boy12.png"],
                                                        [UIImage imageNamed:@"boy13.png"],
                                                        [UIImage imageNamed:@"boy14.png"],
                                                        [UIImage imageNamed:@"boy15.png"],
                                                        [UIImage imageNamed:@"boy14.png"],
                                                        [UIImage imageNamed:@"boy13.png"],
                                                        [UIImage imageNamed:@"boy12.png"],
                                                        nil
                                                        ];
                }
    
    self.resultImage.animationRepeatCount = -1;
    self.resultImage.animationDuration = 1.75;
    [self.resultImage startAnimating];
    
    NSString *s = [NSString stringWithFormat:@"result_%i", r ];
    self.labelResult.text = NSLocalizedString(s, nil);
    
    int min = [_result.total_time floatValue] / 60;
    int sec = [_result.total_time floatValue] - (min*60);
    self.inTime.text = [NSString stringWithFormat:@"%02i:%02i", min, sec];
    
    self.badAnswer.text = [_result.bad_answers stringValue];
    self.totalQuestion.text = [NSString stringWithFormat:@"%lu", (unsigned long)[_result.relationship_questions count]];
    
    [_btnRetry setHidden: ([_result.bad_answers intValue]==0)];
    switch (_testMode) {
        case tmPractice:
            [_btnNext setHidden:[_result.bad_answers intValue]!=0];
            break;
        case tmNone:
        case tmPracticeFails:
        case tmPracticeOverAllFail:
            [_btnNext setHidden:YES];
            break;
        case tmTestOnTime:
            [_btnNext setHidden:[_result.bad_answers intValue]!=0];
            break;
    }
    
    [_btnTestResult setHidden:_testMode!=tmTestOnTime];
    
    [self playResult];
}

-(void)setResult:(Results *)result{
    _result = result;
}

-(void)playResult{
    //todo play result
    if (_result && !_player) {
        @try {
            playStatus = 1;
            NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                                 pathForResource:@"math_result1"
                                                 ofType:@"aac"]];
            _player = [[AVAudioPlayer alloc]
                       initWithContentsOfURL:url
                       error:nil];
            _player.delegate = self;
            [_player play];
        }
        @catch (NSException *exception) {
            NSLog(@"%@", exception);
        }
    }
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    if (playStatus==1){
        playStatus = 2;
        NSNumber *ok = [NSNumber numberWithInt:(12 - [_result.bad_answers intValue])];
        NSString *file = [ok stringValue];
        NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                             pathForResource:file
                                             ofType:@"aac"]];
        _player = [[AVAudioPlayer alloc]
                   initWithContentsOfURL:url
                   error:nil];
        _player.delegate = self;
        [_player play];
        
    } else if (playStatus==2){
        playStatus = 0;
        NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                             pathForResource:@"math_result2"
                                             ofType:@"aac"]];
        _player = [[AVAudioPlayer alloc]
                   initWithContentsOfURL:url
                   error:nil];
        _player.delegate = self;
        [_player play];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"vysledekTestu"]) {
        [(pmqResultInfoViewController*)[segue destinationViewController] setDataResult:_result];
    }
}


@end
