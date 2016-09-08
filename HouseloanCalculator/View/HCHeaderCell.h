//
//  HCHeaderCell.h
//  HouseloanCalculator
//
//  Created by GuYi on 16/8/26.
//  Copyright © 2016年 aicai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HCHeaderCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *rateLabel;
@property (strong, nonatomic) IBOutlet UILabel *decreaseLabel;
@property (strong, nonatomic) IBOutlet UILabel *interestLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalLabel;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

- (void)configCellContentWithRACTuple:(RACTuple *)tuple withType:(LoanType)type;

@end
