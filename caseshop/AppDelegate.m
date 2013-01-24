 //
//  AppDelegate.m
//  caseshop
//
//  Created by Yongnam Park on 12. 10. 24..
//  Copyright (c) 2012년 CultStory Inc. All rights reserved.
//

#import "AppDelegate.h"
#import "Flurry.h"
#import "NoticeController.h"
#import "NoticeDetailController.h"
#import <SDWebImage/SDImageCache.h>



@implementation AppDelegate


@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;


+(AppDelegate*)sharedAppdelegate
{
    return (AppDelegate*)[[UIApplication sharedApplication] delegate];
}


#pragma mark - Device Identifying

- (BOOL)isIphone5{
    CGRect rect = [UIScreen mainScreen].bounds;
    if (rect.size.height == DEVICE_HEIGHT_IPHONE_5)
        return YES;
    
    return NO;
}

#pragma mark - App Identifying

- (NSString*)uuid{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *storedUuid = [def stringForKey:kUUID];
    
    if (!storedUuid){
        CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
        NSString *string = (NSString *)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, uuid));
        
        [[NSUserDefaults standardUserDefaults] setObject:string forKey:kUUID];
        [[NSUserDefaults standardUserDefaults] synchronize];
        storedUuid = string;
    }
    
    NSLog(@"uuid: %@", storedUuid);
    
    return storedUuid;
}


#pragma mark - RootView Control

- (void)loadMainView{
    MainViewController *main = [[MainViewController alloc] init];
    
    if (self.window.rootViewController){
        [UIView transitionFromView:self.window.rootViewController.view
                            toView:main.view duration:1
                           options:UIViewAnimationOptionTransitionFlipFromLeft
                        completion:^(BOOL finished){
                            self.window.rootViewController = main;
                        }];
    } else {
        self.window.rootViewController = main;
    }
    
    
    
    
    
}

- (void)loadMainViewWithShoptype:(ShopType)type categoryId:(NSInteger)categoryId withTitle:(NSString*)title{
    MainViewController *main = [[MainViewController alloc] init];
    
    if (self.window.rootViewController){
        [UIView transitionFromView:self.window.rootViewController.view
                            toView:main.view duration:1
                           options:UIViewAnimationOptionTransitionFlipFromLeft
                        completion:^(BOOL finished){
                            self.window.rootViewController = main;
                        }];
    } else {
        self.window.rootViewController = main;
    }
    
    [main setShopType:type withCategoryId:categoryId title:title];
    
}

- (void)loadDeviceSelect{
    DeviceSelectController *device = [[DeviceSelectController alloc] initWithNibName:@"DeviceSelectController" bundle:nil];
    device.leftBtnHide = YES;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:device];
    self.window.rootViewController = nav;
}


#pragma mark - Check device



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    NSLog(APIURL);
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSInteger currCategory = [def integerForKey:kCURRENT_CATEGORY_ID];
    
    if (currCategory){
        [self loadMainView];
    } else {
        [self loadDeviceSelect];
    }
    
    
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    
    // Flurry Start
    [Flurry startSession:@"CW4PMK2GGTHSDSQH3STN"];
    
    
    
//    [[SDImageCache sharedImageCache] clearMemory];
//    [[SDImageCache sharedImageCache] clearDisk];
//    [[SDImageCache sharedImageCache] cleanDisk];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    [self restoreBrightness];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [self restoreBrightness];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    NSLog(@"applicationWillEnterForeground");
    
    [self setBrightness];
}



- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSLog(@"applicationDidBecomeActive");
    
    [NoticeController requestNoticeWithDelegate:self];
    
    [self setBrightness];
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
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}


#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:NSLocalizedString(@"Check it out",nil)]){
        NSInteger itemId = [alertView tag];
        
        [NoticeController setLatestNoticeId:itemId];
        NoticeDetailController *notice = [[NoticeDetailController alloc] initWithNibName:@"NoticeDetailController" bundle:nil];
        notice.itemId = itemId;
        notice.hasLeftCancelBtn = YES;
        notice.title = NSLocalizedString(@"NOTICE",nil);
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:notice];
        [self.window.rootViewController presentModalViewController:nav animated:YES];
    }
    
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"caseshop" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"caseshop.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
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
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


#pragma mark - Application Handle Open URL

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
    return YES;
}



#pragma mark - Brightness

- (void)setBrightness{
    float originBriteness = [[UIScreen mainScreen] brightness];
    if (originBriteness < .7){
        [[UIScreen mainScreen] setBrightness:.7];
        _originBriteness = originBriteness;
    }
}

- (void)restoreBrightness{
    if (_originBriteness <= 0.7){
        [[UIScreen mainScreen] setBrightness:_originBriteness];
    }
}
@end
