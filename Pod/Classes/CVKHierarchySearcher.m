//
//  CVKHierarchySearcher.m
//  CVKHierarchySearcher
//
//  Created by Romans Karpelcevs on 12/10/14.
//  Copyright (c) 2014 Romans Karpelcevs. All rights reserved.
//

@import UIKit;

#import "CVKHierarchySearcher.h"

@implementation CVKHierarchySearcher

- (UIViewController *)topmostViewController
{
#ifndef CVK_IS_APP_EXTENSION
    return [self topmostViewControllerFrom:[[self baseWindow] rootViewController] includeModal:YES];
#else
    if ([[NSObject class] instancesRespondToSelector:@selector(r5_rootPresentationController)])
    {
        return [self topmostViewControllerFrom:[self performSelector:@selector(r5_rootPresentationController)] includeModal:YES];
    }
    return nil;
#endif
}

- (UIViewController *)topmostNonModalViewController
{
#ifndef CVK_IS_APP_EXTENSION
    return [self topmostViewControllerFrom:[[self baseWindow] rootViewController] includeModal:NO];
#else
    if ([[NSObject class] instancesRespondToSelector:@selector(r5_rootPresentationController)])
    {
        return [self topmostViewControllerFrom:[self performSelector:@selector(r5_rootPresentationController)] includeModal:NO];
    }
    return nil;
#endif
}

- (UINavigationController *)topmostNavigationController
{
    return [self topmostNavigationControllerFrom:[self topmostViewController]];
}

- (UINavigationController *)topmostNavigationControllerFrom:(UIViewController *)vc
{
    if ([vc isKindOfClass:[UINavigationController class]])
        return (UINavigationController *)vc;
    if ([vc navigationController])
        return [vc navigationController];

    return nil;
}

- (UIViewController *)topmostViewControllerFrom:(UIViewController *)viewController
                                   includeModal:(BOOL)includeModal
{
    if ([viewController respondsToSelector:@selector(selectedViewController)])
        return [self topmostViewControllerFrom:[(id)viewController selectedViewController]
                                  includeModal:includeModal];

    if (includeModal && viewController.presentedViewController)
        return [self topmostViewControllerFrom:viewController.presentedViewController
                                  includeModal:includeModal];

    if ([viewController respondsToSelector:@selector(topViewController)])
        return [self topmostViewControllerFrom:[(id)viewController topViewController]
                                  includeModal:includeModal];

    return viewController;
}

- (UIWindow *)baseWindow
{
#ifndef CVK_IS_APP_EXTENSION
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    if (!window)
        window = [[UIApplication sharedApplication] keyWindow];

    NSAssert(window != nil, @"No window to calculate hierarchy from");
#else
    UIWindow *window = nil;
#endif
    return window;
}

@end
