//
//  pmqPurchase.h
//  Matematika
//
//  Created by Jan Damek on 26.05.14.
//  Copyright (c) 2014 PMQ-Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import "Lessons.h"

@interface pmqPurchase : UITableViewController <SKProductsRequestDelegate, SKPaymentTransactionObserver, UITableViewDataSource, UITableViewDelegate, UITableViewDataSource>

@end
