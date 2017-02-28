//
//  SlideDeleteCell.h
//  RHSlideDeleteTableViewCell
//
//  Created by london on 14-2-21.
//  Copyright (c) 2014年 Robin_Huang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SlideDeleteCell;
@class Note;
@protocol  SlideDeleteCellDelegate<NSObject>

-(void)slideToDeleteCell:(SlideDeleteCell *)slideDeleteCell;

@end

@interface SlideDeleteCell : UITableViewCell<UIGestureRecognizerDelegate>
{
}

@property (nonatomic, strong) Note *note;
@property(assign, nonatomic)id<SlideDeleteCellDelegate>delegate;

@end
