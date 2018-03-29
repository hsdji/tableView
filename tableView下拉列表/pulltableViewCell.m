//
//  pulltableViewCell.m
//  tableView下拉列表
//
//  Created by 单小飞 on 2018/3/29.
//  Copyright © 2018年 单小飞. All rights reserved.
//

#import "pulltableViewCell.h"
#import "pullContentCollectionViewCell.h"
#import "Masonry.h"
#define KIntervalWidth  ([UIScreen mainScreen].bounds.size.width - 100*2)/3

@interface pulltableViewCell()<UICollectionViewDelegate,UICollectionViewDataSource>
/**       cllectionView  */
@property (nonatomic,strong) UICollectionView *collectionView;
@end

@implementation pulltableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpUI];
    }
    return self;
}

-(void)setUpUI{
    UICollectionViewFlowLayout *fowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    fowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    
    fowLayout.estimatedItemSize = CGSizeMake(([UIScreen mainScreen].bounds.size.width-100)/2.0, 44);
    
    fowLayout. minimumLineSpacing = 10;
    
    fowLayout.minimumInteritemSpacing = 10;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:fowLayout];
    
    _collectionView.backgroundColor = [UIColor whiteColor];
    
    _collectionView.delegate = self;
    
    _collectionView.dataSource = self;
    
//    _collectionView.userInteractionEnabled = NO;
    
    [_collectionView registerClass:[pullContentCollectionViewCell class] forCellWithReuseIdentifier:@"concell"];
    
    [self addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.top.bottom.mas_equalTo(self);
    }];
    
    
}

#pragma mark ----- LazyLoad -----


-(void)setSouceArr:(NSArray *)souceArr{
    _souceArr = souceArr;
    [self.collectionView reloadData];
}

#pragma mark --collectionView delagate&dasouce

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.souceArr.count;
}



-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    pullContentCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"concell" forIndexPath:indexPath];
    cell.title = self.souceArr[indexPath.row];

    return cell;
}

//设置每个item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(([UIScreen mainScreen].bounds.size.width-30)/2.0, 44);
}


//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}


//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.clickEvents(self.section,indexPath.row);
}

-(void)clickEvents:(clickEvents)clickEvents
{
    _clickEvents = clickEvents;
}
@end
