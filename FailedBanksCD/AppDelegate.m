//
//  AppDelegate.m
//  FailedBanksCD
//
//  Created by Neo Lee on 9/16/11.
//  Copyright (c) 2011 Home. All rights reserved.
//

#import "AppDelegate.h"
#import "FailedBankInfo.h"
#import "FailedBankDetails.h"
#import "FailedBanksListViewController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize navController = _navController;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;

- (void)testCoreDataPrimitive {
    NSManagedObjectContext *context = [self managedObjectContext];
    NSManagedObject *failedBankInfo = [NSEntityDescription
                                       insertNewObjectForEntityForName:@"FailedBankInfo" 
                                       inManagedObjectContext:context];
    [failedBankInfo setValue:@"Test Bank" forKey:@"name"];
    [failedBankInfo setValue:@"Testville" forKey:@"city"];
    [failedBankInfo setValue:@"Testland" forKey:@"state"];
    NSManagedObject *failedBankDetails = [NSEntityDescription
                                          insertNewObjectForEntityForName:@"FailedBankDetails" 
                                          inManagedObjectContext:context];
    [failedBankDetails setValue:[NSDate date] forKey:@"closeDate"];
    [failedBankDetails setValue:[NSDate date] forKey:@"updatedDate"];
    [failedBankDetails setValue:[NSNumber numberWithInt:12345] forKey:@"zip"];
    [failedBankDetails setValue:failedBankInfo forKey:@"info"];
    [failedBankInfo setValue:failedBankDetails forKey:@"details"];
    NSError *error;
    if (![context save:&error]) {
        LOG_APP(LOG_LEVEL_INFO, @"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription 
                                   entityForName:@"FailedBankInfo" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *info in fetchedObjects) {
        LOG_APP(LOG_LEVEL_INFO, @"Name: %@", [info valueForKey:@"name"]);
        NSManagedObject *details = [info valueForKey:@"details"];
        LOG_APP(LOG_LEVEL_INFO, @"Zip: %@", [details valueForKey:@"zip"]);
    }        
    [fetchRequest release];
}

- (void)testCoreData {
    NSManagedObjectContext *context = [self managedObjectContext];
    FailedBankInfo *failedBankInfo = [NSEntityDescription
                                      insertNewObjectForEntityForName:@"FailedBankInfo" 
                                      inManagedObjectContext:context];
    failedBankInfo.name = @"Test Bank";
    failedBankInfo.city = @"Testville";
    failedBankInfo.state = @"Testland";
    FailedBankDetails *failedBankDetails = [NSEntityDescription
                                            insertNewObjectForEntityForName:@"FailedBankDetails" 
                                            inManagedObjectContext:context];
    failedBankDetails.closeDate = [NSDate date];
    failedBankDetails.updatedDate = [NSDate date];
    failedBankDetails.zip = [NSNumber numberWithInt:12345];
    failedBankDetails.info = failedBankInfo;
    failedBankInfo.details = failedBankDetails;
    NSError *error;
    if (![context save:&error]) {
        LOG_APP(LOG_LEVEL_INFO, @"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    
    // Test listing all FailedBankInfos from the store
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"FailedBankInfo" 
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    for (FailedBankInfo *info in fetchedObjects) {
        LOG_APP(LOG_LEVEL_INFO, @"Name: %@", info.name);
        FailedBankDetails *details = info.details;
        LOG_APP(LOG_LEVEL_INFO, @"Zip: %@", details.zip);
    }        
    [fetchRequest release];}

- (void)dealloc
{
    [_navController release];
    [_window release];
    [__managedObjectContext release];
    [__managedObjectModel release];
    [__persistentStoreCoordinator release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];

    FailedBanksListViewController *listViewController = [[FailedBanksListViewController alloc] init];
    listViewController.context = [self managedObjectContext];
    _navController = [[UINavigationController alloc] initWithRootViewController:listViewController];
    [listViewController release];

    [self.window addSubview:_navController.view];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil)
    {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil)
    {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil)
    {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"FailedBanksCD" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil)
    {
        return __persistentStoreCoordinator;
    }

/*  Not using default data path
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"FailedBanksCD.sqlite"];
*/
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"FailedBanksCD.sqlite"];
    NSString *storePath = [storeURL path];
    
    // Put down default db if it doesn't already exist
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:storePath]) {
        NSString *defaultStorePath = [[NSBundle mainBundle] pathForResource:@"FailedBanksCD" ofType:@"sqlite"];
        if (defaultStorePath) {
            [fileManager copyItemAtPath:defaultStorePath toPath:storePath error:NULL];
        }
    }
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return __persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
