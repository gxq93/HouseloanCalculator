//
//  HCSegmentCell.m
//  HouseloanCalculator
//
//  Created by GuYi on 16/8/29.
//  Copyright © 2016年 aicai. All rights reserved.
//

#import "HCSegmentCell.h"

@implementation HCSegmentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setupUI {
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 200, 44)];
    _titleLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:_titleLabel];
    
    _segment = [[UISegmentedControl alloc]initWithItems:@[@"等额本息",@"等额本金"]];
    _segment.tintColor = UIColorFromRGB(0x55a9ff);
    _segment.frame = CGRectMake(kScreen_W-15-130, 7, 130, 30);
    [_segment setCenter:CGPointMake(_segment.center.x, self.center.y)];
    _segment.selectedSegmentIndex = 0;
    [self addSubview:_segment];
}

@end
