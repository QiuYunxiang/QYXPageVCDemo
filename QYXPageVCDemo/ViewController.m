//
//  ViewController.m
//  QYXPageVCDemo
//
//  Created by 邱云翔 on 16/10/23.
//  Copyright © 2016年 邱云翔. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *myTableView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width - 8, self.view.bounds.size.height) style:(UITableViewStylePlain)];
    _myTableView.dataSource = self;
    [self.view addSubview:_myTableView];
    UIImageView *headerView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"111"]];
    headerView.frame = CGRectMake(0, 0,kScreenSize.width - 8, (kScreenSize.width - 8) / 19 * 9);
    _myTableView.tableHeaderView = headerView;
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"测试数据----%ld",indexPath.row];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
