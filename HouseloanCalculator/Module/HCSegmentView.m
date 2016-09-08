//
//  HCSegmentView.m
//  HouseloanCalculator
//
//  Created by GuYi on 16/8/26.
//  Copyright © 2016年 aicai. All rights reserved.
//

#import "HCSegmentView.h" 

@interface HCSegmentView ()

@property(nonatomic,strong)NSArray *titleArray;
@property(nonatomic,strong)NSMutableArray *buttonArray;
@property(nonatomic,strong)UIView *lineView;

@end

@implementation HCSegmentView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupUI];
        
    }
    return self;
}

- (void)setupUI {
    
    self.backgroundColor = UIColorFromRGB(0xeeeeee);
    
    for (int i = 0; i < 3; i++) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(i*kScreen_W/3, 20, kScreen_W/3, 44)];
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        [button setTitle:self.titleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
        [self.buttonArray addObject:button];
        [self addSubview:button];
        
        //进行点击按钮后的相关配置，并将selectIndex发送出来
        button.rac_command = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
            @weakify(self)
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self)
                [self configSelectItemWithIndex:i];
                [subscriber sendNext:@(i)];
                [subscriber sendCompleted];
                return nil;
            }];
        }];
        //将三个按钮点击信号merge进行传递
        self.selectSignal = [self.selectSignal merge:button.rac_command.executionSignals.switchToLatest];
    }
    [self addSubview:self.lineView];
    

}

- (void)configSelectItemWithIndex:(NSInteger)index {

//不能使用array.rac_sequence.signal 也不能使用mainScheduler
    RACSignal *signal = [self.buttonArray.rac_sequence signalWithScheduler:[RACScheduler immediateScheduler]];
    [signal subscribeNext:^(UIButton *button) {
        [button setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
    }];
    UIButton *button = self.buttonArray[index];
    [button setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    
    [UIView animateWithDuration:.3 animations:^{
        [_lineView setCenter:CGPointMake(button.center.x, self.lineView.center.y)];
    }];
}


#pragma mark- getter
- (NSArray *)titleArray {
    return @[@"商业贷款",@"公积金贷款",@"组合贷款"];
}

- (RACSignal *)selectSignal {
    if (!_selectSignal) {
        _selectSignal = [RACSignal empty];
    }
    return _selectSignal;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 62, 75, 2)];
        _lineView.backgroundColor = UIColorFromRGB(0x55a9ff);
        UIButton *button = self.buttonArray[0];
        [_lineView setCenter:CGPointMake(button.center.x, _lineView.center.y)];
    }
    return _lineView;
}

- (NSMutableArray *)buttonArray {
    if (!_buttonArray) {
        _buttonArray = [[NSMutableArray alloc]init];
    }
    return _buttonArray;
}

#pragma mark- setter
- (void)setSelectIndex:(NSInteger)selectIndex {
    UIButton *button = self.buttonArray[selectIndex];
    [button setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    _selectIndex = selectIndex;
}

@end
