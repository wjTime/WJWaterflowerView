//
//  ViewController.m
//  WJWaterflowerView
//
//  Created by 高文杰 on 16/2/28.
//  Copyright © 2016年 高文杰. All rights reserved.
//

#import "ViewController.h"
#import "WJWaterflowerView.h"
#import "WJWaterflowerViewCell.h"
#import "DemoModel.h"
#import "DemoCell.h"
#import "MJExtension.h"

@interface ViewController ()<WJWaterflowerViewDelegate,WJWaterflowerViewDataSource>
@property (nonatomic, strong) NSMutableArray *demoArr;
@property (nonatomic, weak) WJWaterflowerView *waterflowView;
@end

@implementation ViewController

- (NSMutableArray *)demoArr
{
    if (_demoArr == nil) {
        self.demoArr = [NSMutableArray array];
    }
    return _demoArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.demoArr addObjectsFromArray:[DemoModel objectArrayWithFilename:@"demo.plist"]];
    
    
    WJWaterflowerView *waterflowerView = [[WJWaterflowerView alloc]init];
    waterflowerView.frame = self.view.bounds;
    waterflowerView.delegate = self;
    waterflowerView.dataSource = self;
    [self.view addSubview:waterflowerView];
    self.waterflowView = waterflowerView;
    

    
}

#pragma mark - dataSource 代理方法
- (NSUInteger)numberOfCellsInWaterflowerView:(WJWaterflowerView *)waterflowerView{
    return self.demoArr.count;
}
- (NSUInteger)numberOfColumnsInWaterflowerView:(WJWaterflowerView *)waterflowerView{
    return 3;
}
- (WJWaterflowerViewCell *)waterflowerView:(WJWaterflowerView *)waterflowerView cellAtIndex:(NSUInteger)index{
    
    DemoCell *cell = [DemoCell cellWithWaterflower:waterflowerView];
    cell.model = self.demoArr[index];
    return cell;
}


#pragma mark - WJWaterflowerView 代理方法
- (CGFloat)waterflowerView:(WJWaterflowerView *)waterflowerView heightAtIndex:(NSUInteger)index{
    
    DemoModel *model = self.demoArr[index];
    return waterflowerView.cellWidth * model.h / model.w;
    
}

- (CGFloat)waterflowerView:(WJWaterflowerView *)waterflowerView marginForType:(WJWaterflowerViewMarginType)type{
    switch (type) {
        case WJWaterflowerViewMarginTypeBottom:
        case WJWaterflowerViewMarginTypeLeft:
        case WJWaterflowerViewMarginTypeRight:
        case WJWaterflowerViewMarginTypeRow:
        case WJWaterflowerViewMarginTypeCulomn:
            return 10;
            break;
        default:return 20;
            break;
    }
}

- (void)waterflowerView:(WJWaterflowerView *)waterflowerView didSelectedAtIndex:(NSUInteger)index{
    NSLog(@"点击了第%ld个cell",index);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
