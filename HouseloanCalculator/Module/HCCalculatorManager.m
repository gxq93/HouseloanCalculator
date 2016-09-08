//
//  HCCalculatorManager.m
//  HouseloanCalculator
//
//  Created by GuYi on 16/8/31.
//  Copyright © 2016年 aicai. All rights reserved.
//

#import "HCCalculatorManager.h"

/**
 *  等额本息还款法:
 每月月供额=〔贷款本金×月利率×(1＋月利率)＾还款月数〕÷〔(1＋月利率)＾还款月数-1〕
 每月应还利息=贷款本金×月利率×〔(1+月利率)^还款月数-(1+月利率)^(还款月序号-1)〕÷〔(1+月利率)^还款月数-1〕
 每月应还本金=贷款本金×月利率×(1+月利率)^(还款月序号-1)÷〔(1+月利率)^还款月数-1〕
 总利息=还款月数×每月月供额-贷款本金
 
 等额本金还款法:
 每月月供额=(贷款本金÷还款月数)+(贷款本金-已归还本金累计额)×月利率
 每月应还本金=贷款本金÷还款月数
 每月应还利息=剩余本金×月利率=(贷款本金-已归还本金累计额)×月利率
 每月月供递减额=每月应还本金×月利率=贷款本金÷还款月数×月利率
 总利息=〔(总贷款额÷还款月数+总贷款额×月利率)+总贷款额÷还款月数×(1+月利率)〕÷2×还款月数-总贷款额
 说明:月利率=年利率÷12
 */


@implementation HCCalculatorManager

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

+ (HCCalculatorManager *)sharedInstance {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}


//等额本息每月月供
-(NSInteger)averageCapitalPlusInterestMonthlyInstallmentPaymentWithAmount:(NSInteger)amount period:(NSInteger)period rate:(float)rate {
    
    float monthlyRate = (rate / 100) / 12;
    NSInteger month = period * 12;
    NSInteger monthlyInstallmentPayment = (amount * 10000 * monthlyRate * pow((1 + monthlyRate), month)) / (pow((1 + monthlyRate), month)  - 1);
    return monthlyInstallmentPayment;
}

//等额本息总利息
-(NSInteger)averageCapitalPlusInterestWithAmount:(NSInteger)amount period:(NSInteger)period rate:(float)rate {
    
    NSInteger totalInterests = [self averageCapitalPlusInterestMonthlyInstallmentPaymentWithAmount:amount period:period rate:rate] * period * 12 - amount * 10000;
    return totalInterests;
}

//等额本息还款总额
-(NSInteger)averageCapitalPlusInterestTotalPaymentWithAmount:(NSInteger)amount period:(NSInteger)period rate:(float)rate {

    NSInteger totalPayment = [self averageCapitalPlusInterestWithAmount:amount period:period rate:rate];
    return totalPayment + amount * 10000;
}

//等额本金每月月供
-(NSInteger)averageCapitalMonthlyInstallmentPaymentWithAmount:(NSInteger)amount period:(NSInteger)period rate:(float)rate {
    
    float monthlyRate = (rate / 100) / 12;
    NSInteger month = period * 12;
    if (month == 0) {
        return 0;
    }
    NSInteger monthlyInstallmentPayment = (amount * 10000 / month) + amount * 10000 * monthlyRate;
    return monthlyInstallmentPayment;
}

//等额本金每月递减
-(NSInteger)averageCapitalDecreaseWithAmount:(NSInteger)amount period:(NSInteger)period rate:(float)rate {
    
    float monthlyRate = (rate / 100) / 12;
    NSInteger month = period * 12;
    if (month == 0) {
        return 0;
    }
    NSInteger decrease = amount * 10000 / month * monthlyRate;
    return decrease;
}

//等额本金总利息
-(NSInteger)averageCapitalInterestWithAmount:(NSInteger)amount period:(NSInteger)period rate:(float)rate {

    float monthlyRate = (rate / 100) / 12;
    NSInteger month = period * 12;
    if (month == 0) {
        return 0;
    }
    NSInteger interest = ((amount * 10000 / month + amount * 10000 * monthlyRate) + amount * 10000 / month * (1 + monthlyRate)) / 2 * month - amount * 10000;
    return interest;
}

