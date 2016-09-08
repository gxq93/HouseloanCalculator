//
//  HCCalculatorManager.h
//  HouseloanCalculator
//
//  Created by GuYi on 16/8/31.
//  Copyright © 2016年 aicai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HCCalculatorManager : NSObject

+ (HCCalculatorManager *)sharedInstance;

/**商业贷款每月月供*/
-(NSInteger)getCommercialLoanMonthlyInstallmentPaymentWithRACTuple:(RACTuple *)tuple;

/**公积金贷款每月月供*/
-(NSInteger)getHousingProvidentFundLoanMonthlyInstallmentPaymentWithRACTuple:(RACTuple *)tuple;

/**组合贷款每月月供*/
-(NSInteger)getMixLoanMonthlyInstallmentPaymentWithRACTuple:(RACTuple *)tuple;

/**商业贷款每月递减*/
-(NSInteger)getCommercialLoanMonthlyDecreaseWithRACTuple:(RACTuple *)tuple;

/**公积金贷款每月递减*/
-(NSInteger)getHousingProvidentFundLoanMonthlyDecreaseWithRACTuple:(RACTuple *)tuple;

/**组合贷款每月递减*/
-(NSInteger)getMixLoanMonthlyDecreaseWithRACTuple:(RACTuple *)tuple;

/**商业贷款支付利息*/
-(NSInteger)getCommercialLoanInterestsWithRACTuple:(RACTuple *)tuple;

/**公积金贷款支付利息*/
-(NSInteger)getHousingProvidentFundLoanInterestsWithRACTuple:(RACTuple *)tuple;

/**商业贷款支付利息*/
-(NSInteger)getMixLoanInterestsWithRACTuple:(RACTuple *)tuple;

/**商业贷款还款总额*/
-(NSInteger)getCommercialLoanPaymentAmountWithRACTuple:(RACTuple *)tuple;

/**公积金贷款还款总额*/
-(NSInteger)getHousingProvidentFundLoanPaymentAmountWithRACTuple:(RACTuple *)tuple;

/**组合贷款还款总额*/
-(NSInteger)getMixLoanPaymentAmountWithRACTuple:(RACTuple *)tuple;


@end
