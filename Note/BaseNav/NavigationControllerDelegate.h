//
//  NavigationControllerDelegate.h
//  Animation
//
//  Created by blue on 15-6-19.
//  Copyright (c) 2015年 blue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NavigationControllerDelegate : NSObject <UINavigationControllerDelegate>

@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *interactionController;
@property (nonatomic, weak) UINavigationController *navigationController;
- (id)initWithNavgationController:(UINavigationController *)navigationController;

@end
