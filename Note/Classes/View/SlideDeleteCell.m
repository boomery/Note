//
//  SlideDeleteCell.m
//  RHSlideDeleteTableViewCell
//
//  Created by london on 14-2-21.
//  Copyright (c) 2014年 Robin_Huang. All rights reserved.
//

#import "SlideDeleteCell.h"
#import "Note.h"
#define kRotationRadian  90.0/360.0
#define kVelocity        100

@interface SlideDeleteCell()

@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property(assign, nonatomic) CGPoint currentPoint;
@property(assign, nonatomic) CGPoint previousPoint;
@property(strong, nonatomic) UIPanGestureRecognizer *panGestureRecognizer;
@property(assign, nonatomic) float offsetRate;

@end

@implementation SlideDeleteCell
@synthesize delegate;

#pragma mark - Initialization -

- (id)init
{
    if (self = [super init])
	{
        [self addPanGestureRecognizer];
    }
	
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
	{
        [self addPanGestureRecognizer];
    }
	
    return self;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel *contentLabel = [[UILabel alloc] initForAutoLayout];
        [self addSubview:contentLabel];
        [contentLabel autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(10, 10, 50, 10)];
        contentLabel.textColor = [UIColor blackColor];
        contentLabel.font = [UIFont systemFontOfSize:16];
        contentLabel.numberOfLines = 0;
        _contentLabel = contentLabel;
        
        UILabel *timeLabel = [[UILabel alloc] initForAutoLayout];
        [self addSubview:timeLabel];
        [timeLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:contentLabel withOffset:10];
        [timeLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self withOffset:-10];
        [timeLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self withOffset:10];
        [timeLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self withOffset:-10];
        timeLabel.textAlignment = 2;
        timeLabel.textColor = [UIColor blackColor];
        timeLabel.font = [UIFont systemFontOfSize:14];
        timeLabel.numberOfLines = 0;
        _timeLabel = timeLabel;
        
        UIView *lineView = [[UIView alloc] initForAutoLayout];
        [self addSubview:lineView];
        [lineView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self];
        [lineView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self withOffset:10];
        [lineView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self];
        [lineView autoSetDimension:ALDimensionHeight toSize:LINE_HEIGTH];
        lineView.backgroundColor = THEME_COLOR;
        [self addPanGestureRecognizer];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	if (self = [super initWithCoder:aDecoder])
	{
		[self addPanGestureRecognizer];
	}
	
	return self;
}

- (void)setNote:(Note *)note
{
    _note = note;
    self.contentLabel.text = note.content;
    self.timeLabel.text = note.insertTime;
}

-(void)addPanGestureRecognizer{
    _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(slideToDeleteCell:)];
    _panGestureRecognizer.delegate = self;
    [self addGestureRecognizer:_panGestureRecognizer];
    
}

#pragma mark UIGestureRecognizerDelegate------------------------------------------------
- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer{
    
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        CGPoint velocityPoint = [gestureRecognizer velocityInView:self];
        if (fabs(velocityPoint.x) > kVelocity) {
            return YES;
        }else
            return NO;
    }else
        return NO;
    
}

-(void)slideToDeleteCell:(UIPanGestureRecognizer *)panGestureRecognizer{
    
    _previousPoint = [panGestureRecognizer locationInView:self.superview];
    
    static CGPoint originalCenter;
    UIGestureRecognizerState state = panGestureRecognizer.state;
    if (state == UIGestureRecognizerStateBegan) {
        
        originalCenter = self.center;
        [self.superview bringSubviewToFront:self];
    }else if (state == UIGestureRecognizerStateChanged){
        CGPoint diff = CGPointMake(_previousPoint.x - _currentPoint.x, _previousPoint.y - _currentPoint.y);
        [self handleOffset:diff];
    }else if (state == UIGestureRecognizerStateEnded){
        if (_offsetRate < 0.5) {
            [UIView animateWithDuration:0.2 animations:^{
                
                self.transform = CGAffineTransformIdentity;
                self.center = originalCenter;
                self.alpha = 1.0;
                
            }];
        }else{
            [UIView animateWithDuration:0.2 animations:^{
                self.center = CGPointMake(self.center.x * 2, self.center.y);
                self.alpha = 0.0;
                
            } completion:^(BOOL finsh){
                self.transform = CGAffineTransformIdentity;
                self.center = originalCenter;
                self.alpha = 1.0;
                if ([delegate respondsToSelector:@selector(slideToDeleteCell:)]) {
                    [delegate slideToDeleteCell:self];
                }
                
                
            }];
        }
    }
    _currentPoint = _previousPoint;
    
}

-(void)handleOffset:(CGPoint)offset{
    
    self.center = CGPointMake(self.center.x + offset.x, self.center.y);
    float distance = self.frame.size.width/2 - self.center.x;
    float distanceAbs = fabsf(distance);
    float distanceRate = (self.frame.size.width - distanceAbs) / self.frame.size.width;
    self.alpha = distanceRate;
    
    _offsetRate = 1 -distanceRate;
    
    if (distance >= 0) {
        self.transform = CGAffineTransformMakeRotation(-_offsetRate * kRotationRadian);
    }else
        self.transform = CGAffineTransformMakeRotation(_offsetRate * kRotationRadian);
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
}

@end
