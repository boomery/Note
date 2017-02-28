//
//  NavViewController.m
//  Animation
//
//  Created by ZhangChaoxin on 15/8/19.
//  Copyright (c) 2015年 blue. All rights reserved.
//

#import "NavViewController.h"
#import "NavigationControllerDelegate.h"
@interface NavViewController ()
@property (nonatomic, strong) NavigationControllerDelegate *transitionDelegate;
@end

@implementation NavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _transitionDelegate = [[NavigationControllerDelegate alloc] initWithNavgationController:self];
    
    self.view.backgroundColor = [UIColor blueColor];
    // Do any additional setup after loading the view.
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
