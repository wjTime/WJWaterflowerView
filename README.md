# WJWaterflowerView
a simple Waterflower view tool

@interface ViewController ()<WJWaterflowerViewDelegate,WJWaterflowerViewDataSource>
@property (nonatomic, strong) NSMutableArray *demoArr;
@property (nonatomic, weak) WJWaterflowerView *waterflowView;
@end

@implementation ViewController

// 懒加载数据源
- (NSMutableArray *)demoArr
{
    if (_demoArr == nil) {
        self.demoArr = [NSMutableArray array];
    }
    return _demoArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //  从plist里面加载数据
    [self.demoArr addObjectsFromArray:[DemoModel objectArrayWithFilename:@"demo.plist"]];
    
    //  创建瀑布流控件
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
