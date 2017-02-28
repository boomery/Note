//
//  CircleTransitionAnimator.m
//  Animation
//
//  Created by blue on 15-6-19.
//  Copyright (c) 2015年 blue. All rights reserved.
//

#import "CircleTransitionAnimator.h"
#import "ViewController.h"
@interface CircleTransitionAnimator()
{
    id<UIViewControllerContextTransitioning> _transitionContext;
}
@end
@implementation CircleTransitionAnimator

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.7;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
//    1.在超出该方法范围外保持对transitionContext的引用，以便将来访问
    _transitionContext = transitionContext;
    
//    2.创建从容器视图到视图控制器的引用。容器视图是动画发生的地方，切换的视图控制器是动画的一部分。
    UIView *containerView = [_transitionContext containerView];
//    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 64, 0, 0)];
    
//    3.添加toViewController作为containerView的子视图。
    [containerView addSubview:toVC.view];
    
//    4.创建两个圆形UIBezierPath实例：一个是按钮的尺寸，一个实例的半径范围可覆盖整个屏幕。最终的动画将位于这两个Bezier路径间。
    UIBezierPath *circleMaskPathInitial = [UIBezierPath bezierPathWithOvalInRect:button.frame];
    CGPoint extremePoint = CGPointMake(button.center.x, button.center.y-CGRectGetHeight(toVC.view.bounds));
    double radius = sqrt((extremePoint.x*extremePoint.x)+(extremePoint.y*extremePoint.y))*2;
    UIBezierPath *circleMaskPathFinal = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(button.frame, -radius, -radius)];
    
//    5.创建一个新的CAShape来展示圆形遮罩。你可以在动画之后使用最终的循环路径指定其路径值，以避免图层在动画完成后回弹。Layer
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.path = circleMaskPathFinal.CGPath;
    toVC.view.layer.mask = maskLayer;
    
//    6.在关键路径上创建一个CABasicAnimation，从circleMaskPathInitial到circleMaskPathFinal.你也要注册一个委托，因为你要在动画完成后做一些清理工作。
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
    animation.fromValue = (__bridge id)(circleMaskPathInitial.CGPath);
    animation.toValue = (__bridge id)(circleMaskPathFinal.CGPath);
    animation.duration = [self transitionDuration:_transitionContext];
    animation.delegate = self;
    
    [maskLayer addAnimation:animation forKey:@"path"];
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
//    第一行是告知iOS动画的完成。由于动画已经完成了，所以你可以移除遮罩。最后一步是实际使用
    [_transitionContext completeTransition:![_transitionContext transitionWasCancelled]];
    [_transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view.layer.mask = nil;
}
@end
