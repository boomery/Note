//
//  DataHander.h
//  CaCaXian
//
//  Created by Andy on 13-4-27.
//  Copyright (c) 2013年 Andy. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface DataHander : NSObject

@property (nonatomic, strong) NSString* strUser;       //登陆账号
@property (nonatomic, strong) NSString* strPassd;      //登录密码
@property (nonatomic, strong) NSString* strAccountTotal;  //可用余额

@property (nonatomic, strong) NSString* strUserId;     //用户Id
@property (nonatomic, assign) BOOL isNeed;             //
@property (nonatomic, strong) NSMutableDictionary *rowDic;

@property (nonatomic,strong)NSDictionary *cargoDicData;//

+ (DataHander *)sharedDataHander;

+ (void)showDlg;
+ (void)hideDlg;

+ (void)showSuccessWithTitle:(NSString *)title;
+ (void)showSuccessWithTitle:(NSString *)title completionBlock:(void(^)())completionBlock;
+ (void)showErrorWithTitle:(NSString *)title;
+ (void)showInfoWithTitle:(NSString *)title;

//取消请求
//-(void)cancelRequest;
@end
