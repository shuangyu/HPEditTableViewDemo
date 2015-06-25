//
//  ViewController.m
//  UITableViewDemo
//
//  Created by hupeng on 14-10-10.
//  Copyright (c) 2014年 hupeng. All rights reserved.
//

#import "ViewController.h"
#import "HPEditCell.h"

@interface ViewController () <UITabBarDelegate, UITableViewDataSource, HPCallBackProtocol>

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HPEditCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.delegate  = self;
    cell.tableView = tableView;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld", indexPath.row);
}

#pragma mark - HPCallBackProtocol

- (void)obj:(id)obj respondsToAction:(id)actionInfo
{
    NSLog(@"%@", actionInfo);
}


@end
