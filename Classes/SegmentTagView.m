//
//  SegmentTagView.m
//  FortuneTelling
//
//  Created by 刘鹏i on 2019/1/10.
//  Copyright © 2019 wuhan.musjoy. All rights reserved.
//

#import "SegmentTagView.h"

@interface SegmentTagView ()
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIStackView *stackView;

// 滑块视图
@property (strong, nonatomic) IBOutlet UIView *sliderView;  ///< 底部滑块
@property (strong, nonatomic) NSLayoutConstraint *lytSliderWidth;  ///< 滑块宽度约束
@property (strong, nonatomic) NSLayoutConstraint *lytSliderLeading;///< 滑块左边约束

@property (nonatomic, strong) NSMutableArray *arrBtns;      ///< 按钮数组
@end

@implementation SegmentTagView
#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadViewFromXib];
        [self viewConfig];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self loadViewFromXib];
    }
    return self;
}

- (void)loadViewFromXib
{
    UIView *contentView = [[NSBundle bundleForClass:[self class]] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].firstObject;
    contentView.frame = self.bounds;
    contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth| UIViewAutoresizingFlexibleHeight;
    [self addSubview:contentView];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self viewConfig];
}

#pragma mark - Subjoin
- (void)viewConfig
{

    // 默认值
    
    // 默认颜色
    _nomarlColor = [UIColor blackColor];
    
    // 选中颜色
    _selectColor = [UIColor yellowColor];
    _sliderView.backgroundColor = _selectColor;
    
    // 标题字体大小
    _titleFont = [UIFont systemFontOfSize:17.0];
    
    // 最小间距
    _minSpace = 10.0;
    _stackView.spacing = _minSpace;
    
    // 占父视图宽度的最小比例
    _minWidthProportion = 0.15;
    // 占父视图宽度的最大比例
    _maxWidthProportion = 0.5;
}

#pragma mark - Private
/// 创建按钮
- (void)createButtons
{
    // 先移除
    for (UIButton *btn in _arrBtns) {
        [btn removeFromSuperview];
    }
    
    // 新建
    _arrBtns = [NSMutableArray arrayWithCapacity:_arrTitle.count];
    for (NSInteger i = 0; i < _arrTitle.count; i++) {
        NSString *title = _arrTitle[i];
        
        UIButton *btn = [[UIButton alloc] init];
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:_nomarlColor forState:UIControlStateNormal];
        [btn setTitleColor:_selectColor forState:UIControlStateSelected];
        [btn setTintColor:[UIColor clearColor]];
        btn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        btn.titleLabel.font = _titleFont;
        [btn addTarget:self action:@selector(clickedButton:) forControlEvents:UIControlEventTouchUpInside];
        [_arrBtns addObject:btn];
        
        [_stackView insertArrangedSubview:btn atIndex:_stackView.subviews.count - 1];
    }
    
    // 更新按钮宽度约束
    [self updateBtnsConstraint];
}

// 更新按钮宽度约束
- (void)updateBtnsConstraint
{
    // 先移除旧的约束
    for (UIButton *btn in _arrBtns) {
        [btn removeConstraints:btn.constraints];
    }

    // 添加约束
    for (UIButton *btn in _arrBtns) {
        NSLayoutConstraint *minWidth = [NSLayoutConstraint constraintWithItem:btn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:_scrollView attribute:NSLayoutAttributeWidth multiplier:_minWidthProportion constant:0];
        NSLayoutConstraint *maxWidth = [NSLayoutConstraint constraintWithItem:btn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationLessThanOrEqual toItem:_scrollView attribute:NSLayoutAttributeWidth multiplier:_maxWidthProportion constant:0];
        NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:btn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_scrollView attribute:NSLayoutAttributeWidth multiplier:_minWidthProportion constant:0];
        width.priority = 900;
        [btn setContentCompressionResistancePriority:990 forAxis:UILayoutConstraintAxisHorizontal];
        [_scrollView addConstraints:@[minWidth, maxWidth, width]];
    }

    [self setNeedsLayout];
    [self layoutIfNeeded];
}

