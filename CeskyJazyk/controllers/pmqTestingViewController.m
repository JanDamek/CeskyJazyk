//
//  pmqTestingViewController.m
//  Matematika
//
//  Created by Jan Damek on 27.05.14.
//  Copyright (c) 2014 PMQ-Software. All rights reserved.
//

#import "pmqTestingViewController.h"
#import "pmqQuestionMarkCell.h"
#import "Lessons.h"
#import "pmqAppDelegate.h"
#import "pmqQuestions.h"
#import "pmqTestResultInfoViewController.h"
#import "Tests.h"
#import "pmqQuestionControll.h"
#import <QuartzCore/QuartzCore.h>

@interface pmqTestingViewController (){
    
    float mark_size;
    
    NSMutableArray *_questions;
    
    NSMutableArray *_repeatFaults;
    
    int answered;
    
    AVAudioPlayer *_player;
    
    NSUInteger time_to_show_answer;
    
}

@property (weak, nonatomic) IBOutlet pmqQuestionControll *questionView;
@property (weak, nonatomic) IBOutlet UICollectionView *marks;
@property (strong, nonatomic) NSArray *q;
@property (weak, nonatomic) IBOutlet UIImageView *timeOutImage;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *answerButtons;

@end

@implementation pmqTestingViewController

@synthesize marks = _marks, q = _q;
@synthesize answerButtons = _answerButtons;
@synthesize testMode = _testMode;
@synthesize timeOutImage = _timeOutImage;
@synthesize isNew = _isNew;
@synthesize isRepeat = _isRepeat;

#pragma mark - initialization

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)backBtnAction:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _isNew = YES;
    _isRepeat = NO;
    
    _repeatFaults = [[NSMutableArray alloc] init];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        mark_size = (_marks.frame.size.width - 120) / 12;
    }else{
        mark_size = (_marks.frame.size.width - 60) / 12;
    }
    
    for (UIButton *b in self.answerButtons) {
        b.layer.cornerRadius = 10;
    }
    
    _questionView.showState = qcHideAll;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }
    
    _questionView.delegate = self;
}

- (IBAction)btnStartAction:(id)sender {
    [self prepareTest];
    
    [self loadFromLastTest];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (_isNew) {
        if ([_data.welcome_sound hasSuffix:@"mp3"]) {
            NSString *sound_file = [[_data.welcome_sound lastPathComponent] stringByDeletingPathExtension];
            @try {
                NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                                     pathForResource:sound_file
                                                     ofType:@"aac"]];
                _player = [[AVAudioPlayer alloc]
                           initWithContentsOfURL:url
                           error:nil];
                _player.delegate = self;
                [_player play];
            }
            @catch (NSException *exception) {
                _isNew = NO;
                [self btnStartAction:nil];
            }
            @finally {
            }
        } else {
            _isNew = NO;
            [self btnStartAction:nil];
        }
    } else {
        [self.navigationController popViewControllerAnimated:NO];
    }
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    if (_isNew) {
        [self btnStartAction:nil];
        _isNew = NO;
    }
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(mark_size, mark_size);
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    [_questionView setNeedsDisplay];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - property setters and gettrs

-(void)setData:(Tests *)data{
    _data = data;
    
    if (data.relationship_lesson){
        _q = [data.relationship_question allObjects];
    }else {
        pmqAppDelegate *d = (pmqAppDelegate*)[[UIApplication sharedApplication]delegate];
        _q = [d.data.questions fetchedObjects];
    }
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        mark_size = (_marks.frame.size.width - 120) / [_data.test_length intValue];
    }else{
        mark_size = (_marks.frame.size.width - 60) / [_data.test_length intValue];
    }
    
    self.navigationItem.title = data.relationship_lesson.name;
}

-(enum TestMode)testMode{
    return _testMode;
}

-(void)setTestMode:(enum TestMode)testMode{
    answered = 0;
    [_marks reloadData];
    
    _questionView.showState = qcHideAll;
    
    for (UIButton *b in self.answerButtons) {
        [b setHidden:YES];
        b.backgroundColor = [UIColor lightGrayColor];
    }
    
    _testMode = testMode;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    _questionView.delegate = nil;
    _questionView.showState = qcHideAll;
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    pmqAppDelegate *d = (pmqAppDelegate*)[[UIApplication sharedApplication]delegate];
    if (_testMode==tmTestOnTime){
        [d.data saveResults];
        [d.data saveTests];
    }else{
        [[d.data.tests managedObjectContext] rollback];
        [[d.data.results managedObjectContext] rollback];
        
        NSError *error =nil;
        [d.data.results performFetch:&error];
        NSAssert(!error, @"Error performing fetch request: %@", error);
        [d.data.lessons performFetch:&error];
        NSAssert(!error, @"Error performing fetch request: %@", error);
    }
}

