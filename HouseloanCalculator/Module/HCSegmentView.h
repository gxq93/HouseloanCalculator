//
//  HCSegmentView.h
//  HouseloanCalculator
//
//  Created by GuYi on 16/8/26.
//  Copyright © 2016年 aicai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HCSegmentView : UIView

@property(nonatomic,strong)RACSignal *selectSignal;
@property(nonatomic,assign)NSInteger selectIndex;

@end
