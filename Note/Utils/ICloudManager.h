//
//  ICloudManager.h
//  Note
//
//  Created by ZhangChaoxin on 15/9/24.
//  Copyright © 2015年 ZhangChaoxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ICloudManager : NSObject
+ (id)sharedManager;

//添加文件到iCloud
- (void)saveDocument:(NSString *)fileName;

//将icloud文件读取到本地
- (void)loadDocument:(NSString *)fileName;
@end
