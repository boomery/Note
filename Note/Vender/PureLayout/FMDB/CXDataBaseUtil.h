//
//  CXDataBaseUtil.h
//  ACIM
//
//  Created by zcx on 15/1/27.
//  Copyright (c) 2015年 ownerblood. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
@interface CXDataBaseUtil : NSObject

+(void)creatTable;

+ (FMDatabase *)database;

+ (BOOL)copyDatabaseToSandbox;

+ (NSString *)getDatabasePath;

@end
