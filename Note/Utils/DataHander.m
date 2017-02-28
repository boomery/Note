//
//  DataHander.m
//  CaCaXian
//
//  Created by Andy on 13-4-27.
//  Copyright (c) 2013年 Andy. All rights reserved.
//

#import "DataHander.h"
#import "AppDelegate.h"
#import "SVProgressHUD.h"
@implementation DataHander
static DataHander* dataHander = nil;
@synthesize isNeed;
@synthesize rowDic;
+(DataHander *)sharedDataHander
{
    @synchronized(self){
        if (dataHander == nil) {
            dataHander = [[self alloc] init];
            
        }
    }
    return dataHander;
}

+ (void)showDlg
{
    NSString *loadString = NSLocalizedString(@"loading", @"");
    [SVProgressHUD setBackgroundColor:THEME_COLOR];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD showWithStatus:loadString maskType:SVProgressHUDMaskTypeClear];
}
+ (void)hideDlg
{
    [SVProgressHUD dismiss];
}

+ (void)showErrorWithTitle:(NSString *)title
{
    NSString *errorString = NSLocalizedString(title, @"");
    [SVProgressHUD setBackgroundColor:THEME_COLOR];
    [SVProgressHUD showErrorWithStatus:errorString maskType:SVProgressHUDMaskTypeNone];
}

+ (void)showSuccessWithTitle:(NSString *)title
{
    NSString *errorString = NSLocalizedString(title, @"");
    [SVProgressHUD setBackgroundColor:THEME_COLOR];
    [SVProgressHUD showSuccessWithStatus:errorString maskType:SVProgressHUDMaskTypeNone];
}
+ (void)showSuccessWithTitle:(NSString *)title completionBlock:(void(^)())completionBlock
{
    NSString *errorString = NSLocalizedString(title, @"");
    [SVProgressHUD setBackgroundColor:THEME_COLOR];
    [SVProgressHUD showSuccessWithStatus:errorString maskType:SVProgressHUDMaskTypeNone];
    [SVProgressHUD sharedView].dismissBlock = ^{
        if (completionBlock)
        {
            completionBlock();
        }
    };
}
+ (void)showInfoWithTitle:(NSString *)title
{
    NSString *errorString = NSLocalizedString(title, @"");
    [SVProgressHUD setBackgroundColor:THEME_COLOR];
    [SVProgressHUD showInfoWithStatus:errorString maskType:SVProgressHUDMaskTypeNone];
}

-(id)init{
    
    if(self = [super init])
    {
        isNeed = NO;
    }
    return self;
}
@end