//等额本金还款总额
-(NSInteger)averageCapitalTotalPaymentWithAmount:(NSInteger)amount period:(NSInteger)period rate:(float)rate {
    
    NSInteger totalPayment = [self averageCapitalInterestWithAmount:amount period:period rate:rate];
    return totalPayment + amount * 10000;
    
}

/**
 *
 *
 *  分情况计算
 *
 *
 */

/**商业贷款每月月供*/
-(NSInteger)getCommercialLoanMonthlyInstallmentPaymentWithRACTuple:(RACTuple *)tuple {
    NSInteger amount = [tuple.second integerValue];
    NSInteger period = [tuple.third integerValue];
    float rate = [tuple.fourth floatValue];
    if ([tuple.first integerValue] == 0) {
        return [self averageCapitalPlusInterestMonthlyInstallmentPaymentWithAmount:amount period:period rate:rate];
    }
    else return [self averageCapitalMonthlyInstallmentPaymentWithAmount:amount period:period rate:rate];
    
}

/**公积金贷款每月月供*/
-(NSInteger)getHousingProvidentFundLoanMonthlyInstallmentPaymentWithRACTuple:(RACTuple *)tuple {
    NSInteger amount = [tuple.second integerValue];
    NSInteger period = [tuple.third integerValue];
    float rate = [tuple.fourth floatValue];
    if ([tuple.first integerValue] == 0) {
        return [self averageCapitalPlusInterestMonthlyInstallmentPaymentWithAmount:amount period:period rate:rate];
    }
    else return [self averageCapitalMonthlyInstallmentPaymentWithAmount:amount period:period rate:rate];
}

/**组合贷款每月月供*/
-(NSInteger)getMixLoanMonthlyInstallmentPaymentWithRACTuple:(RACTuple *)tuple {
    NSInteger commercialLoanAmount = [tuple.second integerValue];
    NSInteger housingProvidentFundLoanAmount = [tuple.third integerValue];
    NSInteger period = [tuple.fourth integerValue];
    float commercialLoanRate = [tuple.fifth floatValue];
    float housingProvidentFundLoanRate = [tuple[5] floatValue];
    if ([tuple.first integerValue] == 0) {
        return [self averageCapitalPlusInterestMonthlyInstallmentPaymentWithAmount:commercialLoanAmount period:period rate:commercialLoanRate]+[self averageCapitalPlusInterestMonthlyInstallmentPaymentWithAmount:housingProvidentFundLoanAmount period:period rate:housingProvidentFundLoanRate];
    }
    else return [self averageCapitalMonthlyInstallmentPaymentWithAmount:commercialLoanAmount period:period rate:commercialLoanRate]+[self averageCapitalMonthlyInstallmentPaymentWithAmount:housingProvidentFundLoanAmount period:period rate:housingProvidentFundLoanRate];
}

/**商业贷款每月递减*/
-(NSInteger)getCommercialLoanMonthlyDecreaseWithRACTuple:(RACTuple *)tuple {
    NSInteger amount = [tuple.second integerValue];
    NSInteger period = [tuple.third integerValue];
    float rate = [tuple.fourth floatValue];
    if ([tuple.first integerValue] == 0) {
        return 0;
    }
    else return [self averageCapitalDecreaseWithAmount:amount period:period rate:rate];
}

/**公积金贷款每月递减*/
-(NSInteger)getHousingProvidentFundLoanMonthlyDecreaseWithRACTuple:(RACTuple *)tuple {
    NSInteger amount = [tuple.second integerValue];
    NSInteger period = [tuple.third integerValue];
    float rate = [tuple.fourth floatValue];
    if ([tuple.first integerValue] == 0) {
        return 0;
    }
    else return [self averageCapitalDecreaseWithAmount:amount period:period rate:rate];
}

/**组合贷款每月递减*/
-(NSInteger)getMixLoanMonthlyDecreaseWithRACTuple:(RACTuple *)tuple {
    NSInteger commercialLoanAmount = [tuple.second integerValue];
    NSInteger housingProvidentFundLoanAmount = [tuple.third integerValue];
    NSInteger period = [tuple.fourth integerValue];
    float commercialLoanRate = [tuple.fifth floatValue];
    float housingProvidentFundLoanRate = [tuple[5] floatValue];
    if ([tuple.first integerValue] == 0) {
        return 0;
    }
    else return [self averageCapitalDecreaseWithAmount:commercialLoanAmount period:period rate:commercialLoanRate]+[self averageCapitalDecreaseWithAmount:housingProvidentFundLoanAmount period:period rate:housingProvidentFundLoanRate];
}