#pragma mark - test methods

-(void)prepareQuestions:(NSMutableArray*)questions firstFail:(bool)firstFail{
    int count_question = 0;
    
    if ([questions count]<[_data.test_length intValue]) {
        _data.test_length = [NSNumber numberWithInteger:[questions count]];
    }
    
    int test_length = [_data.test_length intValue];
    if (test_length==0) {
        test_length = 12;
    }
    
    int lesson_id=[[(Questions*)[questions objectAtIndex:[questions count]-1]lesson_id]intValue];
    if (_isRepeat){
        _questions = [[NSMutableArray alloc] init];
        [_questions addObjectsFromArray:_repeatFaults];
        count_question += [_repeatFaults count];
    } else
        _questions = [[NSMutableArray alloc] init];
    
    _repeatFaults = [[NSMutableArray alloc] init];
    
    Questions *q;
    if (firstFail){
        int index = 0;
        while ((index<[questions count]) && (count_question<test_length)){
            q = (Questions*)[questions objectAtIndex:index];
            if ([q.last_answer intValue]==0){
                count_question++;
                [_questions addObject:q];
                index--;
                [questions removeObject:q];
                //lesson_id = [q.lesson_id intValue];
            }
            index++;
        }
    }
    
    while (count_question<test_length) {
        int div = RAND_MAX / [questions count];
        int index = rand() / div;
        Questions *q;
        if (index<[questions count]) {
            q = (Questions*)[questions objectAtIndex:index];
        } else {
            q = nil;
            count_question++;
        };
        int l = [q.lesson_id intValue];
        if (l==lesson_id) {
            count_question++;
            if (q)
                [_questions addObject:q];
            [questions removeObject:q];
        } else
            [questions removeObject:q];
    }
}

-(void)loadFromLastTest{
    [_marks reloadData];
    
    //TODO: oprava ze neni questions
    
    pmqQuestions *pmqQ = [[pmqQuestions alloc]init];
    if (answered < [_questions count]){
        pmqQ.q = (Questions*)[_questions objectAtIndex:answered];
    } else pmqQ.q = (Questions*)[_questions objectAtIndex:answered - [_questions count]];
    
    [_questionView setQuestion:pmqQ.fistPartQuestion secondPartQuestion:pmqQ.secondPartQuestion correctAnswer:pmqQ.corect_answer onTime:(_testMode == tmTestOnTime) timeToAnwser:[_data.time_limit intValue]];
    
    if (_testMode != tmTestOnTime){
        _questionView.showState = qcQuestion;
    }else{
        _questionView.showState = qcOnTime;
    }
    
    int i=0;
    for (UIButton *b in _answerButtons) {
        if (i<[pmqQ.answers count]){
            NSString *s = [pmqQ.answers objectAtIndex:i];
            if ([s hasPrefix:@"*"]){
                s = [s substringFromIndex:1];
                b.tag = 1;
            } else b.tag = 0;
            [b setTitle:s forState:UIControlStateNormal];
            [b setHidden:NO];
            [b setEnabled:YES];
        } else {
            [b setHidden:YES];
            [b setEnabled:NO];
            [b setTag:0];
            [b setTitle:@"" forState:UIControlStateNormal];
            
        }
        i++;
    }
    
}

-(NSFetchedResultsController *)results{
    
    pmqAppDelegate *d = (pmqAppDelegate*)[[UIApplication sharedApplication]delegate];
    NSFetchedResultsController *_results = d.data.results;
    
    return _results;
}

