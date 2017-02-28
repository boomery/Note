//
//  NSString+HeightCaculator.m
//  Note
//
//  Created by ZhangChaoxin on 15/8/14.
//  Copyright (c) 2015年 ZhangChaoxin. All rights reserved.
//

#import "NSString+HeightCaculator.h"

@implementation NSString (HeightCaculator)

+ (CGFloat)heightForDataStorageContent:(NSString *)content fontSize:(CGFloat)size
{
    static NSCache* heightCache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        heightCache = [NSCache new];
    });
    
    NSNumber *heightNumber = [heightCache objectForKey:content];
    if (heightNumber)
    {
        CGFloat cachedHeight = [heightNumber floatValue];
        return cachedHeight;
    }
    CGRect rect = [content boundingRectWithSize:CGSizeMake(DEF_SCREEN_WIDTH, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:size]} context:nil];
    CGFloat height = rect.size.height;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [heightCache setObject:[NSNumber numberWithFloat:height] forKey:content];
    });
    return rect.size.height;
}
@end