/**商业贷款支付利息*/
-(NSInteger)getCommercialLoanInterestsWithRACTuple:(RACTuple *)tuple {
    NSInteger amount = [tuple.second integerValue];
    NSInteger period = [tuple.third integerValue];
    float rate = [tuple.fourth floatValue];
    if ([tuple.first integerValue] == 0) {
        return [self averageCapitalPlusInterestWithAmount:amount period:period rate:rate];
    }
    else return [self averageCapitalInterestWithAmount:amount period:period rate:rate];
}

/**公积金贷款支付利息*/
-(NSInteger)getHousingProvidentFundLoanInterestsWithRACTuple:(RACTuple *)tuple {
    NSInteger amount = [tuple.second integerValue];
    NSInteger period = [tuple.third integerValue];
    float rate = [tuple.fourth floatValue];
    if ([tuple.first integerValue] == 0) {
        return [self averageCapitalPlusInterestWithAmount:amount period:period rate:rate];
    }
    else return [self averageCapitalInterestWithAmount:amount period:period rate:rate];
}

/**商业贷款支付利息*/
-(NSInteger)getMixLoanInterestsWithRACTuple:(RACTuple *)tuple {
    NSInteger commercialLoanAmount = [tuple.second integerValue];
    NSInteger housingProvidentFundLoanAmount = [tuple.third integerValue];
    NSInteger period = [tuple.fourth integerValue];
    float commercialLoanRate = [tuple.fifth floatValue];
    float housingProvidentFundLoanRate = [tuple[5] floatValue];
    if ([tuple.first integerValue] == 0) {
        return [self averageCapitalPlusInterestWithAmount:commercialLoanAmount period:period rate:commercialLoanRate]+[self averageCapitalPlusInterestWithAmount:housingProvidentFundLoanAmount period:period rate:housingProvidentFundLoanRate];
    }
    else return [self averageCapitalInterestWithAmount:commercialLoanAmount period:period rate:commercialLoanRate]+[self averageCapitalInterestWithAmount:housingProvidentFundLoanAmount period:period rate:housingProvidentFundLoanRate];
}

/**商业贷款还款总额*/
-(NSInteger)getCommercialLoanPaymentAmountWithRACTuple:(RACTuple *)tuple {
    NSInteger amount = [tuple.second integerValue];
    NSInteger period = [tuple.third integerValue];
    float rate = [tuple.fourth floatValue];
    if ([tuple.first integerValue] == 0) {
        return [self averageCapitalPlusInterestTotalPaymentWithAmount:amount period:period rate:rate];
    }
    else return [self averageCapitalTotalPaymentWithAmount:amount period:period rate:rate];
}

/**公积金贷款还款总额*/
-(NSInteger)getHousingProvidentFundLoanPaymentAmountWithRACTuple:(RACTuple *)tuple {
    NSInteger amount = [tuple.second integerValue];
    NSInteger period = [tuple.third integerValue];
    float rate = [tuple.fourth floatValue];
    if ([tuple.first integerValue] == 0) {
        return [self averageCapitalPlusInterestTotalPaymentWithAmount:amount period:period rate:rate];
    }
    else return [self averageCapitalTotalPaymentWithAmount:amount period:period rate:rate];
}

/**组合贷款还款总额*/
-(NSInteger)getMixLoanPaymentAmountWithRACTuple:(RACTuple *)tuple {
    NSInteger commercialLoanAmount = [tuple.second integerValue];
    NSInteger housingProvidentFundLoanAmount = [tuple.third integerValue];
    NSInteger period = [tuple.fourth integerValue];
    float commercialLoanRate = [tuple.fifth floatValue];
    float housingProvidentFundLoanRate = [tuple[5] floatValue];
    if ([tuple.first integerValue] == 0) {
        return [self averageCapitalPlusInterestTotalPaymentWithAmount:commercialLoanAmount period:period rate:commercialLoanRate]+[self averageCapitalPlusInterestTotalPaymentWithAmount:housingProvidentFundLoanAmount period:period rate:housingProvidentFundLoanRate];
    }
    else return [self averageCapitalTotalPaymentWithAmount:commercialLoanAmount period:period rate:commercialLoanRate]+[self averageCapitalTotalPaymentWithAmount:housingProvidentFundLoanAmount period:period rate:housingProvidentFundLoanRate];
}



@end
