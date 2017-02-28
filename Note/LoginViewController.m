//
//  LoginViewController.m
//  Note
//
//  Created by ZhangChaoxin on 15/8/15.
//  Copyright (c) 2015年 ZhangChaoxin. All rights reserved.
//

#import "LoginViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "AppDelegate.h"
#import "CLLockVC.h"
#import "CoreArchive.h"
#import "CoreLockConst.h"
#import "Note+Addition.h"
@interface LoginViewController () <UIAlertViewDelegate>
{
    BOOL _isFirst;
}
@end

@implementation LoginViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};

    self.title = @"解锁登录";
    _isFirst = YES;
    [self initUI];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (_isFirst)
    {
        _isFirst = NO;
        if (![self touchIDShowInfo:NO])
        {
            [self gesture];
        }
    }
}
- (void)gesture
{
    BOOL hasPwd = [CLLockVC hasPwd];
    if(hasPwd){
        [CLLockVC showVerifyLockVCInVC:self forgetPwdBlock:^{
        } successBlock:^(CLLockVC *lockVC, NSString *pwd) {
            [lockVC dismiss:0.1f];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[AppDelegate delegate] gotoMainVC];
            });
        }];
    }else{
        [CLLockVC showSettingLockVCInVC:self successBlock:^(CLLockVC *lockVC, NSString *pwd) {
            [lockVC dismiss:1.0f];
        }];
    }
}
- (BOOL)touchIDShowInfo:(id)showInfo
{
    LAContext *context = [[LAContext alloc] init];
    NSError *error = nil;
    NSString *localizedReasonString = @"输入指纹解锁";
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error])
    {
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:localizedReasonString reply:^(BOOL success, NSError *error) {
            if (success)
            {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    AppDelegate *delegate = [AppDelegate delegate];
                    [delegate gotoMainVC];
                }];
            }
            else
            {
                NSLog(@"%@",error.description);
                switch (error.code) {
                    case LAErrorSystemCancel:
                    {
                        NSLog(@"Authentication was cancelled by the system");
                        //切换到其他APP，系统取消验证Touch ID
                        break;
                    }
                    case LAErrorUserCancel:
                    {
                        NSLog(@"Authentication was cancelled by the user");
                        //用户取消验证Touch ID
                        break;
                    }
                    case LAErrorUserFallback:
                    {
                        NSLog(@"User selected to enter custom password");
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            //用户选择输入密码，切换主线程处理
                        }];
                        break;
                    }
                    default:
                    {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            //其他情况，切换主线程处理
                        }];
                        break;
                    }
                }
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    //其他情况，切换主线程处理
                    [DataHander showInfoWithTitle:@"指纹认证失败"];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        
                    });
                    
                }];
            }
        }];
    }
    else
    {
        if ([showInfo isKindOfClass:[UIButton class]])
        {
            [DataHander showInfoWithTitle:@"抱歉，您的设备还没有设置或者不支持指纹解锁"];
        }
        return NO;
    }
    return YES;
}
- (void)initUI
{
    UIImageView *imageView = [[UIImageView alloc] initForAutoLayout];
    [self.view addSubview:imageView];
    [imageView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.view withOffset:100];
    [imageView autoAlignAxis:ALAxisVertical toSameAxisOfView:self.view];
    [imageView autoSetDimensionsToSize:CGSizeMake(200, 200)];
    imageView.image = [UIImage imageNamed:@"note.jpg"];
    
    float heightSpace;
    if (DEF_SCREEN_IS_6plus) {
        heightSpace = 44;
    }else if (DEF_SCREEN_IS_6){
        heightSpace = 40;
    }
    else if (DEF_SCREEN_IS_5s){
        heightSpace = 30;
    }else{
        heightSpace =20;
    }
        
    UIButton *touchIDButton = [[UIButton alloc] initForAutoLayout];
    touchIDButton.clipsToBounds = YES;
    touchIDButton.layer.cornerRadius = 5;
    //    touchIDButton.backgroundColor = [UIColor colorWithRed:0.05 green:0.2 blue:0.35 alpha:1];
    [touchIDButton setTitle:@"指纹解锁" forState:UIControlStateNormal];
    [touchIDButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [touchIDButton addTarget:self action:@selector(touchIDShowInfo:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:touchIDButton];
    [touchIDButton autoAlignAxis:ALAxisVertical toSameAxisOfView:self.view];
    [touchIDButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:imageView withOffset:heightSpace];
    [touchIDButton autoSetDimension:ALDimensionHeight toSize:heightSpace];
    
    UIButton *loginButton = [[UIButton alloc] initForAutoLayout];
    loginButton.clipsToBounds = YES;
    loginButton.layer.cornerRadius = 5;
//    loginButton.backgroundColor = [UIColor colorWithRed:0.05 green:0.2 blue:0.35 alpha:1];
    [loginButton setTitle:@"手势解锁" forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(gesture) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
    [loginButton autoAlignAxis:ALAxisVertical toSameAxisOfView:self.view];
    [loginButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:touchIDButton withOffset:heightSpace];
    [loginButton autoSetDimension:ALDimensionHeight toSize:heightSpace];
    
    UIButton *modifyButton = [[UIButton alloc] initForAutoLayout];
    modifyButton.clipsToBounds = YES;
    modifyButton.layer.cornerRadius = 5;
//    modifyButton.backgroundColor = [UIColor colorWithRed:0.05 green:0.2 blue:0.35 alpha:1];
    [modifyButton setTitle:@"修改手势" forState:UIControlStateNormal];
    [modifyButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [modifyButton addTarget:self action:@selector(modify) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:modifyButton];
    [modifyButton autoAlignAxis:ALAxisVertical toSameAxisOfView:self.view];
    [modifyButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:loginButton withOffset:heightSpace];
    [modifyButton autoSetDimension:ALDimensionHeight toSize:heightSpace];
    
    UIButton *resetButton = [[UIButton alloc] initForAutoLayout];
    resetButton.clipsToBounds = YES;
    resetButton.layer.cornerRadius = 5;
//    resetButton.backgroundColor = [UIColor colorWithRed:0.05 green:0.2 blue:0.35 alpha:1];
    [resetButton setTitle:@"重置手势" forState:UIControlStateNormal];
    [resetButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [resetButton addTarget:self action:@selector(reset) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:resetButton];
    [resetButton autoAlignAxis:ALAxisVertical toSameAxisOfView:self.view];
    [resetButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:modifyButton withOffset:heightSpace];
    [resetButton autoSetDimension:ALDimensionHeight toSize:heightSpace];
}

- (void)reset
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"重置手势会清除所有记录，确定要继续吗？" delegate:self cancelButtonTitle:@"不了" otherButtonTitles:@"确定", nil];
    alert.delegate = self;
    [alert show];
}

- (void)modify
{
    BOOL hasPwd = [CLLockVC hasPwd];
    if(!hasPwd){
        [CLLockVC showSettingLockVCInVC:self successBlock:^(CLLockVC *lockVC, NSString *pwd) {
            [[AppDelegate delegate] gotoMainVC];
        }];
    }else {
        [CLLockVC showModifyLockVCInVC:self successBlock:^(CLLockVC *lockVC, NSString *pwd) {
            [lockVC dismiss:.5f];
        }];
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        if ([Note removeAllNotes])
        {
            [DataHander showSuccessWithTitle:@"重置手势成功"];
            [CoreArchive removeStrForKey:CoreLockPWDKey];
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
