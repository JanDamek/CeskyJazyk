//
//  pmqData.m
//  Matematika
//
//  Created by Jan Damek on 22.05.14.
//  Copyright (c) 2014 PMQ-Software. All rights reserved.
//

#import "pmqData.h"
#import "pmqAppDelegate.h"
#import "pmqParseXMLToData.h"

@interface pmqData()

@property (strong, nonatomic, getter = getManagedObjectContext) NSManagedObjectContext *managedObjectContext;
-(void)saveContext:(NSManagedObjectContext*)context;

@end

@implementation pmqData

@synthesize managedObjectContext = _managedObjectContext;

@synthesize lessons = _lessons;
@synthesize pages = _pages;
@synthesize results = _results;
@synthesize intros = _intros;
@synthesize tests = _tests;
@synthesize questions = _questions;

static NSString *lessonsCache = @"lessonsCache";
static NSString *pagesCache = @"pagesCache";
static NSString *resultsCache = @"resultsCache";
static NSString *introsCache = @"introsCache";
static NSString *testsCache = @"testsCache";
static NSString *questionsCache = @"questionsCache";

#pragma mark - global definition

-(void)testParseXMLGameData{
    if ([self.lessons.fetchedObjects count]<=5){
        [[[pmqParseXMLToData alloc] init] doParse];
    }
}

-(NSManagedObjectContext *)getManagedObjectContext{
    if (!_managedObjectContext){
        pmqAppDelegate *d = (pmqAppDelegate*)[[UIApplication sharedApplication] delegate];
        _managedObjectContext = d.managedObjectContext;
    }
    return _managedObjectContext;
}

