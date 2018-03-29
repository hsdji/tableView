//
//  ViewController.m
//  tableView下拉列表
//
//  Created by 单小飞 on 2018/3/29.
//  Copyright © 2018年 单小飞. All rights reserved.
//

#import "ViewController.h"
#import "pulltableViewCell.h"
#import "headView.h"

#define RGBSixteenColor(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define RGBColor(_R_,_G_,_B_,_alpha_) [UIColor colorWithRed:_R_/255.0 green:_G_/255.0 blue:_B_/255.0 alpha:_alpha_]

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

/**       列表  */
@property (nonatomic,strong) UITableView *tableView;;

/**       sectionArr  */
@property (nonatomic,strong) NSMutableArray *sectionDasouceArr;

/**       rowArr  */
@property (nonatomic,strong) NSMutableArray <NSMutableArray *>*rowDataSouceArr;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
}

#pragma mark ---- LazyLoad-----
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
        [_tableView registerClass:[pulltableViewCell class] forCellReuseIdentifier:@"cell"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView= [UIView new];
        _tableView.backgroundColor = RGBColor(237, 237, 237, 1.0);
    }
    return _tableView;
}

-(NSMutableArray *)sectionDasouceArr
{
    if (!_sectionDasouceArr) {
        _sectionDasouceArr = [[NSMutableArray alloc] init];
        [_sectionDasouceArr addObject:@{@"title":@"微信付",@"isOPen":@"0"}];
        [_sectionDasouceArr addObject:@{@"title":@"支付宝",@"isOPen":@"0"}];
        [_sectionDasouceArr addObject:@{@"title":@"京东卡",@"isOPen":@"0"}];
        [_sectionDasouceArr addObject:@{@"title":@"银行卡",@"isOPen":@"0"}];
        [_sectionDasouceArr addObject:@{@"title":@"一网通",@"isOPen":@"0"}];
        [_sectionDasouceArr addObject:@{@"title":@"苏宁卡",@"isOPen":@"0"}];
    }
    return _sectionDasouceArr;
}

-(NSMutableArray *)rowDataSouceArr{
    if (!_rowDataSouceArr) {
        _rowDataSouceArr = [[NSMutableArray alloc] init];
        
        for (int i =0; i<self.sectionDasouceArr.count; i++) {
            NSMutableArray *arr = [NSMutableArray new];
            int num = rand()%20;
            for (int i =0; i<num; i++) {
                [arr addObject:[NSString stringWithFormat:@"第%d公交车分公司",i]];
            }
            [_rowDataSouceArr addObject:arr];
        }
    }
    return _rowDataSouceArr;
}

#pragma mark ----   tableViewdeleagte&tableViewDateSouce
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.sectionDasouceArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *isOpen = [self.sectionDasouceArr[section] valueForKey:@"isOPen"]; 
    if ([isOpen isEqualToString:@"0"]) {
        return 0;
    }else{
        return 1;
    }
}
//根据——rowArr计算返回高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([[self.sectionDasouceArr[indexPath.section] valueForKey:@"isOPen"] isEqual:@"0"]?0:1) {
        NSArray *tmpArr = self.rowDataSouceArr[indexPath.section];
        if (tmpArr.count) {
            NSInteger num = tmpArr.count;
            NSInteger chu = num/2;
            NSInteger yuuuu = num%2;
            if (yuuuu == 0) {//整数行
                
                return chu *54+10;
            }else{//有余数
                
                return (chu +1)*54+10;
            }
        }
        return 0;
    }else
        return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    pulltableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[pulltableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    cell.souceArr = self.rowDataSouceArr[indexPath.section];
    cell.section = indexPath.section;
    [cell clickEvents:^(NSInteger section, NSInteger row) {
        NSLog(@"section:%ld------row:%ld",section,row);
    }];
    
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    headView *v = [headView headViewWithTableView:self.tableView];
     v.backgroundColor = [UIColor whiteColor];
    v.title = [self.sectionDasouceArr[section] valueForKey:@"title"];
    v.scetion = section;
    v.isOpen = [[self.sectionDasouceArr[section] valueForKey:@"isOPen"] isEqualToString:@"0"]?NO:YES;
    [v click:^(NSInteger index) {
        for (int i =0; i<_sectionDasouceArr.count; i++) {
            if (i == section) {
                NSDictionary *dic = _sectionDasouceArr[i];
                if ([[dic valueForKey:@"isOPen"]isEqual:@"0"]) {
                    [self.sectionDasouceArr replaceObjectAtIndex:i withObject:@{@"title":[dic valueForKey:@"title"],@"isOPen":@"1"}];
                    
                    
                }else{
                    [self.sectionDasouceArr replaceObjectAtIndex:i withObject:@{@"title":[dic valueForKey:@"title"],@"isOPen":@"0"}];
                }
                
                [self.tableView reloadData];
                
            }
        }
    }];
    return v;
}


@end
