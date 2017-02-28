//
//  Note+Addition.h
//  Note
//
//  Created by ZhangChaoxin on 15/8/14.
//  Copyright (c) 2015年 ZhangChaoxin. All rights reserved.
//

#import "Note.h"

@interface Note (Addition)

+ (BOOL)removeAllNotes;

+ (NSMutableArray *)notesArray;

+ (void)insertNote:(Note *)note;

+ (BOOL)isExistForNote:(Note *)note;

+ (BOOL)deleteForNote:(Note *)note;

+ (void)updateForNote:(Note *)note;

@end
