//
//  ICloudManager.m
//  Note
//
//  Created by ZhangChaoxin on 15/9/24.
//  Copyright © 2015年 ZhangChaoxin. All rights reserved.
//
#define kContainerIdentifier @"iCloud.com.fazhi.noteBook"
#import "ICloudManager.h"
#import "CXDocument.h"
@interface ICloudManager ()
@property (nonatomic, strong) NSMetadataQuery *dataQuery;
@end

@implementation ICloudManager
static ICloudManager *manager = nil;
+ (id)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ICloudManager alloc] init];
    });
    return manager;
}
#pragma mark - 属性
-(NSMetadataQuery *)dataQuery
{
    if (!_dataQuery) {
        //创建一个iCloud查询对象
        _dataQuery=[[NSMetadataQuery alloc]init];
        _dataQuery.searchScopes=@[NSMetadataQueryUbiquitousDocumentsScope];
        
        //注意查询状态是通过通知的形式告诉监听对象的
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(metadataQueryStart:) name:NSMetadataQueryDidStartGatheringNotification object:_dataQuery];//数据获取开始通知

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(metadataQueryFinish:) name:NSMetadataQueryDidFinishGatheringNotification object:_dataQuery];//数据获取完成通知
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(metadataQueryProgress:) name:NSMetadataQueryGatheringProgressNotification object:_dataQuery];//数据获取进度通知

        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(metadataQueryFinish:) name:NSMetadataQueryDidUpdateNotification object:_dataQuery];//查询更新通知
    }
    return _dataQuery;
}
#pragma mark - 保存文档到iCloud/读取iCloud文件到本地
- (void)saveDocument:(NSString *)fileName
{
    fileName = [NSString stringWithFormat:@"%@.sqlite",fileName];
    NSURL *url = [self getUbiquityFileURL:fileName];
    if (url)
    {
        CXDocument *document = [[CXDocument alloc] initWithFileURL:url];
        [document saveToURL:url forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success) {
            if (success)
            {
                [DataHander showInfoWithTitle:@"保存成功"];
            }
            else
            {
                [DataHander showInfoWithTitle:@"保存失败"];
            }
            
        }];
    }
}

- (void)loadDocument:(NSString *)fileName
{
    [self.dataQuery startQuery];
}

#pragma mark - iCloud通知方法
- (void)metadataQueryStart:(NSNotification *)notification
{
    
}
- (void)metadataQueryProgress:(NSNotification *)notification
{
    NSLog(@"...");
}
- (void)metadataQueryFinish:(NSNotification *)notification
{
    NSArray *items=self.dataQuery.results;//查询结果集
    [items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSMetadataItem *item=obj;
        NSURL *url = [item valueForAttribute:NSMetadataItemURLKey];
        [self downloadFileIfNotAvailable:url];
//        NSString *fileName=[item valueForAttribute:NSMetadataItemFSNameKey];
//        NSDate *date=[item valueForAttribute:NSMetadataItemFSContentChangeDateKey];
//        NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
//        dateformate.dateFormat=@"YY-MM-dd HH:mm";
//        NSString *dateString= [dateformate stringFromDate:date];
//        [self.files setObject:dateString forKey:fileName];
    }];

}
- (BOOL)downloadFileIfNotAvailable:(NSURL*)file {
    NSNumber*  isIniCloud = nil;
    
    if ([file getResourceValue:&isIniCloud forKey:NSURLIsUbiquitousItemKey error:nil]) {
        // If the item is in iCloud, see if it is downloaded.
        if ([isIniCloud boolValue]) {
            NSNumber*  isDownloaded = nil;
            if ([file getResourceValue:&isDownloaded forKey:NSURLUbiquitousItemIsDownloadedKey error:nil]) {
                if ([isDownloaded boolValue])
                    
                    return YES;
                
                // Download the file.
                NSFileManager*  fm = [NSFileManager defaultManager];
                [fm startDownloadingUbiquitousItemAtURL:file error:nil];
                return NO;
            }
        }
    }
    // Return YES as long as an explicit download was not started.
    return YES;
}
#pragma mark - 私有方法
/**
 *  取得云端存储文件的地址
 *
 *  @param fileName 文件名，如果文件名为nil则重新创建一个url
 *
 *  @return 文件地址
 */
- (NSURL *)getUbiquityFileURL:(NSString *)fileName
{
    //取得云端URL基地址(参数中传入nil则会默认获取第一个容器)
    NSURL *url= [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:kContainerIdentifier];
    if (!url)
    {
        [DataHander showInfoWithTitle:@"iCloud不可用，请检查设置"];
    }
    //取得Documents目录
    url=[url URLByAppendingPathComponent:@"Documents"];
    //取得最终地址
    url=[url URLByAppendingPathComponent:fileName];
    return url;
}

@end
