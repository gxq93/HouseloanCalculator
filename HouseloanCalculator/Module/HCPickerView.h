//
//  HCPickerView.h
//  HouseloanCalculator
//
//  Created by GuYi on 16/8/26.
//  Copyright © 2016年 aicai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HCPickerView : UIView

@property(nonatomic,strong)RACSignal *selectSignal;

-(instancetype)initWithFrame:(CGRect)frame withTitle:(NSArray*)title;

@end
