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
#import <QuartzCore/QuartzCore.h>

@interface pmqTestingViewController (){
    
    float mark_size;
    
    NSMutableArray *_questions;
    
    int answered;
    
    AVAudioPlayer *_player;
    
    NSUInteger time_to_show_answer;
    
}

@property (weak, nonatomic) IBOutlet UICollectionView *marks;
@property (strong, nonatomic) NSArray *q;

@property (weak, nonatomic) IBOutlet UIArcTimerView *timerView;
@property (weak, nonatomic) IBOutlet UIImageView *questionMark;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel1;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel2;
@property (weak, nonatomic) IBOutlet UILabel *labelAnswer;

@property (weak, nonatomic) IBOutlet UIImageView *timeOutImage;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *answerButtons;

@end

@implementation pmqTestingViewController

@synthesize marks = _marks, q = _q;
@synthesize timerView = _timerView;
@synthesize answerButtons = _answerButtons;
@synthesize testMode = _testMode;
@synthesize labelAnswer = _labelAnswer;
@synthesize questionLabel1 = _questionLabel1;
@synthesize questionLabel2 = _questionLabel2;
@synthesize questionMark = _questionMark;
@synthesize timeOutImage = _timeOutImage;
@synthesize isNew = _isNew;

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
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _isNew = YES;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    
    _timerView.delegate = self;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
    mark_size = (_marks.frame.size.width - 120) / 12;
    }else{
        mark_size = (_marks.frame.size.width - 60) / 12;
    }
    
    for (UIButton *b in self.answerButtons) {
        b.layer.cornerRadius = 10;
    }
    
    UIImage *img = [UIImage imageNamed:@"timer_fg.png"];
    CGSize size = CGSizeMake(_timerView.frame.size.width,_timerView.frame.size.height);
    UIGraphicsBeginImageContext(size);
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage * newimage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    _timerView.fillColor = [UIColor colorWithPatternImage:newimage];
    _timerView.roundColor = [UIColor darkGrayColor];
    
    [_questionLabel1 setHidden:YES];
    [_questionLabel2 setHidden:YES];
    [_questionMark setHidden:YES];
    [_timerView setHidden:YES];
    [_labelAnswer setHidden:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }
    
}

- (IBAction)btnStartAction:(id)sender {
    [_questionLabel1 setHidden:NO];
    [_questionLabel2 setHidden:NO];
    
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
                [self performSelector:@selector(realignView) withObject:nil afterDelay:0.15];
            }
            @finally {
            }
        } else {
            _isNew = NO;
            [self btnStartAction:nil];
            [self performSelector:@selector(realignView) withObject:nil afterDelay:0.15];
        }
    } else {
        [self.navigationController popViewControllerAnimated:NO];
    }
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    if (_isNew) {
        [self btnStartAction:nil];
        [self performSelector:@selector(realignView) withObject:nil afterDelay:0.1];
        _isNew = NO;
    }
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(mark_size, mark_size);
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    [self realignView];
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}

-(void)setMenorFont{
    float font_size = _questionLabel1.font.pointSize;
    _questionLabel1.font = [_questionLabel1.font fontWithSize:font_size*0.9];
    _questionLabel2.font = [_questionLabel2.font fontWithSize:font_size*0.9];
    _labelAnswer.font = [_labelAnswer.font fontWithSize:font_size*0.9];
    [self realignView];
}

