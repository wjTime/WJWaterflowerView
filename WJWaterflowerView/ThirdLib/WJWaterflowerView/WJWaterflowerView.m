//
//  WJWaterflowerView.m
//  WJWaterflowerView
//
//  Created by 高文杰 on 16/2/28.
//  Copyright © 2016年 高文杰. All rights reserved.
//

#import "WJWaterflowerView.h"
#import "WJWaterflowerViewCell.h"

#define DefaultCellH 60
#define DefaultMargin 10
#define DefaultNumberOfColumns 3

@interface WJWaterflowerView ()

@property (nonatomic,strong)NSMutableArray *cellFrames;
@property (nonatomic,strong)NSMutableDictionary *showingCells;
@property (nonatomic,strong)NSMutableSet *reusableCells;

@end

@implementation WJWaterflowerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

#pragma mark - 懒加载
- (NSMutableArray *)cellFrames{
    
    if (_cellFrames == nil) {
        _cellFrames = [NSMutableArray array];
    }
    return _cellFrames;
}

- (NSMutableDictionary *)showingCells{
    if (_showingCells == nil) {
        _showingCells = [NSMutableDictionary dictionary];
    }
    return _showingCells;
}

- (NSMutableSet *)reusableCells{
    if (_reusableCells == nil) {
        _reusableCells = [NSMutableSet set];
    }
    return _reusableCells;
}


/**
 * 刷新数据
 */
- (void)reloadData{
    
    // cell的总数
    NSUInteger numberOfCells = [self.dataSource numberOfCellsInWaterflowerView:self];
    
    // cell的列数
    NSUInteger numberOfColumns = [self.dataSource respondsToSelector:@selector(numberOfColumnsInWaterflowerView:)] ? [self.dataSource numberOfColumnsInWaterflowerView:self] : DefaultNumberOfColumns;
    
    // 间距
    
    CGFloat topM = [self.delegate respondsToSelector:@selector(waterflowerView:marginForType:)] ? [self.delegate waterflowerView:self marginForType:WJWaterflowerViewMarginTypeTop] : DefaultMargin;
    CGFloat bottomM = [self.delegate respondsToSelector:@selector(waterflowerView:marginForType:)] ? [self.delegate waterflowerView:self marginForType:WJWaterflowerViewMarginTypeBottom] : DefaultMargin;
    CGFloat leftM = [self.delegate respondsToSelector:@selector(waterflowerView:marginForType:)] ? [self.delegate waterflowerView:self marginForType:WJWaterflowerViewMarginTypeLeft] : DefaultMargin;
    CGFloat rightM = [self.delegate respondsToSelector:@selector(waterflowerView:marginForType:)] ? [self.delegate waterflowerView:self marginForType:WJWaterflowerViewMarginTypeRight] : DefaultMargin;
    CGFloat columnM = [self.delegate respondsToSelector:@selector(waterflowerView:marginForType:)] ? [self.delegate waterflowerView:self marginForType:WJWaterflowerViewMarginTypeCulomn] : DefaultMargin;
    CGFloat rowM = [self.delegate respondsToSelector:@selector(waterflowerView:marginForType:)] ? [self.delegate waterflowerView:self marginForType:WJWaterflowerViewMarginTypeRow] : DefaultMargin;
    
    // cell的宽度
    CGFloat cellW = (self.bounds.size.width - leftM - rightM - columnM * (numberOfColumns - 1))/numberOfColumns;
    
    // 用数组存放所有列的最大值
    NSMutableArray *maxYOfColumnArr = [NSMutableArray array];
    for (int i = 0; i < numberOfColumns; i++) {
        [maxYOfColumnArr addObject:@"0"];
    }

    // 计算每个cell的frame
    for (int i = 0; i < numberOfCells; i++) {
        
        // 当前列
        NSUInteger currentColumn = 0;
        
        // 列最大Y值
        CGFloat maxYOfCellColumn = [maxYOfColumnArr[0] floatValue];
        
        for (int j = 1; j < numberOfColumns; j++) {
            
            if ([maxYOfColumnArr[j] floatValue] < maxYOfCellColumn) {
                currentColumn = j;
                maxYOfCellColumn = [maxYOfColumnArr[j] floatValue];
            }
            
        }
        
        // i位置的高度
        CGFloat cellH = [self.delegate respondsToSelector:@selector(waterflowerView:heightAtIndex:)] ? [self.delegate waterflowerView:self heightAtIndex:i] : DefaultCellH;
        CGFloat cellY = 0.0;
        // cell的位置
        if (maxYOfCellColumn == 0.0) {
            cellY = topM;
        }else{
            cellY = maxYOfCellColumn + rowM;
        }
        
        CGFloat cellX = leftM + (cellW + columnM) * currentColumn;
        
        // cell的frame加入数组中
        CGRect cellFrame = CGRectMake(cellX, cellY, cellW, cellH);
        [self.cellFrames addObject:[NSValue valueWithCGRect:cellFrame]];
        
        // 更新maxYOfColumnArr
        [maxYOfColumnArr replaceObjectAtIndex:currentColumn withObject:[NSString stringWithFormat:@"%lf",CGRectGetMaxY(cellFrame)]];
    }
    
    // 设置contentSize
    CGFloat contentH = [maxYOfColumnArr[0] floatValue];
    
    for (int j = 0; j < numberOfColumns; j++) {
        if (contentH < [maxYOfColumnArr[j] floatValue]) {
            contentH = [maxYOfColumnArr[j] floatValue];
        }
    }
    
    contentH += bottomM;
    self.contentSize = CGSizeMake(0, contentH);
    
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    NSUInteger numberOfCells = self.cellFrames.count;
    for (int i = 0; i < numberOfCells; i++) {
        
        CGRect cellFrame = [self.cellFrames[i] CGRectValue];
        WJWaterflowerViewCell *cell = self.showingCells[@(i)];
        
        if ([self isInscreen:cellFrame]) {
    
            if (cell == nil) {
                cell = [self.dataSource waterflowerView:self cellAtIndex:i];
                cell.frame = cellFrame;
                cell.backgroundColor = [UIColor redColor];
                [self addSubview:cell];
                self.showingCells[@(i)] = cell;
            }
           
        }else{
            if (cell) {
                [self.reusableCells addObject:cell];
                [cell removeFromSuperview];
                [self.showingCells removeObjectForKey:@(i)];
                cell = nil;
            }
      
        }
        
        
    }
}
/**
 * 判断是否在屏幕上
 */
