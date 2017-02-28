//
//  SettingViewController.m
//  Note
//
//  Created by ZhangChaoxin on 15/9/9.
//  Copyright (c) 2015年 ZhangChaoxin. All rights reserved.
//

#import "SettingViewController.h"
#import <MessageUI/MessageUI.h>
#import <Social/Social.h>
@interface SettingViewController () <UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate>

@end

@implementation SettingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initUI];
}

- (void)initUI
{
    UITableView *tableView = [[UITableView alloc] initForAutoLayout];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    [tableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    tableView.delegate = self;
    tableView.dataSource = self;
}

- (void)cacel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        UIView *lineView = [[UIView alloc] initForAutoLayout];
        [cell addSubview:lineView];
        [lineView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:cell withOffset:12];
        [lineView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:cell];
        [lineView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:cell];
        [lineView autoSetDimension:ALDimensionHeight toSize:LINE_HEIGTH];
        lineView.backgroundColor = THEME_COLOR;
    }
    switch (indexPath.row)
    {
        case 0:
        {
            cell.textLabel.text = @"分享给好友";
        }
            break;
        case 1:
        {
            cell.textLabel.text = @"我要评论";
        }
            break;
        case 2:
        {
            cell.textLabel.text = @"意见反馈";
        }
            break;
        default:
            break;
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row)
    {
        case 0:
        {
            UIActivity *activity = [[UIActivity alloc] init];
         
            UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:@[] applicationActivities:nil];
            [self presentViewController:controller animated:YES completion:nil];
            
        }
            break;
        case 1:
        {
        }
            break;
        case 2:
        {
            if ([MFMailComposeViewController canSendMail])
            {
                MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
                controller.mailComposeDelegate = self;
                [controller setToRecipients:@[@"765007045@qq.com"]];
                [controller setSubject:@"意见反馈"];
                [controller setMessageBody:@"我要说：" isHTML:NO];
                [self presentViewController:controller animated:YES completion:nil];
            }
            else
            {
                
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - MFMailComposeViewControllerDelegate
/**
 MFMailComposeResultCancelled,      取消
 MFMailComposeResultSaved,          保存邮件
 MFMailComposeResultSent,           已经发送
 MFMailComposeResultFailed          发送失败
 */
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    // 根据不同状态提示用户
    NSLog(@"%d", result);
    switch (result)
    {
        case MFMailComposeResultFailed:
        {
            [DataHander showInfoWithTitle:[NSString stringWithFormat:@"邮件发送失败，因为:%@",error]];
        }
            break;
        case MFMailComposeResultSent:
        {
            [DataHander showInfoWithTitle:@"邮件发送成功，我会尽快给您反馈"];
        }
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
