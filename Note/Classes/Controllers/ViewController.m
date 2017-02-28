//
//  ViewController.m
//  Note
//
//  Created by ZhangChaoxin on 15/8/14.
//  Copyright (c) 2015年 ZhangChaoxin. All rights reserved.
//

#import "ViewController.h"
#import "SlideDeleteCell.h"
#import "Note.h"
#import "Note+Addition.h"
#import "YIPopupTextView.h"
#import "NSString+HeightCaculator.h"
#import "DetailViewController.h"
#import "SettingViewController.h"
@interface ViewController () <UITableViewDataSource, UITableViewDelegate, SlideDeleteCellDelegate,YIPopupTextViewDelegate>
{
    BOOL _isEditting;
}
@property (nonatomic, strong) NSMutableArray *notesArray;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"记事本";
    self.notesArray = [Note notesArray];
    [self setNav];
    [self initUI];
}
- (void)setNav
{
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(setting)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewNote)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)clearNav
{
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)initUI
{
    UITableView *tableView = [[UITableView alloc] initForAutoLayout];
    [self.view addSubview:tableView];
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [tableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0); // Makes the horizontal row seperator stretch the entire length of the table view
    tableView.backgroundColor = [UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1];
    tableView.alpha = 0.8;
    tableView.rowHeight = 100;
    tableView.delegate = self;
    tableView.dataSource = self;
    self.tableView = tableView;
}

- (void)addNewNote
{
    [self clearNav];
    YIPopupTextView *text = [[YIPopupTextView alloc] initWithPlaceHolder:@"输入内容" maxCount:0 buttonStyle:YIPopupTextViewButtonStyleRightDone|YIPopupTextViewButtonStyleRightCancel doneButtonColor:[UIColor colorWithRed:0.31 green:0.6 blue:0.72 alpha:1]];
    text.outerBackgroundColor = [UIColor colorWithRed:1 green:0.73 blue:0.42 alpha:1];
    text.delegate = self;
    [text showInViewController:self];
}

- (void)setting
{
    SettingViewController *settingVC = [[SettingViewController alloc] init];
    [self.navigationController pushViewController:settingVC animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.notesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"noteCell";
    SlideDeleteCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell = [[SlideDeleteCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    Note *note = self.notesArray[indexPath.row];
    cell.note = note;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Note *note = self.notesArray[indexPath.row];
    return [NSString heightForDataStorageContent:note.content fontSize:17] + 60;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark - SlideDeleteCellDelegate
-(void)slideToDeleteCell:(SlideDeleteCell *)slideDeleteCell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:slideDeleteCell];
    Note *note = self.notesArray[indexPath.row];
    if ([Note deleteForNote:note])
    {
        [self.notesArray removeObject:note];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    [self.notesArray exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:destinationIndexPath.row];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Note *note = self.notesArray[indexPath.row];
    DetailViewController *detail = [[DetailViewController alloc] init];
    __weak ViewController *weakSelf = self;
    detail.saveBlock = ^{
        weakSelf.notesArray = [Note notesArray];
        [weakSelf.tableView reloadData];
    };
    detail.note = note;
    [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark - YIPopupTextViewDelegate
- (void)popupTextView:(YIPopupTextView*)textView willDismissWithText:(NSString*)text cancelled:(BOOL)cancelled
{
    [self setNav];
    if (!cancelled)
    {
        if (textView.text.length == 0)
        {
            return;
        }
        Note *note = [[Note alloc] init];
        note.content = textView.text;
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"YYYY-MM-dd HH:MM"];
        NSString *dateString = [formatter stringFromDate:[NSDate date]];
        note.insertTime = dateString;
        note.isActive = YES;
        
        [Note insertNote:note];
        [self.notesArray addObject:note];
        
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.notesArray count]-1  inSection:0]] withRowAnimation:UITableViewRowAnimationLeft];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
