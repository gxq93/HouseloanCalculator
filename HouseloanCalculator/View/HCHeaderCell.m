//
//  HCHeaderCell.m
//  HouseloanCalculator
//
//  Created by GuYi on 16/8/26.
//  Copyright © 2016年 aicai. All rights reserved.
//

#import "HCHeaderCell.h"
#import "HCCalculatorManager.h"

@implementation HCHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)configCellContentWithRACTuple:(RACTuple *)tuple withType:(LoanType)type {
    
    if ([tuple.first integerValue]==1) {
        self.titleLabel.text = @"最高月供(元)";
    }
    else {
        self.titleLabel.text = @"每月月供(元)";
    }
    
    switch (type) {
        case commercialLoan:
            self.rateLabel.text = [NSString stringWithFormat:@"%ld",(long)[[HCCalculatorManager sharedInstance]getCommercialLoanMonthlyInstallmentPaymentWithRACTuple:tuple]];
            self.decreaseLabel.text = [NSString stringWithFormat:@"%ld",(long)[[HCCalculatorManager sharedInstance]getCommercialLoanMonthlyDecreaseWithRACTuple:tuple]];
            self.interestLabel.text = [NSString stringWithFormat:@"%ld",(long)[[HCCalculatorManager sharedInstance]getCommercialLoanInterestsWithRACTuple:tuple]];
            self.totalLabel.text = [NSString stringWithFormat:@"%ld",(long)[[HCCalculatorManager sharedInstance]getCommercialLoanPaymentAmountWithRACTuple:tuple]];
            break;
        case housingProvidentFundLoan:
            self.rateLabel.text = [NSString stringWithFormat:@"%ld",(long)[[HCCalculatorManager sharedInstance]getHousingProvidentFundLoanMonthlyInstallmentPaymentWithRACTuple:tuple]];
            self.decreaseLabel.text = [NSString stringWithFormat:@"%ld",(long)[[HCCalculatorManager sharedInstance]getHousingProvidentFundLoanMonthlyDecreaseWithRACTuple:tuple]];
            self.interestLabel.text = [NSString stringWithFormat:@"%ld",(long)[[HCCalculatorManager sharedInstance]getHousingProvidentFundLoanInterestsWithRACTuple:tuple]];
            self.totalLabel.text = [NSString stringWithFormat:@"%ld",(long)[[HCCalculatorManager sharedInstance]getHousingProvidentFundLoanPaymentAmountWithRACTuple:tuple]];
            break;
        case mixLoan:
            self.rateLabel.text = [NSString stringWithFormat:@"%ld",(long)[[HCCalculatorManager sharedInstance]getMixLoanMonthlyInstallmentPaymentWithRACTuple:tuple]];
            self.decreaseLabel.text = [NSString stringWithFormat:@"%ld",(long)[[HCCalculatorManager sharedInstance]getMixLoanMonthlyDecreaseWithRACTuple:tuple]];
            self.interestLabel.text = [NSString stringWithFormat:@"%ld",(long)[[HCCalculatorManager sharedInstance]getMixLoanInterestsWithRACTuple:tuple]];
            self.totalLabel.text = [NSString stringWithFormat:@"%ld",(long)[[HCCalculatorManager sharedInstance]getMixLoanPaymentAmountWithRACTuple:tuple]];
            break;
    }
    
}



@end
