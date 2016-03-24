//
//  AppDelegate.m
//  test
//
//  Created by Paul Marney on 1/26/15.
//  Copyright (c) 2015 Paul Marney. All rights reserved.
//

#import "AppDelegate.h"
#import "DetailViewController.h"

@interface AppDelegate () <UISplitViewControllerDelegate> {
    BOOL _isEditing;
    BOOL _rotate;
    int _dismissKeyCount;
    NSNotification *_hideNotification;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(orientationWillChanged:)
                                                     name:UIApplicationWillChangeStatusBarOrientationNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(orientationDidChanged:)
                                                     name:UIApplicationDidChangeStatusBarOrientationNotification
                                                   object:nil];
    }
    _isEditing = false;
    _rotate = false;
    _dismissKeyCount = 0;
    if (![UICKeyChainStore stringForKey:@"FirstLoad"]) {
        [UICKeyChainStore setString:@"Yes" forKey:@"FirstLoad"];
        [ElectricalEnvCal setAllDeafults];
    }
    
    return YES;
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Split view

- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController {
    
    if ([secondaryViewController isKindOfClass:[UINavigationController class]] &&
        [[(UINavigationController *)secondaryViewController topViewController] isKindOfClass:[DetailViewController class]] &&
        ([(DetailViewController *)[(UINavigationController *)secondaryViewController topViewController] detailItem] == nil)) {
        return YES;
    } else {
        return NO;
    }
}


#pragma mark - NSNotificationCenter

- (void)keyboardWillShow:(NSNotification*)notification{
    if (_isEditing == false && _isEmail == false) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:[notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
        [UIView setAnimationCurve:[notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue]];
        [UIView setAnimationBeginsFromCurrentState:YES];
        
        NSDictionary* keyboardInfo = [notification userInfo];
        NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
        _window.frame = CGRectMake(_window.frame.origin.x,
                                   _window.frame.origin.y,
                                   _window.frame.size.width,
                                   _window.frame.size.height - keyboardFrameBeginRect.size.height);
        _hideNotification = notification;
        [UIView commitAnimations];
        _isEditing = true;
        _rotate = true;
        _dismissKeyCount = 0;
    }
    
}
- (void)keyboardWillHide:(NSNotification*)notification{
    _isEditing = false;
    
    if (_isEmail == false) {
        if (_rotate){// && _dismissKeyCount == 0) {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:[notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
            [UIView setAnimationCurve:[notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue]];
            [UIView setAnimationBeginsFromCurrentState:YES];
            
            NSDictionary* keyboardInfo = [notification userInfo];
            NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameEndUserInfoKey];
            CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
            _window.frame = CGRectMake(_window.frame.origin.x,
                                       _window.frame.origin.y,
                                       _window.frame.size.width,
                                       _window.frame.size.height + keyboardFrameBeginRect.size.height);
            [UIView commitAnimations];
        } else {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:[notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
            [UIView setAnimationCurve:[notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue]];
            [UIView setAnimationBeginsFromCurrentState:YES];
            
            [_window setFrame:CGRectMake(0,
                                         0,
                                         ([[UIScreen mainScreen] bounds].size.width),
                                         ([[UIScreen mainScreen] bounds].size.height))];
            
            [UIView commitAnimations];
            _dismissKeyCount = 1;
        }
    }
}

- (void)orientationWillChanged:(NSNotification *)notification{
    _rotate = false;
    
}

- (void)orientationDidChanged:(NSNotification *)notification{
    
    //    [UIView beginAnimations:nil context:NULL];
    //    [UIView setAnimationBeginsFromCurrentState:YES];
    //    _window.frame = [[UIScreen mainScreen] applicationFrame];
    //
    //    [UIView commitAnimations];
}
@end