-(void)realignView{
//    [UIView beginAnimations:@"realign" context:nil];
    
    int midl = self.view.frame.size.width / 2;
    
    [_questionLabel1 sizeToFit];
    [_questionLabel2 sizeToFit];
    [_labelAnswer sizeToFit];
    
    CGRect q1 = _questionLabel1.frame;
    CGRect q2 = _questionLabel2.frame;
    CGRect qM = _questionMark.frame;
    CGRect ti = _timerView.frame;
    CGRect lA = _labelAnswer.frame;
    
    int size = q1.size.width;
    
    if (!_labelAnswer.isHidden){
        size += lA.size.width;
    } else
        if (!_questionMark.isHidden){
            size += qM.size.width;
        } else
            if (!_timerView.isHidden){
                size += ti.size.width;
            }else{
                //chyba definice, sem to nesmi dojid
                size +=qM.size.width;
            };
    
    size += q2.size.width;
    q1.origin.x = midl - (size / 2);
    if (q1.origin.x<10)
    {
        [self setMenorFont];
    }else{
    size = q1.origin.x + q1.size.width;
    
    if (!_labelAnswer.isHidden){
        lA.origin.x = size;
        size += lA.size.width;
    } else
        if (!_questionMark.isHidden){
            qM.origin.x = size;
            size += qM.size.width;
        } else
            if (!_timerView.isHidden){
                ti.origin.x = size;
                size += ti.size.width;
            };
    
    q2.origin.x = size;
    
    _questionLabel1.frame = q1;
    _questionLabel2.frame = q2;
    _questionMark.frame = qM;
    _timerView.frame = ti;
    _labelAnswer.frame = lA;
//    [UIView setAnimationDuration:0.3];
//    [UIView commitAnimations];
    }
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
    
    [self.questionLabel1 setHidden:YES];
    [self.timerView setHidden:YES];
    [self.questionLabel2 setHidden:YES];
    [self.questionMark setHidden:YES];
    [self.labelAnswer setHidden:YES];
    
    for (UIButton *b in self.answerButtons) {
        [b setHidden:YES];
        b.backgroundColor = [UIColor lightGrayColor];
    }
    
    _testMode = testMode;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    _timerView.delegate = nil;
    [_timerView invalidateTimer];
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
    
    int lesson_id=[[(Questions*)[questions objectAtIndex:0]lesson_id]intValue];
    _questions = [[NSMutableArray alloc] init];
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
                lesson_id = [q.lesson_id intValue];
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
    if (_questionLabel1){
        [_marks reloadData];
        
        pmqQuestions *pmqQ = [[pmqQuestions alloc]init];
        if (answered < [_questions count]){
            pmqQ.q = (Questions*)[_questions objectAtIndex:answered];
        } else pmqQ.q = (Questions*)[_questions objectAtIndex:answered - [_questions count]];
        
        
        _questionLabel1.text = pmqQ.fistPartQuestion;
        [_questionLabel1 sizeToFit];
        
        _questionLabel2.text = pmqQ.secondPartQuestion;
        [_questionLabel2 sizeToFit];

//        CGRect v = self.view.frame;
//        int pos = v.size.width / 2;
//        
//        CGRect s = _questionLabel2.frame;
//        s.origin.y = _questionLabel1.frame.origin.y;
//        
//        pos -= ((s.size.width  + _timerView.frame.size.width + _questionLabel1.frame.size.width)/2);
//        v = _questionLabel1.frame;
//        v.origin.x = pos;
        //_questionLabel1.frame = v;
        
        if (_testMode != tmTestOnTime){
            _questionMark.hidden = NO;
            _timerView.hidden = YES;
            
//            int y;
//            int height;
//            if (_questionLabel1.frame.size.height>0){
//                y = _questionLabel1.frame.origin.y;
//                height = _questionLabel1.frame.size.height;
//            } else {
//                y = _questionLabel2.frame.origin.y;
//                height = _questionLabel2.frame.size.height;
//            }
//            
//            CGRect p = _questionMark.frame;
//            p.origin.x = _questionLabel1.frame.origin.x + _questionLabel1.frame.size.width;
//            p.origin.y = y - ((_questionMark.frame.size.height - height)/2);
            //_questionMark.frame=p;
//            s.origin.x = _questionMark.frame.origin.x + _questionMark.frame.size.width;
        }else{
            _questionMark.hidden = YES;
            _timerView.hidden = NO;
            
//            CGRect p = _timerView.frame;
//            p.origin.x = _questionLabel1.frame.origin.x + _questionLabel1.frame.size.width;
//            
//            int y;
//            int height;
//            if (_questionLabel1.frame.size.height>0){
//                y = _questionLabel1.frame.origin.y;
//                height = _questionLabel1.frame.size.height;
//            } else {
//                y = _questionLabel2.frame.origin.y;
//                height = _questionLabel2.frame.size.height;
//            }
            
//            p.origin.y = y - ((_timerView.frame.size.height - height)/2);
            //_timerView.frame=p;
//            s.origin.x = _timerView.frame.origin.x + _timerView.frame.size.width;
            [_timerView startTimer:[_data.time_limit intValue]];
        }
        //_questionLabel2.frame=s;

//        [_questionLabel1 setNeedsDisplay];
        [_questionLabel1 setHidden:NO];
//        [_questionLabel2 setNeedsDisplay];
        [_questionLabel2 setHidden:NO];
        
//        [_timerView setNeedsDisplay];
//        [_questionMark setNeedsDisplay];

//        [self realignView];
        
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
    
}

-(void)prepareTest{
    answered = 0;
    pmqAppDelegate *d = (pmqAppDelegate*)[[UIApplication sharedApplication]delegate];
    
    switch (_testMode) {
        case tmPractice:
        case tmTestOnTime:
            [self prepareQuestions:[[_data.relationship_question allObjects] mutableCopy] firstFail:NO];
            break;
            
        case tmPracticeFails:
            [self prepareQuestions:[[_data.relationship_question allObjects] mutableCopy]firstFail:YES];
            break;
            
        case tmPracticeOverAllFail:{
            Tests *te;
            for (Lessons *l in [d.data.lessons fetchedObjects]) {
                if ([l.order intValue] == 16959){
                    te =l.relationship_test;
                    break;
                }
            }
            self.data = te;
            
            [self prepareQuestions:[[_data.relationship_question allObjects] mutableCopy] firstFail:YES];
            break;
        }
            
        default:
            break;
    }
}

-(void)markCorrect{
    [UIView beginAnimations:@"correct" context:nil];
    
    if (time_to_show_answer>1) {
        [_labelAnswer setTextColor:[UIColor redColor]];
    }
    
    [UIView setAnimationDuration:time_to_show_answer];
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
}

-(void)prepareNextQuestion{
    if (answered<[_data.test_length intValue]){
        [UIView beginAnimations:@"next" context:nil];
        
        [_labelAnswer setHidden:YES];
        for (UIButton *b in self.answerButtons) {
            b.backgroundColor = [UIColor lightGrayColor];
        }
        
        [self loadFromLastTest];
        
        [UIView setAnimationDuration:0.1];
        [UIView setAnimationDelegate:self];
        [UIView commitAnimations];
//        self performSelector:<#(SEL)#> withObject:<#(id)#> afterDelay:<#(NSTimeInterval)#>
    }else{
        [self makeResult];
    }
    [_timeOutImage setHidden:YES];
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
    if ([(NSString*)anim isEqualToString:@"answer"]){
        [self performSelector:@selector(markCorrect) withObject:nil afterDelay:time_to_show_answer / 5];
    } else if ( [(NSString*)anim isEqualToString:@"correct"] ){
        [_labelAnswer setTextColor:[UIColor whiteColor]];
        [self performSelector:@selector(prepareNextQuestion) withObject:nil afterDelay:time_to_show_answer];
    }
    [self realignView];
}

-(void)animateAnswer:(UIButton*)button{
    
    [_marks reloadData];
    
//    [UIView beginAnimations:@"answer" context:nil];
//    [UIView setAnimationDuration:0.1];
//    [UIView setAnimationDelegate:self];
    
    if (button.tag==1){
        button.backgroundColor = [UIColor greenColor];
    } else {
        button.backgroundColor = [UIColor redColor];
    }
    
    for (UIButton *b in self.answerButtons) {
        if (b.tag==1){
            b.backgroundColor = [UIColor greenColor];
            _labelAnswer.text = b.currentTitle;
            [_labelAnswer sizeToFit];
            if (_labelAnswer.frame.origin.x <_questionLabel2.frame.origin.x) {
                CGRect p = _questionLabel2.frame;
                p.origin.x = _labelAnswer.frame.origin.x + _labelAnswer.frame.size.width;
                _questionLabel2.frame = p;
            }
        }
        [b setEnabled:NO];
        if ([b isEqual:button] || b.tag==1) {
            [b setHidden:NO];
        } else [b setHidden:YES];
    }
    
    if (_testMode !=  tmTestOnTime) {
        [_questionMark setHidden:YES];
        [_labelAnswer setHidden:NO];
    }else{
        [_timerView setHidden:YES];
        [_labelAnswer setHidden:NO];
    }
    
//    [UIView commitAnimations];
    [self animationDidStop:@"answer" finished:YES];
}

- (IBAction)answerButtonAction:(UIButton *)sender {
    [_timerView invalidateTimer];
    
    if (_testMode!=tmTestOnTime){
        _labelAnswer.frame = _questionMark.frame;
    } else
        _labelAnswer.frame = _timerView.frame;
    
    //    if (_testMode != tmTest) {
    Questions *q = [_questions objectAtIndex:answered];
    if (sender){
        q.last_answer = [NSNumber numberWithBool:sender.tag==1];
    } else
        q.last_answer = [NSNumber numberWithBool:NO];
    float inTime = _timerView.timeToCount*(_timerView.percent/100);
    if (inTime==0) inTime = _timerView.timeToCount;
    q.time_of_answer = [NSNumber numberWithFloat:inTime];
    //    }
    answered++;
    if ([q.last_answer boolValue]) {
        time_to_show_answer = 1;
    } else {
        time_to_show_answer = 3;
    }
    
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
    
    NSArray *rq = [r.relationship_questions allObjects];
    for (Questions *q in rq) {
        [r removeRelationship_questionsObject:q];
    }
    float total_time = 0;
    int bad_answer = 0;
    for (int i=0; i<[_questions count]; i++) {
        Questions *q = [_questions objectAtIndex:i];
        total_time += [q.time_of_answer floatValue];
        if ([q.last_answer integerValue]==0){
            bad_answer++;
        }
        [r addRelationship_questionsObject:q];
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
    
    [_labelAnswer setHidden:YES];
    [_questionLabel1 setHidden:YES];
    [_questionLabel2 setHidden:YES];
    [_questionMark setHidden:YES];
    [_timerView setHidden:YES];
    
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
    _timerView.percent = 0;
    [self answerButtonAction:nil];
}


@end
