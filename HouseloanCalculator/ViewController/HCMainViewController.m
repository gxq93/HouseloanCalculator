//
//  HCMainViewController.m
//  HouseloanCalculator
//
//  Created by GuYi on 16/8/26.
//  Copyright © 2016年 aicai. All rights reserved.
//

#import "HCMainViewController.h"
#import "HCSegmentView.h"
#import "HCPickerView.h"
#import "HCHeaderCell.h"
#import "HCSegmentCell.h"
#import "HCTextInputCell.h"
#import "HCPickerCell.h"

static NSString * const headIdentifier = @"head";
static NSString * const segmentIdentifier = @"segment";
static NSString * const textInputIdentifier1 = @"textInput1"; //商业贷款金额cell
static NSString * const textInputIdentifier2 = @"textInput2"; //公积金贷款金额cell
static NSString * const pickerIdentifier1 = @"picker1";    //贷款年限cell
static NSString * const pickerIdentifier2 = @"picker2";    //商业贷款利率cell
static NSString * const pickerIdentifier3 = @"picker3";    //公积金贷款利率cell


@interface HCMainViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSArray *commercialLoanTitleArray;
@property(nonatomic,strong)NSArray *housingProvidentFundLoanTitleArray;
@property(nonatomic,strong)NSArray *mixLoanTitleArray;
@property(nonatomic,strong)NSArray *titleArray;                 //标题
@property(nonatomic,strong)NSArray *loanPeriodArray;            //贷款年限
@property(nonatomic,strong)NSArray *commercialLoanRateTitle;    //商业贷款利率标题
@property(nonatomic,strong)NSArray *commercialLoanRateValue;    //商业贷款利率
@property(nonatomic,strong)NSArray *housingProvidentFundLoanRateTitle;   //公积金贷款利率标题
@property(nonatomic,strong)NSArray *housingProvidentFundLoanRateValue;   //公积金贷款利率

@property(nonatomic,assign)LoanType loadnType;

@property(nonatomic,strong)HCSegmentView *segmentView;
@property(nonatomic,strong)UITableView *tabelView;
@property(nonatomic,strong)HCPickerView *loanPeriodPickerView;
@property(nonatomic,strong)HCPickerView *commercialLoanPickerView;
@property(nonatomic,strong)HCPickerView *housingProvidentFundLoanPickerView;

@property(nonatomic,strong)RACDisposable *periodDisposable;
@property(nonatomic,strong)RACDisposable *caculateDisposable;
@property(nonatomic,strong)NSMutableArray *signalArray;

@property(nonatomic,assign)BOOL viewDisAppear;

@end

@implementation HCMainViewController

#pragma mark- lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    
    [self setupUI];

}

#pragma mark- privateMethod
- (void)setupUI {
    [self.view addSubview:self.segmentView];
    [self.view addSubview:self.tabelView];
}

- (UIView*)createTableViewHead {
    UIView *headView = [[UIView alloc]init];
    headView.backgroundColor = UIColorFromRGB(0xeeeeee);
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 200, 30)];
    label.textColor = UIColorFromRGB(0x666666);
    label.font = [UIFont systemFontOfSize:12];
    label.text = @"在下方输入贷款信息";
    [headView addSubview:label];
    return headView;
}

//配置pickerViewCell显示
- (void)configCellRateWith:(HCPickerCell*)cell atIndexPath:(NSIndexPath *)indexPath withNum:(NSInteger)textInputNum {
    
    cell.titleLabel.text = self.titleArray[indexPath.row];
    if (indexPath.row == textInputNum + 1) {
        //防止重复订阅。。。
        if (self.periodDisposable) {
            [self.periodDisposable dispose];
        }
        @weakify(self)
        self.periodDisposable = [[self.loanPeriodPickerView.selectSignal map:^id(RACTuple *value) {
            @strongify(self)
            return [NSString stringWithFormat:@"%@",self.loanPeriodArray[[value.second integerValue]]];
        }]subscribeNext:^(id x) {
            cell.rateLabel.text = x;
        }];
    }
    else if (indexPath.row == textInputNum + 2) {
        
        if (self.loadnType == housingProvidentFundLoan) {
            [self configSignalWithCell:cell withNum:textInputNum withLoanType:housingProvidentFundLoan];
        }
        else {
            [self configSignalWithCell:cell withNum:textInputNum withLoanType:commercialLoan];
        }
    }
    else {
        [self configSignalWithCell:cell withNum:textInputNum withLoanType:housingProvidentFundLoan];
    }
}

