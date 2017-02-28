//
//  Note.h
//  Note
//
//  Created by ZhangChaoxin on 15/8/14.
//  Copyright (c) 2015年 ZhangChaoxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface Note : NSObject

@property (nonatomic, assign) NSInteger noteID;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *insertTime;
@property (nonatomic, assign) BOOL isActive;

- (id)initWithResult:(FMResultSet *)result;
@end
