//
//  pmqDetailViewController.m
//  Matematika
//
//  Created by Jan Damek on 22.05.14.
//  Copyright (c) 2014 PMQ-Software. All rights reserved.
//

#import "pmqDetailLesonsViewController.h"
#import "Lessons.h"
#import "Intros.h"
#import "Tests.h"
#import "Questions.h"
#import "Results.h"
#import "Pages.h"
#import "pmqQuestions.h"
#import "pmqIntrosViewController.h"
#import "pmqTestingViewController.h"

@interface pmqDetailLesonsViewController (){
    bool _isInit;
}

@property (weak, nonatomic) IBOutlet UIButton *zkouseni_na_cas;
@property (weak, nonatomic) IBOutlet UIButton *procvicovani;
@property (weak, nonatomic) IBOutlet UIButton *jak_na_to;

- (void)configureView;
@end

@implementation pmqDetailLesonsViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)backBtnAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem) {
        if ([self.detailItem isKindOfClass:[Lessons class]]){
            Lessons *l = (Lessons*)self.detailItem;
            self.navigationItem.title = l.name;
            Intros *i = (Intros*)[[l.relationship_intro objectEnumerator]nextObject];
            NSUInteger p = [i.relationship_pages count];
            if (p==1){
                Pages *pp = [[i.relationship_pages objectEnumerator]nextObject];
                if (!pp.content) {
                    p=0;
                }
            }
            [self.jak_na_to setHidden:(p==0)];
        }
    }
}

- (void)viewDidLoad
{
    _isInit = true;
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                             forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    
    [self configureView];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (_isInit){
        [self.masterPopoverController presentPopoverFromBarButtonItem:self.navigationItem.leftBarButtonItem permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
        _isInit = false;
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Lekce", @"Lekce");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

#pragma mark - segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    Lessons *l = (Lessons*)self.detailItem;
    Intros *object = (Intros*)[[l.relationship_intro objectEnumerator]nextObject];

    if ([[segue identifier] isEqualToString:@"jnt_detail"]) {
        ((pmqIntrosViewController*)[segue destinationViewController]).data = object;
    }else if ([[segue identifier] isEqualToString:@"p_detail"]) {
        ((pmqTestingViewController*)[segue destinationViewController]).data = l.relationship_test;
        ((pmqTestingViewController*)[segue destinationViewController]).testMode = tmPractice;
    }if ([[segue identifier] isEqualToString:@"znc_detail"]) {
        ((pmqTestingViewController*)[segue destinationViewController]).data = l.relationship_test;
        ((pmqTestingViewController*)[segue destinationViewController]).testMode = tmTestOnTime;
    }

}

-(void)performProcvicovani{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
    
    Lessons *l = (Lessons*)self.detailItem;

    pmqTestingViewController *t = [self.storyboard instantiateViewControllerWithIdentifier:@"procvicovani"];
   t.data = l.relationship_test;
   t.testMode = tmPractice;
   [self.navigationController pushViewController:t animated:YES];
}

@end
