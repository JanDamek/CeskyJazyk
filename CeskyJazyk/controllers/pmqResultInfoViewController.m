//
//  pmqResultInfoViewController.m
//  Matematika
//
//  Created by Jan Damek on 05.06.14.
//  Copyright (c) 2014 PMQ-Software. All rights reserved.
//

#import "pmqResultInfoViewController.h"
#import "Tests.h"
#import "Lessons.h"
#import "Questions.h"
#import "pmqQuestions.h"
#import "pmqResultQuestionCell.h"
#import "pmqTestingViewController.h"
#import "pmqResultViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface pmqResultInfoViewController (){
    NSMutableArray *questions;
    NSMutableArray *pmqQ;
}

@property (weak, nonatomic) IBOutlet UIButton *btnAllResults;
@property (weak, nonatomic) IBOutlet UIButton *btnPracticeErrors;

@property (weak, nonatomic) IBOutlet UILabel *lblDatum;
@property (weak, nonatomic) IBOutlet UILabel *lblLekce;
@property (weak, nonatomic) IBOutlet UILabel *lblPocetChyb;
@property (weak, nonatomic) IBOutlet UILabel *lblCelkovyCas;

@property (weak, nonatomic) IBOutlet UICollectionView *colPriklady;

@end

@implementation pmqResultInfoViewController

@synthesize dataResult = _dataResult;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    
    //    self.btnAllResults.layer.cornerRadius = 10;
    //    self.btnPracticeErrors.layer.cornerRadius = 10;
    
    [self.btnPracticeErrors setHidden:([_dataResult.bad_answers intValue]==0)];
    
    id parent = [self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-2];
    [self.btnAllResults setHidden:[parent isKindOfClass:[pmqResultViewController class]]];
    
    [self setViews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setViews{
    self.lblLekce.text = _dataResult.relationship_test.relationship_lesson.name;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd.MM.yyyy HH:mm"];
    NSString *convertedString = [dateFormatter stringFromDate:_dataResult.date];
    
    self.lblDatum.text = convertedString;
    self.lblPocetChyb.text = [NSString stringWithFormat:NSLocalizedString(@"%i (pocet prikladu %i)",nil), [_dataResult.bad_answers intValue], [_dataResult.relationship_test.test_length intValue]];
    
    [dateFormatter setDateFormat:@"hh:mm"];
    int min = [_dataResult.total_time floatValue] / 60;
    int sec = [_dataResult.total_time floatValue] - (min*60);
    self.lblCelkovyCas.text = [NSString stringWithFormat:@"%02i:%02i", min, sec];
    
    [self.colPriklady reloadData];
    
}

#pragma mark - propertys

-(void)setDataResult:(Results *)dataResult{
    _dataResult = dataResult;
    pmqQ = [[NSMutableArray alloc] initWithCapacity:12];
    questions = [[NSMutableArray alloc] initWithCapacity:12];
    
    for (int i=0;i<12;i++) {
        pmqQuestions *pmq = [[pmqQuestions alloc] init];
        switch (i){
            case 0:
                pmq.q = _dataResult.relationship_questions1;
                break;
            case 1:
                pmq.q = _dataResult.relationship_questions2;
                break;
            case 2:
                pmq.q = _dataResult.relationship_questions3;
                break;
            case 3:
                pmq.q = _dataResult.relationship_questions4;
                break;
            case 4:
                pmq.q = _dataResult.relationship_questions5;
                break;
            case 5:
                pmq.q = _dataResult.relationship_questions6;
                break;
            case 6:
                pmq.q = _dataResult.relationship_questions7;
                break;
            case 7:
                pmq.q = _dataResult.relationship_questions8;
                break;
            case 8:
                pmq.q = _dataResult.relationship_questions9;
                break;
            case 9:
                pmq.q = _dataResult.relationship_questions10;
                break;
            case 10:
                pmq.q = _dataResult.relationship_questions11;
                break;
            case 11:
                pmq.q = _dataResult.relationship_questions12;
                break;
        }
        if (pmq.q){
            [questions addObject:pmq.q];
        }
        [pmqQ addObject:pmq];
    }
    
    [self.btnPracticeErrors setHidden:([_dataResult.bad_answers intValue]==0)];
}

#pragma mark - Navigation

- (IBAction)backBtnAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [questions count];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

#define Rgb2UIColor(r, g, b)  [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    pmqResultQuestionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"resultCell" forIndexPath:indexPath];
    
    //    NSInteger i = indexPath.row - [questions count];
    //    int ii = (int)i;
    //    NSInteger index= abs( ii ) - 1;
    NSInteger index = indexPath.row;
    
    Questions *q = [questions objectAtIndex:index];
    
    pmqQuestions *pmq = [pmqQ objectAtIndex:index];
    
    if ([q.time_of_answer intValue] == [_dataResult.relationship_test.time_limit intValue]){
        [cell.timeOut setHidden:NO];
    } else [cell.timeOut setHidden:YES];
    
    bool answer=NO;
    
    switch (index){
        case 0:
            answer = [_dataResult.answer1 boolValue];
            break;
        case 1:
            answer = [_dataResult.answer2 boolValue];
            break;
        case 2:
            answer = [_dataResult.answer3 boolValue];
            break;
        case 3:
            answer = [_dataResult.answer4 boolValue];
            break;
        case 4:
            answer = [_dataResult.answer5 boolValue];
            break;
        case 5:
            answer = [_dataResult.answer6 boolValue];
            break;
        case 6:
            answer = [_dataResult.answer7 boolValue];
            break;
        case 7:
            answer = [_dataResult.answer8 boolValue];
            break;
        case 8:
            answer = [_dataResult.answer9 boolValue];
            break;
        case 9:
            answer = [_dataResult.answer10 boolValue];
            break;
        case 10:
            answer = [_dataResult.answer11 boolValue];
            break;
        case 11:
            answer = [_dataResult.answer12 boolValue];
            break;
    }
    
    UIColor *answerColor;
    if (answer) {
        answerColor = [UIColor whiteColor];
    } else answerColor = [UIColor redColor];
    
    CGRect r = cell.progress.frame;
    r.size.height +=2;
    cell.progress.frame = r;
    //    cell.progress.layer.cornerRadius = 10;
    
    cell.question.textColor = answerColor;
    if ([q.last_answer boolValue]) {
        cell.progress.progressTintColor = Rgb2UIColor(0xd8, 0xdc, 0x41);
    }else {
        cell.progress.progressTintColor = Rgb2UIColor(0xf1, 0x63, 0x65);
    }
    cell.time.tintColor = answerColor;
    
    cell.question.text = pmq.resultQuestion;
    
    [cell.progress setTransform:CGAffineTransformMakeScale(1.0, 3.0)];
    cell.progress.progress = [q.time_of_answer floatValue] / [_dataResult.relationship_test.time_limit floatValue];
    
    cell.time.text = [NSString stringWithFormat:@"%.2f s", [q.time_of_answer floatValue] ];
    
    return cell;
}


// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"testErrors"]) {
        pmqTestingViewController *t = [segue destinationViewController];
        t.data = self.dataResult.relationship_test;
        t.testMode = tmPracticeFails;
    }
}


@end
