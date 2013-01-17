//
//  AppDelegate.h
//  caseshop
//
//  Created by Yongnam Park on 12. 10. 24..
//  Copyright (c) 2012년 CultStory Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MainViewController.h"
#import "DeviceSelectController.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

+(AppDelegate*)sharedAppdelegate;
- (NSString*)uuid;

- (BOOL)isIphone5;
- (void)loadMainViewWithShoptype:(ShopType)type categoryId:(NSInteger)categoryId withTitle:(NSString*)title;

@end
