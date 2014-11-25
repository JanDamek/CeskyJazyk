//
//  pmqResultViewController.m
//  Cesky Jazyk
//
//  Created by Jan Damek on 01.06.14.
//  Copyright (c) 2014 PMQ-Software. All rights reserved.
//

#import "pmqResultViewController.h"
#import "pmqResultCell.h"
#import "pmqAppDelegate.h"
#import "pmqResultInfoViewController.h"
#import "pmqTestingViewController.h"

@interface pmqResultViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, readonly) NSFetchedResultsController *results;

@end

@implementation pmqResultViewController

@synthesize tableView = _tableView;
@synthesize results = _results;

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
    
    _tableView.backgroundColor = [UIColor clearColor];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - property getters and setters

-(NSFetchedResultsController *)results{
    if (!_results) {
        pmqAppDelegate *d = (pmqAppDelegate*)[[UIApplication sharedApplication]delegate];
        _results = d.data.results;
    }
    return _results;
}

#pragma mark - UITableViewDelegate, UITableViewDatasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.results sections][section];
    return [sectionInfo numberOfObjects];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    pmqResultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ResultCell" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor clearColor];
    
    UIView *selectionView = [[UIView alloc]initWithFrame:cell.bounds];
    [selectionView setBackgroundColor:[UIColor clearColor]];
    UIImageView *i = [[UIImageView alloc] initWithFrame:selectionView.bounds];
    i.image = [UIImage imageNamed:@"list_hover.9.png"];
    [selectionView addSubview:i];
    cell.selectedBackgroundView = selectionView;
    
    cell.rowNumber = indexPath.row;
    
    Results *r = [self.results objectAtIndexPath:indexPath];
    
    cell.lessonName.text = r.relationship_test.relationship_lesson.name;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd.MM.yyyy HH:mm"];
    NSString *convertedString = [dateFormatter stringFromDate:r.date];
    
    cell.dateOfTest.text = convertedString;
    
    cell.testOk.text = [NSString stringWithFormat:@"%i", [r.bad_answers intValue]];
    
    cell.testCount.text = [NSString stringWithFormat:@"%i", [r.relationship_test.test_length intValue]];
    
    int min = [r.total_time floatValue] / 60;
    int sec = [r.total_time floatValue] - (min*60);
    cell.testTime.text = [NSString stringWithFormat:@"%02i:%02i", min, sec];
    
    if ([r.bad_answers intValue]>0){
        [cell.btnTest setHidden:NO];
        [cell.btnTest setTag:indexPath.row];
    } else
        [cell.btnTest setHidden:YES];
    
    return cell;
}

- (IBAction)backBtnAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"resultInfo"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        Results *object = [[self results] objectAtIndexPath:indexPath];
        [(pmqResultInfoViewController*)[segue destinationViewController] setDataResult:object];
    }
    else
        if ([[segue identifier] isEqualToString:@"procvicovaniChyb"]) {
            UIButton *b = (UIButton*)sender;
            //            id cell;
            //            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            //                cell = b.superview.superview.superview;
            //            }else{
            //                cell = b.superview.superview;//.superview;
            //            }
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:b.tag inSection:0];
            
            Results *object = [[self results] objectAtIndexPath:indexPath];
            [(pmqTestingViewController*)[segue destinationViewController] setData:object.relationship_test];
            [(pmqTestingViewController*)[segue destinationViewController] setTestMode:tmPracticeFails];
        }
}

@end
