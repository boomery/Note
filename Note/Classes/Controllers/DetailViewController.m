//
//  DetailViewController.m
//  Note
//
//  Created by ZhangChaoxin on 15/8/17.
//  Copyright (c) 2015年 ZhangChaoxin. All rights reserved.
//

#import "DetailViewController.h"
#import "Note+Addition.h"
@interface DetailViewController ()
@property (nonatomic, strong) UITextView *textView;
@end

@implementation DetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNav];
    [self initUI];
}
- (void)initUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    UITextView *textView = [[UITextView alloc] initForAutoLayout];
//    textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    textView.layer.borderWidth = 1;
    [self.view addSubview:textView];
    [textView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    textView.font = [UIFont systemFontOfSize:16];
    textView.text = self.note.content;
    self.textView = textView;
}
- (void)setNav
{
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(save)];
    self.navigationItem.rightBarButtonItem = rightItem;
}
- (void)save
{
    self.note.content = self.textView.text;
    [Note updateForNote:self.note];
    if (self.saveBlock)
    {
        self.saveBlock();
        [self.navigationController popViewControllerAnimated:YES];
    }
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
