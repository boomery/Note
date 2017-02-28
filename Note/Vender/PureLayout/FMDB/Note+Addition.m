//
//  Note+Addition.m
//  Note
//
//  Created by ZhangChaoxin on 15/8/14.
//  Copyright (c) 2015年 ZhangChaoxin. All rights reserved.
//

#import "Note+Addition.h"
#import "CXDataBaseUtil.h"
@implementation Note (Addition)

+ (BOOL)removeAllNotes
{
    FMDatabase *db = [CXDataBaseUtil database];
    if (![db open])
    {
        [db close];
        NSAssert([db open], @"数据库打开失败");
    }
    [db setShouldCacheStatements:YES];
    NSString *updateSql= [NSString stringWithFormat:
                          @"delete from %@ ",TABLE_NAME];
    BOOL res = [db executeUpdate:updateSql];
    if (res)
    {
        NSLog(@"删除成功");
    }
    else
    {
        NSLog(@"删除失败");
    }
    [db close];
    return res;

}
+ (NSMutableArray *)notesArray
{
    NSMutableArray *noteArray = [[NSMutableArray alloc] init];
    FMDatabase *db = [CXDataBaseUtil database];
    if (![db open])
    {
        [db close];
        NSAssert([db open], @"数据库打开失败");
    }
    [db setShouldCacheStatements:YES];
    NSString *querySql= [NSString stringWithFormat:
                         @"select distinct *from %@",TABLE_NAME];
    FMResultSet *result = [db executeQuery:querySql];
    while ([result next])
    {
        Note *note = [[Note alloc] initWithResult:result];
        [noteArray addObject:note];
    }
    [result close];
    [db close];
    return noteArray;
}
#pragma mark - 插入一条新的记录
+ (void)insertNote:(Note *)note
{
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[CXDataBaseUtil getDatabasePath]];
    [queue inDatabase:^(FMDatabase *db) {
        if (![self isExistForNote:note])
        {
            NSString *insertSql= [NSString stringWithFormat:
                                  @"INSERT INTO '%@' ('%@', '%@', '%@') VALUES('%@', '%@', '%d')",
                                  TABLE_NAME, @"content", @"insertTime", @"isActive",note.content,note.insertTime,note.isActive];
            BOOL res = [db executeUpdate:insertSql];
            if (res)
            {
                NSLog(@"数据插入成功");
            }
            else
            {
                NSLog(@"数据插入失败");
            }
            [db close];
        }
        else
        {
            [self updateForNote:note];
        }
    }];
}

#pragma mark - 判断已存在的记录
+ (BOOL)isExistForNote:(Note *)note
{
    BOOL isExist = NO;
    FMDatabase *db = [CXDataBaseUtil database];
    if (![db open])
    {
        [db close];
        NSAssert([db open], @"判断。。数据库打开失败");
    }
    //(messageID TEXT PRIMARY KEY, roomID TEXT, title TEXT, content TEXT, pictureUrlString TEXT, userHrid TEXT)"
    [db setShouldCacheStatements:YES];
    NSString *querySql= [NSString stringWithFormat:
                         @"select *from %@ where noteID = '%tu'",TABLE_NAME,note.noteID];
    FMResultSet *result = [db executeQuery:querySql];
    while ([result next])
    {
        isExist = YES;
    }
    [result close];
    return isExist;
}

#pragma mark - 删除记录
+ (BOOL)deleteForNote:(Note *)note
{
    FMDatabase *db = [CXDataBaseUtil database];
    if (![db open])
    {
        [db close];
        NSAssert([db open], @"数据库打开失败");
    }
    //(messageID TEXT PRIMARY KEY, roomID TEXT, title TEXT, content TEXT, pictureUrlString TEXT, userHrid TEXT)"
    [db setShouldCacheStatements:YES];
    NSString *updateSql= [NSString stringWithFormat:
                          @"delete from %@ where noteID = '%tu'",TABLE_NAME,note.noteID];
    BOOL res = [db executeUpdate:updateSql];
    if (res)
    {
        NSLog(@"删除成功");
    }
    else
    {
        NSLog(@"删除失败");
    }
    [db close];
    return res;
}


#pragma mark - 更新同一条记录的内容
+ (void)updateForNote:(Note *)note
{
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[CXDataBaseUtil getDatabasePath]];
    [queue inDatabase:^(FMDatabase *db) {
        NSString *updateSql= [NSString stringWithFormat:
                              @"update '%@' set content = \"%@\" , insertTime = '%@' , isActive = '%d' where noteID = '%tu'",
                              TABLE_NAME,note.content,note.insertTime,note.isActive,note.noteID];
        BOOL res = [db executeUpdate:updateSql];
        if (res)
        {
            NSLog(@"内容修改成功");
        }
        else
        {
            NSLog(@"内容修改失败");
        }
    }];
}
@end
