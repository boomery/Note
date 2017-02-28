//
//  Note.m
//  Note
//
//  Created by ZhangChaoxin on 15/8/14.
//  Copyright (c) 2015年 ZhangChaoxin. All rights reserved.
//

#import "Note.h"
@implementation Note

- (id)initWithResult:(FMResultSet *)result
{
    if (self = [super init])
    {
        _noteID = [[result stringForColumn:@"noteID"] integerValue];
        _content = [result stringForColumn:@"content"];
        _insertTime = [result stringForColumn:@"insertTime"];
        _isActive = [result stringForColumn:@"isActive"];
    }
    return self;
}
@end
