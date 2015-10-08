//
//  AppDelegate.m
//  DateLeaks
//
//  Created by Ben Stovold on 6/10/2015.
//  Copyright © 2015 Thoughtful Pixel. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    NSManagedObjectModel *managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"DateLeaks" withExtension:@"momd"]];
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
    NSURL *storeURL = [[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject] URLByAppendingPathComponent:@"DateLeaks.sqlite"];
    [coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:nil];
    NSManagedObjectContext *mainContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    mainContext.persistentStoreCoordinator = coordinator;

    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    context.parentContext = mainContext;
    
    // Leaks in iOS 9 but not iOS 8
    NSDate *dateParam = [NSDate date];
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"dateParam retainCount is %@", [dateParam valueForKey:@"retainCount"]);
    });
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Entity"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"date >= %@", dateParam];
    
    __block NSArray *result;
    dispatch_group_enter(group);
    [context performBlockAndWait:^{
        result = [context executeFetchRequest:fetchRequest error:nil];
        dispatch_group_leave(group);
    }];
    
    return YES;
}

@end