- (BOOL)isInscreen:(CGRect)frame{
    return (CGRectGetMaxY(frame) > self.contentOffset.y) && (CGRectGetMinY(frame) < self.contentOffset.y + self.frame.size.height);
}

/**
 * 根据表示去缓存池查找可循环利用的cell
 */
- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier{
    
    __block WJWaterflowerViewCell *reusableCell = nil;
    
    [self.reusableCells enumerateObjectsUsingBlock:^(WJWaterflowerViewCell *cell, BOOL *stop) {
        if ([cell.identifier isEqualToString:identifier]) {
            reusableCell = cell;
            *stop = YES;
        }
    }];
    
    if (reusableCell) {
        [self.reusableCells removeObject:reusableCell];
    }
    
    return reusableCell;
    
}
- (CGFloat)cellWidth{
    NSUInteger numberOfColumns = [self.dataSource respondsToSelector:@selector(numberOfColumnsInWaterflowerView:)] ? [self.dataSource numberOfColumnsInWaterflowerView:self] : DefaultNumberOfColumns;
    CGFloat leftM = [self.delegate respondsToSelector:@selector(waterflowerView:marginForType:)] ? [self.delegate waterflowerView:self marginForType:WJWaterflowerViewMarginTypeLeft] : DefaultMargin;
    CGFloat rightM = [self.delegate respondsToSelector:@selector(waterflowerView:marginForType:)] ? [self.delegate waterflowerView:self marginForType:WJWaterflowerViewMarginTypeRight] : DefaultMargin;
    CGFloat columnM = [self.delegate respondsToSelector:@selector(waterflowerView:marginForType:)] ? [self.delegate waterflowerView:self marginForType:WJWaterflowerViewMarginTypeCulomn] : DefaultMargin;
    return (self.bounds.size.width - leftM - rightM - (numberOfColumns - 1) * columnM) / numberOfColumns;
}

/**
 * 第一次出现时刷新数据
 */
- (void)willMoveToSuperview:(UIView *)newSuperview{
    [self reloadData];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (![self.delegate respondsToSelector:@selector(waterflowerView:didSelectedAtIndex:)]) return;
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    __block NSNumber *selectIndex = nil;
    [self.showingCells enumerateKeysAndObjectsUsingBlock:^(id key, WJWaterflowerViewCell *cell, BOOL *stop) {
        if (CGRectContainsPoint(cell.frame, point)) {
            selectIndex = key;
            *stop = YES;
        }
    }];
    if (selectIndex) {
        [self.delegate waterflowerView:self didSelectedAtIndex:selectIndex.unsignedIntegerValue];
    }
}

@end
