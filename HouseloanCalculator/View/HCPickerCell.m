//
//  HCPickerCell.m
//  HouseloanCalculator
//
//  Created by GuYi on 16/8/29.
//  Copyright © 2016年 aicai. All rights reserved.
//

#import "HCPickerCell.h"

@implementation HCPickerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUIwithreuseIdentifier:reuseIdentifier];
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setupUIwithreuseIdentifier:(NSString *)reuseIdentifier {
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 200, 44)];
    _titleLabel.font = [UIFont systemFontOfSize:14];
    _titleLabel.textColor = UIColorFromRGB(0x333333);
    [self addSubview:_titleLabel];
    
    _rateLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreen_W-15-150, 7, 130, 30)];
    _rateLabel.font = [UIFont systemFontOfSize:14];
    _rateLabel.textColor = UIColorFromRGB(0x999999);
    _rateLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:_rateLabel];
    
    if ([reuseIdentifier isEqualToString:@"picker1"]) {
        _rateLabel.text = @"5";
    }
    else if ([reuseIdentifier isEqualToString:@"picker2"]) {
        _rateLabel.text = @"4.75";
    }
    else if ([reuseIdentifier isEqualToString:@"picker3"]) {
        _rateLabel.text = @"2.75";
    }
}


@end