//配置更换贷款期限后改变利率及更换利率后的显示
- (void)configSignalWithCell:(HCPickerCell*)cell withNum:(NSInteger)textInputNum withLoanType:(LoanType)type {
    
    HCPickerCell *periodCell = self.tabelView.visibleCells[textInputNum + 2];
    if (type == commercialLoan) {
        @weakify(self)
        [RACObserve(periodCell.rateLabel, text)subscribeNext:^(id x) {
            @strongify(self)
            NSInteger index = [self.commercialLoanRateValue indexOfObject:cell.rateLabel.text];
            self.commercialLoanRateValue = [x integerValue]==5 ? [self commercialLoanRateValueIsFive] : [self commercialLoanRateValueAboveFive];
            if (![self.commercialLoanRateValue containsObject:cell.rateLabel.text]) {
                cell.rateLabel.text = self.commercialLoanRateValue[index];
            }
        }];
        
        [[self.commercialLoanPickerView.selectSignal map:^id(RACTuple *value) {
            @strongify(self)
            return [NSString stringWithFormat:@"%@",self.commercialLoanRateValue[[value.second integerValue]]];
        }]subscribeNext:^(id x) {
            cell.rateLabel.text = x;
        }];
    }
    else if(type == housingProvidentFundLoan) {
        @weakify(self)
        [RACObserve(periodCell.rateLabel, text)subscribeNext:^(id x) {
            @strongify(self)
            NSInteger index = [self.housingProvidentFundLoanRateValue indexOfObject:cell.rateLabel.text];
            self.housingProvidentFundLoanRateValue = [x integerValue]==5 ? [self housingProvidentFundLoanRateValueIsFive] : [self housingProvidentFundLoanRateValueAboveFive];
            if (![self.housingProvidentFundLoanRateValue containsObject:cell.rateLabel.text]) {
                cell.rateLabel.text = self.housingProvidentFundLoanRateValue[index];
            }
        }];
        
        [[self.housingProvidentFundLoanPickerView.selectSignal map:^id(RACTuple *value) {
            @strongify(self)
            return [NSString stringWithFormat:@"%@",self.housingProvidentFundLoanRateValue[[value.second integerValue]]];
        }]subscribeNext:^(id x) {
            cell.rateLabel.text = x;
        }];
    }
}

//配置textInputViewCellRuseID
- (NSString*)configTextInputCellIdentifierAtIndexPath:(NSIndexPath *)indexPath withNum:(NSInteger)textInputNum {
    if (indexPath.row == 1) {
        if (self.loadnType == housingProvidentFundLoan) {
            return textInputIdentifier2;
        }
        else return textInputIdentifier1;
    }
    else return textInputIdentifier2;
}

//配置pickerViewCellRuseID
- (NSString*)configPickerViewCellIdentifierAtIndexPath:(NSIndexPath *)indexPath withNum:(NSInteger)textInputNum {
    if (indexPath.row == textInputNum + 1) {return pickerIdentifier1;}
    else if (indexPath.row == textInputNum + 2){
        if (self.loadnType == commercialLoan || self.loadnType == mixLoan) {
            return pickerIdentifier2;
        }
        else return pickerIdentifier3;
    }
    else return pickerIdentifier3;
}

