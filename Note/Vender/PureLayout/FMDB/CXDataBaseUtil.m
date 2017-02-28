//
//  CXDataBaseUtil.m
//  ACIM
//
//  Created by zcx on 15/1/27.
//  Copyright (c) 2015年 ownerblood. All rights reserved.
//
#import "CXDataBaseUtil.h"
#import "FMDatabaseAdditions.h"
@implementation CXDataBaseUtil

static FMDatabase *_db = nil;
+ (FMDatabase *)database
{
    if (_db == nil)
    {
        if ([self copyDatabaseToSandbox])
        {
            NSLog(@"复制数据库成功");
        }
        _db = [[FMDatabase alloc] initWithPath:[self getDatabasePath]];
    }
    
    return _db;
}
//将数据库拷贝到沙盒中
+ (BOOL)copyDatabaseToSandbox
{
    NSString *filePath = [self getDatabasePath];
    
    BOOL isCopySuccess;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:filePath])
    {
        return [fileManager createFileAtPath:[self getDatabasePath] contents:nil attributes:nil];
    }
    else
    {
//        NSLog(@"数据库已存在");
        isCopySuccess = NO;
    }
    return isCopySuccess;
}

+ (NSString *)getDatabasePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = paths[0];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:FILE_NAME];
    return filePath;
}

+(void)creatTable
{
    FMDatabase *db = [self database];
    
    //判断数据库是否已经打开，如果没有打开，提示失败
    if (![db open])
    {
        NSLog(@"数据库打开失败");
        return;
    }
    //为数据库设置缓存，提高查询效率
    [db setShouldCacheStatements:YES];
    
   	//判断数据库中是否已经存在这个表，如果不存在则创建该表
    if(![db tableExists:TABLE_NAME])
    {
        NSString *createSql = [NSString stringWithFormat:@"CREATE TABLE %@(noteID INTEGER PRIMARY KEY AUTOINCREMENT, insertTime TEXT, content TEXT,isActive TEXT default '0',colorName TEXT)",TABLE_NAME];
        if ([db executeUpdate:createSql])
        {
            NSLog(@"建表成功");
        }
    }
    else
    {
        NSString *createSql = [NSString stringWithFormat:@" alter table %@ add column colorName TEXT ",TABLE_NAME];
        if ([db executeUpdate:createSql])
        {
            NSLog(@"改表成功");
        }
    }
}
@end
