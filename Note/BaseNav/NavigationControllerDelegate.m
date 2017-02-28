//
//  NavigationControllerDelegate.m
//  Animation
//
//  Created by blue on 15-6-19.
//  Copyright (c) 2015年 blue. All rights reserved.
//

#import "NavigationControllerDelegate.h"
#import "CircleTransitionAnimator.h"
#import "PopAnimation.h"
#import "Animator.h"
@implementation NavigationControllerDelegate

//-(void)awakeFromNib
//{
//    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panned:)];
//    [self.navigationController.view addGestureRecognizer:panGesture];
//}
- (id)initWithNavgationController:(UINavigationController *)navigationController
{
    if (self = [super init])
    {
        _navigationController = navigationController;
        navigationController.delegate = self;

        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panned:)];
        [navigationController.view addGestureRecognizer:panGesture];
    }
    return self;
}

- (void)dealloc
{
    
}
- (void)setNavigationController:(UINavigationController *)navigationController
{
}
-(id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    CircleTransitionAnimator *animator = [[CircleTransitionAnimator alloc] init];
//    PopAnimation *animator = [[PopAnimation alloc] init];

//    Animator *animator = [[Animator alloc] init];
    return animator;
}


-(id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
{
    return self.interactionController;
}


- (void)panned:(UIPanGestureRecognizer *)gesture
{
    switch (gesture.state)
    {
//      1.Began: 只要识别了手势，那么它会初始化一个UIPercentDrivenInteractiveTransition对象并将其赋给interactionController属性。
//      如果你切换到第一个视图控制器，它初始化了一个push，如果是在第二个视图控制器，那么初始化的是pop。Pop非常简单，但是对于push，你需要从此前创建的按钮底部手动完成segue.
//      反过来，push/pop调用触发了NavigationControllerDelegate方法调用返回self.interactionController.这样属性就有了non-nil值。
        case UIGestureRecognizerStateBegan:
        {
            self.interactionController = [[UIPercentDrivenInteractiveTransition alloc] init];
            if (self.navigationController.viewControllers.count > 1)
            {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            else
            {
//                [self.navigationController.topViewController performSegueWithIdentifier:@"PushSegue" sender:nil];
            }
        }
            break;
//      2.Changed: 这种状态下，你完成了手势的进程并更新了interactionController.插入动画是项艰苦的工作，不过苹果已经做了这部分的工作，你无需做什么事情。
        case UIGestureRecognizerStateChanged:
        {
            CGPoint translation = [gesture translationInView:self.navigationController.view];
            double completionProgress = translation.x/CGRectGetWidth(self.navigationController.view.bounds);
            [self.interactionController updateInteractiveTransition:completionProgress];
        }
            break;
//       3.你已经看到了pan手势的速度。如果是正数，转场就完成了；如果不是，就是被取消了。你也可以将interactionController设置为nil，这样她就承担了清理的任务。
        case UIGestureRecognizerStateEnded:
        {
            if ([gesture velocityInView:self.navigationController.view].x > 0)
            {
                [self.interactionController finishInteractiveTransition];
            }
            else
            {
                [self.interactionController cancelInteractiveTransition];
            }
            self.interactionController = nil;
        }
            break;
        default:
        {
            [self.interactionController cancelInteractiveTransition];
            self.interactionController = nil;
        }
            break;
    }
}
@end