#pragma mark- UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    else {
        switch (self.loadnType) {
            case commercialLoan:return self.commercialLoanTitleArray.count;break;
            case housingProvidentFundLoan:return self.housingProvidentFundLoanTitleArray.count;break;
            default:return self.mixLoanTitleArray.count;break;
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        HCHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:headIdentifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([HCHeaderCell class]) owner:self options:nil]lastObject];
        }
        //移除所有信号重新集合
        [self.signalArray removeAllObjects];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else {
        NSInteger textInputNum = self.loadnType == mixLoan ? 2 : 1;
        if(indexPath.row == 0) {
            HCSegmentCell *cell = [tableView dequeueReusableCellWithIdentifier:segmentIdentifier];
            if (!cell) {
                cell = [[HCSegmentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:segmentIdentifier];
            }
            cell.titleLabel.text = self.titleArray[indexPath.row];
            [self.signalArray addObject:RACObserve(cell.segment, selectedSegmentIndex)];
            return cell;
        }
        else if(indexPath.row <= textInputNum) {
            NSString *textInputIdentifier = [self configTextInputCellIdentifierAtIndexPath:indexPath withNum:textInputNum];
            HCTextInputCell *cell = [tableView dequeueReusableCellWithIdentifier:textInputIdentifier];
            if (!cell) {
                cell = [[HCTextInputCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:textInputIdentifier];
            }
            cell.titleLabel.text = self.titleArray[indexPath.row];
            [self.signalArray addObject:cell.textInput.rac_textSignal];
            return cell;
        }
        else {
            NSString *pickerIdentifier = [self configPickerViewCellIdentifierAtIndexPath:indexPath withNum:textInputNum];
            HCPickerCell *cell = [tableView dequeueReusableCellWithIdentifier:pickerIdentifier];
            if (!cell) {
                cell = [[HCPickerCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:pickerIdentifier];
            }
            [self configCellRateWith:cell atIndexPath:indexPath withNum:textInputNum];
            [self.signalArray addObject:RACObserve(cell.rateLabel, text)];
            
            //在最后一个cell创建结束后订阅所有cell的信号。。。
            if (indexPath.row == [tableView numberOfRowsInSection:1]- 1) {
                //为了防止重复订阅在每次执行订阅前先dispose
                if (self.caculateDisposable) {
                    [self.caculateDisposable dispose];
                }
                @weakify(self)
                self.caculateDisposable = [[RACSignal combineLatest:self.signalArray] subscribeNext:^(RACTuple *tuple) {
                    @strongify(self)
                    HCHeaderCell *headerCell = (HCHeaderCell*)tableView.visibleCells[0];
                    [headerCell configCellContentWithRACTuple:tuple withType:self.loadnType];
                }];
            }
            return cell;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 170;
    }
    else return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 30;
    }
    else return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section ==1) {
        return [self createTableViewHead];
    }
    else return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.00001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger textInputNum = self.loadnType == mixLoan ? 2 : 1;
    if (indexPath.section == 1 && indexPath.row == textInputNum + 1) {[self.view addSubview:self.loanPeriodPickerView];}
    else if (indexPath.section == 1 && indexPath.row == textInputNum + 2) {
        if (self.loadnType == housingProvidentFundLoan) {[self.view addSubview:self.housingProvidentFundLoanPickerView];}
        else {[self.view addSubview:self.commercialLoanPickerView];}
    }
    else if(indexPath.section == 1 && indexPath.row == textInputNum + 3){[self.view addSubview:self.housingProvidentFundLoanPickerView];}
}

#pragma mark- getter
- (HCSegmentView *)segmentView {
    if (!_segmentView) {
        _segmentView = [[HCSegmentView alloc]initWithFrame:CGRectMake(0, 0, kScreen_W, 64)];
        _segmentView.selectIndex = 0;
        @weakify(self)
        [_segmentView.selectSignal subscribeNext:^(id selectIndex) {
            @strongify(self);
            self.loadnType = [selectIndex intValue];
            //针对4s屏幕小加载不到最后一个cell。。。
            if (kScreen_H == 480.0) {
                self.tabelView.contentOffset = CGPointMake(0, 5);
            }
            [self.tabelView reloadData];
        }];
    }
    return _segmentView;
}

- (UITableView*)tabelView {
    if (!_tabelView) {
        _tabelView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kScreen_W, kScreen_H-64) style:UITableViewStylePlain];
        _tabelView.delegate = self;
        _tabelView.dataSource = self;
        _tabelView.backgroundColor = UIColorFromRGB(0xeeeeee);
        _tabelView.bounces = NO;
    }
    return _tabelView;
}

