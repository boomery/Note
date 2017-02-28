//
//  DetailViewController.h
//  Note
//
//  Created by ZhangChaoxin on 15/8/17.
//  Copyright (c) 2015年 ZhangChaoxin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Note;
@interface DetailViewController : UIViewController

@property (nonatomic, strong) Note *note;
@property (nonatomic, copy) void(^saveBlock)();

@end
