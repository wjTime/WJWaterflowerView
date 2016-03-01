//
//  DemoCell.h
//  WJWaterflowerView
//
//  Created by 吴计强 on 16/2/29.
//  Copyright © 2016年 高文杰. All rights reserved.
//

#import "WJWaterflowerViewCell.h"

@class WJWaterflowerView,DemoModel;

@interface DemoCell : WJWaterflowerViewCell

+ (instancetype)cellWithWaterflower:(WJWaterflowerView *)waterflowView;

@property (nonatomic,strong)DemoModel *model;

@end
