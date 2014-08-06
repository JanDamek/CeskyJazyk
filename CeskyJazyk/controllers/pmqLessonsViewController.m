//
//  pmqMasterViewController.m
//  Matematika
//
//  Created by Jan Damek on 22.05.14.
//  Copyright (c) 2014 PMQ-Software. All rights reserved.
//

#import "pmqLessonsViewController.h"
#import "pmqDetailLesonsViewController.h"
#import "Lessons.h"
#import "pmqLessonTableViewCell.h"
#import "pmqResultViewController.h"
#import "pmqTestingViewController.h"
#import "pmqAppDelegate.h"
#import <QuartzCore/QuartzCore.h>

@interface pmqLessonsViewController (){
    bool isReady;
}

@property (weak, nonatomic) IBOutlet UIButton *btnVysledkyTestu;
@property (weak, nonatomic) IBOutlet UIButton *btnProcvicovaniChyb;

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end

@implementation pmqLessonsViewController

@synthesize tableView = _tableView;

- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        //        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    isReady = NO;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    
//    CGRect p = self.navigationController.navigationBar.bounds;
//    UIImageView *v = [[UIImageView alloc] initWithFrame:p];
//    v.image = [UIImage imageNamed:@"title_hp.png"];
//    v.contentMode = UIViewContentModeScaleAspectFit;
//    self.navigationItem.titleView = v;
    
//    self.btnProcvicovaniChyb.layer.cornerRadius = 7;
//    self.btnVysledkyTestu.layer.cornerRadius = 7;
    
    self.detailViewController = (pmqDetailLesonsViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:[[prefs objectForKey:@"last"] intValue] inSection:0];
    if (indexPath.row<[self tableView:self.tableView numberOfRowsInSection:indexPath.section]){
        [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
        
        [self doSelectRow:indexPath];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    isReady = YES;
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects]-1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    pmqLessonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        NSError *error = nil;
        if (![context save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

-(void)doSelectRow:(NSIndexPath*)indexPath
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setObject:[NSNumber numberWithInteger:indexPath.row] forKey:@"last"];
        [prefs synchronize];
        
        Lessons *object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        if ([object.demo intValue]==0){
            if (isReady){
                [self performSegueWithIdentifier:@"nakup_popover" sender:self];
            }else {
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
                [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
                [self doSelectRow:indexPath];
            }
        } else {
            self.detailViewController.detailItem = object;
        }
    }else if (isReady) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setObject:[NSNumber numberWithInteger:indexPath.row] forKey:@"last"];
        [prefs synchronize];
        
        Lessons *object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        if ([object.demo intValue]==0){
            if (isReady){
                [self performSegueWithIdentifier:@"nakup_popover" sender:self];
            }else {
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
                [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
                [self doSelectRow:indexPath];
            }
        }else{
            pmqDetailLesonsViewController *d = [self.storyboard instantiateViewControllerWithIdentifier:@"detailView"];
            [d setDetailItem:object];
            [self.navigationController pushViewController:d animated:YES];
        }
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self doSelectRow:indexPath];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [self.detailViewController.navigationController popToRootViewControllerAnimated:NO];
    
    if ([[segue identifier] isEqualToString:@"procvicovani"]) {
        pmqTestingViewController *t = [segue destinationViewController];
        t.masterPopoverController = self.detailViewController.masterPopoverController;

//        pmqAppDelegate *d = (pmqAppDelegate*)[[UIApplication sharedApplication]delegate];
//        Tests *da = [d.data newTests];
//        da.relationship_lesson = nil;
//        da.test_length = [NSNumber numberWithInt:12];
//        da.time_limit = [NSNumber numberWithInt:10];
//        t.data = da;
        
        t.testMode = tmPracticeOverAllFail;
        
    } else if ([[segue identifier] isEqualToString:@"all_res"]) {
        pmqResultViewController *r = [segue destinationViewController];
        r.masterPopoverController = self.detailViewController.masterPopoverController;
    }
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    pmqAppDelegate *d = (pmqAppDelegate*)[[UIApplication sharedApplication]delegate];
    d.data.lessons.delegate = self;
    self.fetchedResultsController = d.data.lessons;
    
    return _fetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

- (void)configureCell:(pmqLessonTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Lessons *object = (Lessons*)[self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor clearColor];
    
    UIView *selectionView = [[UIView alloc]initWithFrame:cell.bounds];
    [selectionView setBackgroundColor:[UIColor clearColor]];
    UIImageView *i = [[UIImageView alloc] initWithFrame:selectionView.bounds];
    if (indexPath.row % 2) {
        i.image = [UIImage imageNamed:@"bg_list2_320_even"];
    } else {
        i.image = [UIImage imageNamed:@"bg_list2_320_odd"];
    }
    [selectionView addSubview:i];
    cell.selectedBackgroundView = selectionView;
    [i sizeToFit];
    
    cell.lessonName.text = object.name;
    [cell.lessonName sizeToFit];
    
    cell.rowNumber = indexPath.row;
    
    if ([object.demo intValue]==1){
        [cell setRating:[object.rating intValue]];
    }else{
        [cell setLock];
    }
}

@end
