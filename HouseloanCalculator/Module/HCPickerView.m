//
//  HCPickerView.m
//  HouseloanCalculator
//
//  Created by GuYi on 16/8/26.
//  Copyright © 2016年 aicai. All rights reserved.
//

#import "HCPickerView.h"


@interface HCPickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property(nonatomic,strong)NSArray *titleArray;
@property(nonatomic,strong)UIPickerView *pickView;
@property(nonatomic,strong)UIView *maskView;
@property(nonatomic,strong)UIView *confirmView;
@property(nonatomic,strong)UIButton *confirmButton;
@property(nonatomic,strong)UIButton *cancelButton;
@property(nonatomic,strong)RACCommand *removeCommand;

@end

@implementation HCPickerView

- (instancetype)initWithFrame:(CGRect)frame withTitle:(NSArray *)title {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.titleArray = title;
        [self setupUI];
    }
    return self;
    
}

- (void)setupUI {
    
    [self addSubview:self.maskView];
    [self addSubview:self.confirmView];
    [self addSubview:self.pickView];
    
    _selectSignal = [self rac_signalForSelector:@selector(pickerView:didSelectRow:inComponent:) fromProtocol:@protocol(UIPickerViewDelegate)];
    self.pickView.delegate = self;
    self.pickView.dataSource = self;

}

#pragma mark- UIPickerViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.titleArray[row];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.titleArray.count;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 30;
}

#pragma mark- getter
- (UIPickerView *)pickView {
    if (!_pickView) {
        _pickView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, kScreen_H - 160, kScreen_W, 160)];
        _pickView.backgroundColor = [UIColor whiteColor];
    }
    return _pickView;
}

- (RACCommand *)removeCommand {
    if (!_removeCommand) {
        _removeCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
            @weakify(self)
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self);
                [self removeFromSuperview];
                [subscriber sendCompleted];
                return nil;
            }];
        }];
    }
    return _removeCommand;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 0, 50, 40)];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:UIColorFromRGB(0x55a9ff) forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:16];
        _cancelButton.rac_command = self.removeCommand;
    }
    return _cancelButton;
}

- (UIButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [[UIButton alloc]initWithFrame:CGRectMake(kScreen_W-60, 0, 50, 40)];
        [_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmButton setTitleColor:UIColorFromRGB(0x55a9ff) forState:UIControlStateNormal];
        _confirmButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        _confirmButton.rac_command = self.removeCommand;
    }
    return _confirmButton;
}

- (UIView *)confirmView {
    if (!_confirmView) {
        _confirmView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreen_H - 200, kScreen_W, 40)];
        _confirmView.backgroundColor = UIColorFromRGB(0xeeeeee);
        [_confirmView addSubview:self.confirmButton];
        [_confirmView addSubview:self.cancelButton];
    }
    return _confirmView;
}

- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_W, kScreen_H - 200)];
        _maskView.backgroundColor = [UIColor blackColor];
        _maskView.alpha = 0.3;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
        [tap.rac_gestureSignal subscribeNext:^(id x) {
            [self.removeCommand execute:nil];
        }];
        [_maskView addGestureRecognizer:tap];
    }
    return _maskView;
}
@end
