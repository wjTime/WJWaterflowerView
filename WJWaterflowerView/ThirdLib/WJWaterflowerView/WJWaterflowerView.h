//
//  WJWaterflowerView.h
//  WJWaterflowerView
//
//  Created by 高文杰 on 16/2/28.
//  Copyright © 2016年 高文杰. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum{
    
    WJWaterflowerViewMarginTypeTop,
    WJWaterflowerViewMarginTypeBottom,
    WJWaterflowerViewMarginTypeLeft,
    WJWaterflowerViewMarginTypeRight,
    WJWaterflowerViewMarginTypeCulomn,
    WJWaterflowerViewMarginTypeRow,
    
} WJWaterflowerViewMarginType;


@class WJWaterflowerViewCell,WJWaterflowerView;

#pragma mark - dataSource代理方法
@protocol WJWaterflowerViewDataSource <NSObject>

@required
/**
 * 返回多少组数据
 */
- (NSUInteger)numberOfCellsInWaterflowerView:(WJWaterflowerView *)waterflowerView;

/**
 * 返回的cell
 */
- (WJWaterflowerViewCell *)waterflowerView:(WJWaterflowerView *)waterflowerView cellAtIndex:(NSUInteger)index;

@optional

/**
 * 返回多少列
 */
- (NSUInteger)numberOfColumnsInWaterflowerView:(WJWaterflowerView *)waterflowerView;

@end

#pragma mark - waterflowerView的代理方法
@protocol WJWaterflowerViewDelegate <UIScrollViewDelegate>

@optional

/**
 * 返回对应index的cell的高度
 */
- (CGFloat)waterflowerView:(WJWaterflowerView *)waterflowerView heightAtIndex:(NSUInteger)index;

/**
 * 返回对应间距类型的高度
 */
- (CGFloat)waterflowerView:(WJWaterflowerView *)waterflowerView marginForType:(WJWaterflowerViewMarginType)type;


/**
 * 点击index对应的cell
 */
- (void)waterflowerView:(WJWaterflowerView *)waterflowerView didSelectedAtIndex:(NSUInteger)index;


@end



@interface WJWaterflowerView : UIScrollView<WJWaterflowerViewDelegate>

@property (nonatomic,weak) id<WJWaterflowerViewDataSource> dataSource;
@property (nonatomic,weak) id<WJWaterflowerViewDelegate> delegate;

/**
 *  cell的宽度
 */
- (CGFloat)cellWidth;

/**
 * 刷新方法
 */
- (void)reloadData;

/**
 * 根据表示去缓存池查找可循环利用的cell
 */
- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier;


@end
