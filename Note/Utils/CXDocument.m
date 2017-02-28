//
//  CXDocument.m
//  Note
//
//  Created by ZhangChaoxin on 15/9/24.
//  Copyright © 2015年 ZhangChaoxin. All rights reserved.
//

#import "CXDocument.h"
@implementation CXDocument
#pragma mark - 重写父类方法
/**
 *  保存时调用
 *
 *  @param typeName <#typeName description#>
 *  @param outError <#outError description#>
 *
 *  @return <#return value description#>
 */
-(id)contentsForType:(NSString *)typeName error:(NSError *__autoreleasing *)outError{
    if (self.data) {
        return [self.data copy];
    }
    return [NSData data];
}

/**
 *  读取数据时调用
 *
 *  @param contents <#contents description#>
 *  @param typeName <#typeName description#>
 *  @param outError <#outError description#>
 *
 *  @return <#return value description#>
 */
-(BOOL)loadFromContents:(id)contents ofType:(NSString *)typeName error:(NSError *__autoreleasing *)outError{
    self.data=[contents copy];
    return true;
}
@end
