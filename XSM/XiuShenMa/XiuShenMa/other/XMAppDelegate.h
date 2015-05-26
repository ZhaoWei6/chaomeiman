//
//  XMAppDelegate.h
//  XiuShemMa
//
//  Created by Apple on 14-10-5.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import "APService.h"
#import "ModalAnimation.h"
@interface XMAppDelegate : UIResponder <UIApplicationDelegate,UIAlertViewDelegate,UIViewControllerTransitioningDelegate>{
    Reachability  *hostReach;
    ModalAnimation *_modalAnimationController;
}

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
