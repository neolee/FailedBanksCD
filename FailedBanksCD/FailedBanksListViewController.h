//
//  FailedBanksListViewController.h
//  FailedBanksCD
//
//  Created by Neo Lee on 9/16/11.
//  Copyright (c) 2011 Home. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FailedBanksListViewController : UITableViewController <NSFetchedResultsControllerDelegate> {
    NSManagedObjectContext *_context;    
    NSFetchedResultsController *_fetchedResultsController;
}

@property (nonatomic, retain) NSManagedObjectContext *context;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@end