-(void)saveContext:(NSManagedObjectContext*)context{
    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

#pragma mark - Lessons definition

-(NSFetchedResultsController *)getLessons{
    if (!_lessons){
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        // Edit the entity name as appropriate.
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Lessons" inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        
        // Set the batch size to a suitable number.
        [fetchRequest setFetchBatchSize:20];
        
        // Edit the sort key as appropriate.
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"order" ascending:YES];
        NSArray *sortDescriptors = @[sortDescriptor];
        
        [fetchRequest setSortDescriptors:sortDescriptors];
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:lessonsCache];
        //aFetchedResultsController.delegate = self;
        _lessons = aFetchedResultsController;
        
        NSError *error = nil;
        if (![self.lessons performFetch:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
    
    return _lessons;
}

-(Lessons*)newLessons{
    NSManagedObjectContext *context = [self.lessons managedObjectContext];
    NSEntityDescription *entity = [[self.lessons fetchRequest] entity];
    Lessons *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
    newManagedObject.lesson_id = 0;
    newManagedObject.name = @"new entry";
    return newManagedObject;
}

-(void)saveLessons{
    NSManagedObjectContext *context = [self.lessons managedObjectContext];
    
    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

-(Lessons*)findLessonId:(int)lesson_id{
    [NSFetchedResultsController deleteCacheWithName:lessonsCache];
    [self.lessons.fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"lesson_id==%i", lesson_id]];
    [self.lessons performFetch:nil];
    id <NSFetchedResultsSectionInfo> fc = self.lessons.sections[0];
    for (Lessons *c in [fc objects]) {
        if ([c.lesson_id isEqualToNumber:[NSNumber numberWithInt:lesson_id]]){
            return c;
        }
    }
    
    return [self newLessons];
}

#pragma mark - Pages definition

-(NSFetchedResultsController *)getPages{
    if (!_pages){
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        // Edit the entity name as appropriate.
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Pages" inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        
        // Set the batch size to a suitable number.
        [fetchRequest setFetchBatchSize:20];
        
        // Edit the sort key as appropriate.
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"order" ascending:NO];
        NSArray *sortDescriptors = @[sortDescriptor];
        
        [fetchRequest setSortDescriptors:sortDescriptors];
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:pagesCache];
        //aFetchedResultsController.delegate = self;
        _pages = aFetchedResultsController;
        
        NSError *error = nil;
        if (![self.pages performFetch:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
    
    return _pages;
}

-(Pages*)newPages{
    NSManagedObjectContext *context = [self.pages managedObjectContext];
    NSEntityDescription *entity = [[self.pages fetchRequest] entity];
    Pages *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
    return newManagedObject;
}

-(void)savePages{
    NSManagedObjectContext *context = [self.pages managedObjectContext];
    
    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

#pragma mark - Results definition

-(NSFetchedResultsController *)getResults{
    if (!_results){
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        // Edit the entity name as appropriate.
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Results" inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        
        // Set the batch size to a suitable number.
        [fetchRequest setFetchBatchSize:20];
        
        // Edit the sort key as appropriate.
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
        NSArray *sortDescriptors = @[sortDescriptor];
        
        [fetchRequest setSortDescriptors:sortDescriptors];
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:resultsCache];
        //aFetchedResultsController.delegate = self;
        _results = aFetchedResultsController;
        
        NSError *error = nil;
        if (![self.results performFetch:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
    
    return _results;
}

-(Results*)newResults{
    NSManagedObjectContext *context = [self.results managedObjectContext];
    NSEntityDescription *entity = [[self.results fetchRequest] entity];
    Results *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
    return newManagedObject;
}

-(void)saveResults{
    NSManagedObjectContext *context = [self.results managedObjectContext];
    
    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

#pragma mark - Intros definition

-(NSFetchedResultsController *)getIntros{
    if (!_intros){
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        // Edit the entity name as appropriate.
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Intros" inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        
        // Set the batch size to a suitable number.
        [fetchRequest setFetchBatchSize:20];
        
        // Edit the sort key as appropriate.
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"order" ascending:NO];
        NSArray *sortDescriptors = @[sortDescriptor];
        
        [fetchRequest setSortDescriptors:sortDescriptors];
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:introsCache];
        //aFetchedResultsController.delegate = self;
        _intros = aFetchedResultsController;
        
        NSError *error = nil;
        if (![self.intros performFetch:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
    
    return _intros;
}

-(Intros*)newIntros{
    NSManagedObjectContext *context = [self.intros managedObjectContext];
    NSEntityDescription *entity = [[self.intros fetchRequest] entity];
    Intros *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
    return newManagedObject;
}

-(void)saveIntros{
    NSManagedObjectContext *context = [self.intros managedObjectContext];
    
    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

#pragma mark - Tests definition

-(NSFetchedResultsController *)getTest{
    if (!_tests){
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        // Edit the entity name as appropriate.
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Tests" inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        
        // Set the batch size to a suitable number.
        [fetchRequest setFetchBatchSize:20];
        
        // Edit the sort key as appropriate.
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"order" ascending:NO];
        NSArray *sortDescriptors = @[sortDescriptor];
        
        [fetchRequest setSortDescriptors:sortDescriptors];
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:testsCache];
        //aFetchedResultsController.delegate = self;
        _tests = aFetchedResultsController;
        
        NSError *error = nil;
        if (![self.tests performFetch:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
    
    return _tests;
}

-(Tests*)newTests{
    NSManagedObjectContext *context = [self.tests managedObjectContext];
    NSEntityDescription *entity = [[self.tests fetchRequest] entity];
    Tests *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
    return newManagedObject;
}

-(void)saveTests{
    NSManagedObjectContext *context = [self.tests managedObjectContext];
    
    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

#pragma mark - Questions definition

-(NSFetchedResultsController *)getQuestions{
    if (!_questions){
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        // Edit the entity name as appropriate.
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Questions" inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        
        // Set the batch size to a suitable number.
        [fetchRequest setFetchBatchSize:20];
        
        // Edit the sort key as appropriate.
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"last_answer" ascending:YES];
        NSArray *sortDescriptors = @[sortDescriptor];
        
        [fetchRequest setSortDescriptors:sortDescriptors];
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:questionsCache];
        //aFetchedResultsController.delegate = self;
        _questions = aFetchedResultsController;
        
        NSError *error = nil;
        if (![self.questions performFetch:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
    
    return _questions;
}

-(Questions*)newQuestions{
    NSManagedObjectContext *context = [self.questions managedObjectContext];
    NSEntityDescription *entity = [[self.questions fetchRequest] entity];
    Questions *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
    return newManagedObject;
}

-(void)saveQuestions{
    NSManagedObjectContext *context = [self.questions managedObjectContext];
    
    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

@end