-(void)prepareTest{
    answered = 0;
    
    switch (_testMode) {
        case tmPractice:
        case tmTestOnTime:
            [self prepareQuestions:[[_data.relationship_question allObjects] mutableCopy] firstFail:NO];
            break;
            
        case tmPracticeFails:
            [self prepareQuestions:[[_data.relationship_question allObjects] mutableCopy] firstFail:YES];
            break;
            
        case tmPracticeOverAllFail:{
            NSMutableArray *lastFault = [[NSMutableArray alloc] initWithCapacity:12];
            id <NSFetchedResultsSectionInfo> sectionInfo = [[[self results] sections] objectAtIndex:0];
            NSArray *re = [sectionInfo objects];
            Results *lastResult = nil;
            if ([re count]>0)
                for (Results *r in re){
                    if (!lastResult) lastResult = r;
                    
                    if (![r.answer1 boolValue])
                        [lastFault addObject:r.relationship_questions1];
                    if (![r.answer2 boolValue])
                        [lastFault addObject:r.relationship_questions2];
                    if (![r.answer3 boolValue])
                        [lastFault addObject:r.relationship_questions3];
                    if (![r.answer4 boolValue])
                        [lastFault addObject:r.relationship_questions4];
                    if (![r.answer5 boolValue])
                        [lastFault addObject:r.relationship_questions5];
                    if (![r.answer6 boolValue])
                        [lastFault addObject:r.relationship_questions6];
                    if (![r.answer7 boolValue])
                        [lastFault addObject:r.relationship_questions7];
                    if (![r.answer8 boolValue])
                        [lastFault addObject:r.relationship_questions8];
                    if (![r.answer9 boolValue])
                        [lastFault addObject:r.relationship_questions9];
                    if (![r.answer10 boolValue])
                        [lastFault addObject:r.relationship_questions10];
                    if (![r.answer11 boolValue])
                        [lastFault addObject:r.relationship_questions11];
                    if (![r.answer12 boolValue])
                        [lastFault addObject:r.relationship_questions12];
                    if ([lastFault count]>=12)
                        break;
                }
            
            if ([lastFault count]<12){
                NSArray *qq = [lastResult.relationship_test.relationship_question allObjects];
                [lastFault addObjectsFromArray:qq];
                _data = lastResult.relationship_test;
            }else _data = lastResult.relationship_test;
            if ([lastFault count]<12){
                pmqAppDelegate *d = (pmqAppDelegate*)[[UIApplication sharedApplication]delegate];
                Lessons *l = [[[[d.data.lessons sections]objectAtIndex:0]objects]objectAtIndex:0];
                NSArray *qq = [l.relationship_test.relationship_question allObjects];
                [lastFault addObjectsFromArray:qq];
                _data = l.relationship_test;
            }
            //            Tests *te;
            //            for (Lessons *l in [d.data.lessons fetchedObjects]) {
            //                if ([l.order intValue] == 16959){
            //                    te =l.relationship_test;
            //                    break;
            //                }
            //            }
            //            self.data = te;
            
            //            [self prepareQuestions:[[_data.relationship_question allObjects] mutableCopy] firstFail:YES];
            [self prepareQuestions:[lastFault mutableCopy] firstFail:YES];
            break;
        }
            
        default:
            break;
    }
}

-(void)markCorrect{
    [UIView beginAnimations:@"correct" context:nil];
    
    
    [UIView setAnimationDuration:time_to_show_answer];
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
}

-(void)prepareNextQuestion{
    if (answered<[_data.test_length intValue]){
        [UIView beginAnimations:@"next" context:nil];
        
        for (UIButton *b in self.answerButtons) {
            b.backgroundColor = [UIColor lightGrayColor];
        }
        
        [self loadFromLastTest];
        
        [UIView setAnimationDuration:0.1];
        [UIView setAnimationDelegate:self];
        [UIView commitAnimations];
    }else{
        [self makeResult];
    }
    [_timeOutImage setHidden:YES];
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
    if ([(NSString*)anim isEqualToString:@"answer"]){
        [self performSelector:@selector(markCorrect) withObject:nil afterDelay:time_to_show_answer / 5];
    } else if ( [(NSString*)anim isEqualToString:@"correct"] ){
        [self performSelector:@selector(prepareNextQuestion) withObject:nil afterDelay:time_to_show_answer];
    }
}

-(void)animateAnswer:(UIButton*)button{
    
    [_marks reloadData];
    
    if (button.tag==1){
        button.backgroundColor = [UIColor greenColor];
    } else {
        button.backgroundColor = [UIColor redColor];
    }
    
    for (UIButton *b in self.answerButtons) {
        if (b.tag==1){
            b.backgroundColor = [UIColor greenColor];
        }
        [b setEnabled:NO];
        if ([b isEqual:button] || b.tag==1) {
            [b setHidden:NO];
        } else [b setHidden:YES];
    }
    
    [self animationDidStop:@"answer" finished:YES];
}

