//
//  SegmentTagView.h
//  FortuneTelling
//
//  Created by 刘鹏i on 2019/1/10.
//  Copyright © 2019 wuhan.musjoy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

IB_DESIGNABLE
@interface SegmentTagView : UIView
@property (nonatomic, strong) IBInspectable UIColor *nomarlColor;   ///< 普通颜色 （默认黑色）
@property (nonatomic, strong) IBInspectable UIColor *selectColor;   ///< 选中颜色 （默认黄色）
@property (nonatomic, strong) UIFont *titleFont;      ///< 标题字体大小 （默认17.0）

@property (nonatomic, assign) IBInspectable CGFloat minSpace;       ///< 最小间距 （默认10）
@property (nonatomic, assign) IBInspectable CGFloat minWidthProportion; ///< item占父视图宽度的最小比例
@property (nonatomic, assign) IBInspectable CGFloat maxWidthProportion; ///< item占父视图宽度的最大比例 

@property (nonatomic, copy) IBInspectable NSString *previewText; ///< 预览文案（当设置了标题数组时，会自动消失）

@property (nonatomic, strong) NSArray *arrTitle;    ///< 标题数组

@property (nonatomic, assign) NSInteger currentIndex;   ///< 当前序号
@property (nonatomic, copy) void(^selectIndexBlock)(NSInteger index); ///< 选中序号回调

@end

NS_ASSUME_NONNULL_END
