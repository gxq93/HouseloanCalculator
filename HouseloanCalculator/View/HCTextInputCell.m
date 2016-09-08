//
//  HCTextInputCell.m
//  HouseloanCalculator
//
//  Created by GuYi on 16/8/29.
//  Copyright © 2016年 aicai. All rights reserved.
//

#import "HCTextInputCell.h"

@implementation HCTextInputCell

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
    // Initialization code
}

- (void)setupUI {
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 200, 44)];
    _titleLabel.textColor = UIColorFromRGB(0x333333);
    _titleLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:_titleLabel];
    
    _textInput = [[UITextField alloc]initWithFrame:CGRectMake(kScreen_W-15-130, 7, 130, 30)];
    _textInput.font = [UIFont systemFontOfSize:14];
    _textInput.textColor = UIColorFromRGB(0x999999);
    _textInput.textAlignment = NSTextAlignmentRight;
    _textInput.placeholder = @"请输入金额";
    _textInput.keyboardType = UIKeyboardTypeNumberPad;
    [self addSubview:_textInput];
}


@end