- (IBAction)answerButtonAction:(UIButton *)sender {
    [_questionView.questionTimer invalidateTimer];
    
    Questions *q = [_questions objectAtIndex:answered];
    if (sender){
        q.last_answer = [NSNumber numberWithBool:sender.tag==1];
    } else
        q.last_answer = [NSNumber numberWithBool:NO];
    float inTime = _questionView.questionTimer.timeToCount*(_questionView.questionTimer.percent/100);
    if (inTime==0) inTime = _questionView.questionTimer.timeToCount;
    q.time_of_answer = [NSNumber numberWithFloat:inTime];
    
    if ([q.last_answer boolValue]) {
        _questionView.showState = qcAnswer;
        time_to_show_answer = 1;
    } else {
        _questionView.showState = qcAnswerBad;
        time_to_show_answer = 3;
        [_repeatFaults addObject:q];
    }
    [_questions setObject:q atIndexedSubscript:answered];
    
    answered++;
    
    NSString *sound_file;
    if (sender==nil){
        sound_file = @"snd_timeout";
        [_timeOutImage setHidden:NO];
    } else if (sender.tag==1){
        sound_file = @"snd_correct";
    } else sound_file = @"snd_failed";
    
    @try {
        NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                             pathForResource:sound_file
                                             ofType:@"aac"]];
        _player = [[AVAudioPlayer alloc]
                   initWithContentsOfURL:url
                   error:nil];
        _player.delegate = self;
        [_player play];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    [self animateAnswer:sender];
}

-(void)makeResult{
    pmqAppDelegate *d = (pmqAppDelegate*)[[UIApplication sharedApplication]delegate];
    Results *r = [d.data newResults];
    [_data addRelationship_resultsObject:r];
    r.relationship_test = _data;
    
    float total_time = 0;
    int bad_answer = 0;
    for (int i=0; i<[_questions count]; i++) {
        Questions *q = [_questions objectAtIndex:i];
        total_time += [q.time_of_answer floatValue];
        if ([q.last_answer integerValue]==0){
            bad_answer++;
        }
        switch (i) {
            case 0:
                r.relationship_questions1 = q;
                r.answer1 = [q.last_answer copy];
                break;
            case 1:
                r.relationship_questions2 = q;
                r.answer2 = [q.last_answer copy];
                break;
            case 2:
                r.relationship_questions3 = q;
                r.answer3 = [q.last_answer copy];
                break;
            case 3:
                r.relationship_questions4 = q;
                r.answer4 = [q.last_answer copy];
                break;
            case 4:
                r.relationship_questions5 = q;
                r.answer5 = [q.last_answer copy];
                break;
            case 5:
                r.relationship_questions6 = q;
                r.answer6 = [q.last_answer copy];
                break;
            case 6:
                r.relationship_questions7 = q;
                r.answer7 = [q.last_answer copy];
                break;
            case 7:
                r.relationship_questions8 = q;
                r.answer8 = [q.last_answer copy];
                break;
            case 8:
                r.relationship_questions9 = q;
                r.answer9 = [q.last_answer copy];
                break;
            case 9:
                r.relationship_questions10 = q;
                r.answer10 = [q.last_answer copy];
                break;
            case 10:
                r.relationship_questions11 = q;
                r.answer11 = [q.last_answer copy];
                break;
            case 11:
                r.relationship_questions12 = q;
                r.answer12 = [q.last_answer copy];
                break;
        }
    }
    r.total_time = [NSNumber numberWithFloat:total_time];
    r.bad_answers = [NSNumber numberWithInt:bad_answer];
    r.date = [NSDate date];
    
    int test_length = [r.relationship_test.test_length intValue];
    float rate =5 * ((float)test_length - (float)bad_answer)/(float)test_length;
    
    //Pouze pro vysledek testu v zavislosti take na rychlosti odpovedi
    //float max_time = [r.relationship_test.time_limit intValue]*test_length;
    //rate -= 2 * (total_time/max_time);
    rate = floorf(rate+0.49);
    
    r.rate = [NSNumber numberWithInt:(int)rate];
    
    if (_testMode==tmTestOnTime) {
        r.relationship_test.relationship_lesson.rating = r.rate;
    }
    
    NSError *error =nil;
    [d.data.results performFetch:&error];
    NSAssert(!error, @"Error performing fetch request: %@", error);
    [d.data.lessons performFetch:&error];
    NSAssert(!error, @"Error performing fetch request: %@", error);
    
    pmqTestResultInfoViewController *c = [self.storyboard instantiateViewControllerWithIdentifier:@"TestResult"];
    c.result = r;
    c.testMode = _testMode;
    [self.navigationController pushViewController:c animated:YES];
    
    _questionView.showState = qcHideAll;
    
    for (UIButton *b in _answerButtons) {
        [b setHidden:YES];
    }
}

#pragma mark - collection delegate & dataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [_data.test_length intValue];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    pmqQuestionMarkCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"otazkaTest" forIndexPath:indexPath];
    
    if (indexPath.row<answered) {
        Questions *q = [_questions objectAtIndex:indexPath.row];
        cell.correct = [q.last_answer boolValue];
    } else [cell noAnswer];
    
    return cell;
}

#pragma mark - timer delegate

-(void)terminatedTimer:(UIArcTimerView *)timerView{
    _questionView.questionTimer.percent = 0;
    [self answerButtonAction:nil];
}


@end