- (HCPickerView *)loanPeriodPickerView {
    if (!_loanPeriodPickerView) {
        _loanPeriodPickerView = [[HCPickerView alloc]initWithFrame:[UIScreen mainScreen].bounds withTitle:self.loanPeriodArray];
    }
    return _loanPeriodPickerView;
}

- (HCPickerView *)commercialLoanPickerView {
    if (!_commercialLoanPickerView) {
        _commercialLoanPickerView = [[HCPickerView alloc]initWithFrame:[UIScreen mainScreen].bounds withTitle:self.commercialLoanRateTitle];
    }
    return _commercialLoanPickerView;
}

- (HCPickerView *)housingProvidentFundLoanPickerView {
    if (!_housingProvidentFundLoanPickerView) {
        _housingProvidentFundLoanPickerView = [[HCPickerView alloc]initWithFrame:[UIScreen mainScreen].bounds withTitle:self.housingProvidentFundLoanRateTitle];
    }
    return _housingProvidentFundLoanPickerView;
}

- (NSArray *)commercialLoanTitleArray {
    return @[@"还款方式",@"商业贷款金额(万)",@"贷款年限",@"商业贷款利率(%)"];
}

- (NSArray *)housingProvidentFundLoanTitleArray {
    return @[@"还款方式",@"公积金贷款金额(万)",@"贷款年限",@"公积金贷款利率(%)"];
}

- (NSArray *)mixLoanTitleArray {
    return @[@"还款方式",@"商业贷款金额(万)",@"公积金贷款金额(万)",@"贷款年限",@"商业贷款利率(%)",@"公积金贷款利率(%)"];
}

- (NSArray *)titleArray {
    switch (self.loadnType) {
        case commercialLoan:_titleArray = self.commercialLoanTitleArray; break;
        case housingProvidentFundLoan:_titleArray = self.housingProvidentFundLoanTitleArray;break;
        default:_titleArray = self.mixLoanTitleArray;break;
    }
    return _titleArray;
}

- (NSMutableArray *)signalArray {
    if (!_signalArray) {
        _signalArray = [[NSMutableArray alloc]init];
    }
    return _signalArray;
}

- (NSArray *)loanPeriodArray {
    return @[@"5",@"10",@"15",@"20",@"25",@"30"];
}

- (NSArray *)commercialLoanRateTitle {
    return @[@"基准利率",@"7折利率", @"8折利率",@"8.3折利率",@"8.5折利率",@"8.8折利率",@"9折利率",@"9.5折利率",@"1.05倍利率",@"1.1倍利率",@"1.2倍利率",@"1.3倍利率"];
}

- (NSArray *)housingProvidentFundLoanRateTitle {
    return @[@"基准利率",@"1.1倍利率"];
}

- (NSArray *)commercialLoanRateValueIsFive {
    return @[@"4.75",@"3.32",@"3.80",@"3.94",@"4.04",@"4.18",@"4.27",@"4.51",@"4.99",@"5.23",@"5.70",@"6.17"];
}

- (NSArray *)commercialLoanRateValueAboveFive {
    return @[@"4.90",@"3.43",@"3.92",@"4.07",@"4.17",@"4.31",@"4.41",@"4.65",@"5.14",@"5.39",@"5.88",@"6.37"];
}

- (NSArray *)housingProvidentFundLoanRateValueIsFive {
    return @[@"2.75",@"3.03"];
}

- (NSArray *)housingProvidentFundLoanRateValueAboveFive {
    return @[@"3.25",@"3.58"];
}

@end