/// 选择按钮
- (void)selectIndex:(NSInteger)index animation:(BOOL)animation
{
    if (index < 0 || index >= _arrBtns.count) {
        return;
    }
    
    UIButton *btn = _arrBtns[index];
    
    // 偏移范围 0 ~ maxOffset
    CGFloat maxOffset = _scrollView.contentSize.width - self.bounds.size.width;
    // 当前中心点
    CGPoint center = [btn.superview convertPoint:btn.center toView:self];
    // 预计移动距离
    CGFloat offset = center.x - self.bounds.size.width / 2.0;
    // 偏移修正，不能超过偏移范围
    if (_scrollView.contentOffset.x + offset < 0) {
        offset = 0 - _scrollView.contentOffset.x;
    } else if (_scrollView.contentOffset.x + offset > maxOffset) {
        offset = maxOffset - _scrollView.contentOffset.x;
    }
    
    // 修改选中状态
    for (UIButton *aBtn in _arrBtns) {
        aBtn.selected = aBtn == btn;
    }
    
    // 滑块先移动到对应位置
    if (_lytSliderLeading) {
        [_scrollView removeConstraint:_lytSliderLeading];
    }
    _lytSliderLeading = [NSLayoutConstraint constraintWithItem:_sliderView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:btn attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
    [_scrollView addConstraint:_lytSliderLeading];
    
    if (_lytSliderWidth) {
        [_scrollView removeConstraint:_lytSliderWidth];
    }
    _lytSliderWidth = [NSLayoutConstraint constraintWithItem:_sliderView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:btn attribute:NSLayoutAttributeWidth multiplier:1 constant:0];
    [_scrollView addConstraint:_lytSliderWidth];
    [self.scrollView setNeedsLayout];
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:(animation? 0.2: 0.0) animations:^{
        [weakSelf.scrollView layoutIfNeeded];
    } completion:^(BOOL finished) {
        // 然后和按钮一起移动到最终位置
        [UIView animateWithDuration:(animation? 0.35: 0.0) animations:^{
            weakSelf.scrollView.contentOffset = CGPointMake(weakSelf.scrollView.contentOffset.x + offset, 0);
        }];
    }];
    
    // 回调
    if (animation) {
        if (_selectIndexBlock) {
            _selectIndexBlock(_currentIndex);
        }
    }
}

#pragma mark - Action
/// 点击按钮
- (void)clickedButton:(UIButton *)btn
{
    NSInteger index = [_arrBtns indexOfObject:btn];
    if (index != NSNotFound) {
        _currentIndex = index;
        
        [self selectIndex:index animation:YES];
    }
}

#pragma mark - Set & Get
- (void)setNomarlColor:(UIColor *)nomarlColor
{
    _nomarlColor = nomarlColor;
    
    for (UIButton *btn in _arrBtns) {
        [btn setTitleColor:nomarlColor forState:UIControlStateNormal];
    }
}

- (void)setSelectColor:(UIColor *)selectColor
{
    _selectColor = selectColor;
    
    for (UIButton *btn in _arrBtns) {
        [btn setTitleColor:selectColor forState:UIControlStateSelected];
    }
}

- (void)setArrTitle:(NSArray *)arrTitle
{
    _arrTitle = arrTitle;
    
    [self createButtons];
    // 不带动画更新
    [self selectIndex:0 animation:NO];
}

- (void)setMinSpace:(CGFloat)minSpace
{
    if (minSpace < 0) {
        return;
    }
    
    _minSpace = minSpace;
    _stackView.spacing = minSpace;
}

- (void)setMinWidthProportion:(CGFloat)minWidthProportion
{
    if (minWidthProportion <= 0 || minWidthProportion >= 1) {
        return;
    }
    
    _minWidthProportion = minWidthProportion;
    
    // 更新按钮宽度约束
    [self updateBtnsConstraint];
}

- (void)setMaxWidthProportion:(CGFloat)maxWidthProportion
{
    if (maxWidthProportion <= 0 || maxWidthProportion >= 1) {
        return;
    }
    
    _maxWidthProportion = maxWidthProportion;
    
    // 更新按钮宽度约束
    [self updateBtnsConstraint];
}

- (void)setCurrentIndex:(NSInteger)currentIndex
{
    if (currentIndex >= _arrBtns.count || currentIndex < 0) {
        return;
    }
    
    _currentIndex = currentIndex;
    
    [self selectIndex:currentIndex animation:YES];
}

- (void)setPreviewText:(NSString *)previewText
{
    _previewText = previewText;
    
    // 预览文案
    if (_previewText.length > 0) {
        self.arrTitle = @[_previewText, _previewText, _previewText, _previewText, _previewText, _previewText];
    }
}

@end
