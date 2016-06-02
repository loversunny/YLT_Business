//
//  BusGroupHeaderView.m
//  Business_List1.0
//
//  Created by 冀柳冲 on 16/6/2.
//  Copyright © 2016年 JLC. All rights reserved.
//

#import "BusGroupHeaderView.h"


@interface BusGroupHeaderView ()
@property (nonatomic, weak) UIButton *headerBtn;
@end


@implementation BusGroupHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+(instancetype)busGroupHeaderViewWithTableView:(UITableView *)tableView{
    static NSString *headerID = @"header";
    BusGroupHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerID];
    if (headerView == nil) {
        headerView = [[self alloc] initWithReuseIdentifier:headerID];
    }
    
    return headerView;
}

//重写
-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self addCustomHeaderView];
    }
    return self;
}

- (void)addCustomHeaderView{
    UIButton *headerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:headerBtn];
    self.headerBtn = headerBtn;
    [self.headerBtn setTitleColor:[UIColor blackColor] forState:0];
    [self.headerBtn setImage:[UIImage imageNamed:@"buddy_header_arrow"] forState:0];
    ///这是对齐方式
    self.headerBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    ///设置内边距
    self.headerBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    self.headerBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    //按钮的背景图片
    [self.headerBtn setBackgroundImage:[UIImage imageNamed:@"buddy_header_bg"] forState:0];
    [self.headerBtn setBackgroundImage:[UIImage imageNamed:@"buddy_header_bg_highlighted"] forState:1];
    self.headerBtn.imageView.contentMode = UIViewContentModeCenter;
    
    self.headerBtn.imageView.clipsToBounds = NO;
    [self.headerBtn addTarget:self action:@selector(headerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}


/// 按钮的监听事件
- (void)headerBtnClick:(UIButton *)sender {

    
    if (!self.groupModel.isExpend) {
        //没有展开
        self.headerBtn.imageView.transform = CGAffineTransformMakeRotation(0);
    }else {
        //展开
        self.headerBtn.imageView.transform = CGAffineTransformMakeRotation(M_PI_2);
    }
    
    if ([self.delegate respondsToSelector:@selector(busGroupViewDidClickBtn:)]) {
        
        [self.delegate busGroupViewDidClickBtn:self];
    }
}

- (void)busGroupViewDidClickBtn:(BusGroupHeaderView*)headerView{
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.headerBtn.frame = self.bounds;
    
}

-(void)setGroupModel:(BusinessGroupModel *)groupModel{
    _groupModel = groupModel;
    [self.headerBtn setTitle:groupModel.name forState:0];
    if (self.groupModel.isExpend) {
        self.headerBtn.imageView.transform = CGAffineTransformMakeRotation(M_PI_2);
    } else {
        self.headerBtn.imageView.transform = CGAffineTransformMakeRotation(0);
    }
}

@end
