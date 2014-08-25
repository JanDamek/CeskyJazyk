//
//  pmqPurchase.m
//  Matematika
//
//  Created by Jan Damek on 26.05.14.
//  Copyright (c) 2014 PMQ-Software. All rights reserved.
//

#import "pmqPurchase.h"
#import "pmqAppDelegate.h"

@interface pmqPurchase(){
    NSArray *products;
    SKProductsRequest *productsRequest;
}

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *ani;

@end

@implementation pmqPurchase

@synthesize ani;

#define kProductIdentifier @"com.pmqsoftware.ceskyjazyk"

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.opaque = NO;
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_overlay.png"]];

       
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    [self.ani startAnimating];
    
    if ([SKPaymentQueue canMakePayments]) {
        NSLog(@"Parental-controls are disabled");
        
        productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:kProductIdentifier]];
        productsRequest.delegate = self;
        [productsRequest start];
    } else {
        NSLog(@"Parental-controls are enabled");
        //com.companion.onemonth ;
    }
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    productsRequest.delegate = nil;
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSUInteger i = [products count];
    if (i==0) i++;
    return i;
}

- (IBAction)backBtnAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SKProduct *p = (SKProduct*)[products objectAtIndex:indexPath.row];
    [self purchase:p];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"nakupCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    if ([products count]==0) {
        cell.textLabel.text = NSLocalizedString(@"no InApp purchase items", nil);
        cell.detailTextLabel.text = @"";
    }else{
    SKProduct *p = (SKProduct*)[products objectAtIndex:indexPath.row];
        
        cell.backgroundColor = [UIColor clearColor];
    
    cell.textLabel.text = p.localizedTitle;
    cell.detailTextLabel.text = p.localizedDescription;
    }
    return cell;
}

#pragma mark - SKproduct - InApp purchase

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    SKProduct *validProduct = nil;
    NSUInteger count = [response.products count];
    if(count > 0){
        validProduct = [response.products objectAtIndex:0];
        NSLog(@"Products Available!");
        products = response.products;
        [self.tableView reloadData];
        //[self purchase:validProduct];
    }
    else if(!validProduct){
        NSLog(@"No products available");
        //this is called if your product id is not valid, this shouldn't be called unless that happens.
    }
    [self.ani stopAnimating];
}

- (IBAction)purchase:(SKProduct *)product{
    SKPayment *payment = [SKPayment paymentWithProduct:product];
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

- (IBAction) restore{
    //this is called when the user restores purchases, you should hook this up to a button
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

- (void) paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    NSLog(@"received restored transactions: %lu", (unsigned long)queue.transactions.count);
    for (SKPaymentTransaction *transaction in queue.transactions)
    {
        if(SKPaymentTransactionStateRestored){
            NSLog(@"Transaction state -> Restored");
            //called when the user successfully restores a purchase
           [self doComplet];
            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            break;
        }
        
    }
    
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions{
    for(SKPaymentTransaction *transaction in transactions){
        switch (transaction.transactionState){
            case SKPaymentTransactionStatePurchasing: NSLog(@"Transaction state -> Purchasing");
                //called when the user is in the process of purchasing, do not add any of your own code here.
                break;
            case SKPaymentTransactionStatePurchased:
                //this is called when the user has successfully purchased the package (Cha-Ching!)
                [self doComplet]; //you can add your code for what you want to happen when the user buys the purchase here, for this tutorial we use removing ads
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                NSLog(@"Transaction state -> Purchased");
                break;
            case SKPaymentTransactionStateRestored:
                NSLog(@"Transaction state -> Restored");
                //add the same code as you did from SKPaymentTransactionStatePurchased here
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                //called when the transaction does not finnish
                if(transaction.error.code != SKErrorPaymentCancelled){
                    NSLog(@"Transaction state -> Cancelled");
                    //the user cancelled the payment ;(
                }
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            case SKPaymentTransactionStateDeferred:
                //called when the transaction does not finnish
                if(transaction.error.code != SKErrorPaymentNotAllowed){
                    NSLog(@"Transaction state -> NotAllowed");
                    //the user cancelled the payment ;(
                }
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
        }
    }
}

-(void)doComplet{
    //TODO: odblokovani nakupu
    pmqAppDelegate *d = (pmqAppDelegate*)[[UIApplication sharedApplication]delegate];
    [d doPurchaseComplet];
}

@end
