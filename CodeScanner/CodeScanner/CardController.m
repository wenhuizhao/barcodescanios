//
//  CardController.m
//  CodeScanner
//
//  Created by Jack on 13-12-2.
//  Copyright (c) 2013年 violetmoon. All rights reserved.
//

#import "CardController.h"
#import "Card.h"
#import "ISqlite.h"
#import "ZXingObjC.h"
#import "App.h"
#import <AFNetworking/AFNetworking.h>

@implementation CardController{
    CardIOPaymentViewController *card_io_vc;
    Card *card;
    UIImageView *qr_img_v;
    NSString *tip;
    NSArray *tips;
}

@synthesize value_select_view;

-(void) viewDidLoad{
    [super viewDidLoad];
    // init
    tip = @"0";
    tips = [NSArray arrayWithObjects:@"0",@"5",@"10",@"15",@"20",@"25",@"30",@"35",@"40",@"45",@"50",nil];
    value_select_view.delegate = self;
    value_select_view.dataSource = self;
    value_select_view.shouldBeTransparent = YES;
    value_select_view.horizontalScrolling = YES;
//    value_select_view.debugEnabled = YES;
}

-(void) viewDidAppear:(BOOL)animated{
    
    // own card ?
    if ([ISqlite findAll:[Card class]].count > 0) {
        // QR
        card = [[ISqlite findAll:[Card class]] objectAtIndex:0];
        [self QR];
    } else {
        // show
        [[App sharedApp] alert:@"还没有添加卡片,请点击右上角按钮进行添加"];
    }
    
}

-(IBAction) inputWithCamera:(id)sender{
    // card io
    card_io_vc = [[CardIOPaymentViewController alloc] initWithPaymentDelegate:self];
    card_io_vc.appToken=@"9fac054777214859ad2614246bdfbdaf";
    [self presentViewController:card_io_vc animated:YES completion:^{
        
    }];
}

-(NSString*) time{
    time_t now;
    time(&now);
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:now];
    return [NSString stringWithFormat:@"%f",date.timeIntervalSince1970];
}

-(void) cardPost{
    
}

-(void) cardNew{
    if (card) {
        NSURL *url = [NSURL URLWithString:@"http://test.goodchinese.com/credit_cards"];
        AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                card.cardNumber, @"credit_card[number]",
                                card.expiryMonth, @"credit_card[expiration_month]",
                                card.expiryYear, @"credit_card[expiration_year]",
                                card.cvv, @"credit_card[cvv]",
                                @"json", @"format",
                                nil];
        NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:@"/credit_cards" parameters: params];
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                            success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON){
                                                                                                card.customerId = [NSString stringWithFormat:@"%@", [JSON valueForKeyPath:@"customer_id"]];
                                                                                                card.token = [NSString stringWithFormat:@"%@", [JSON valueForKeyPath:@"token"]];
                                                                                                NSLog(@"Response :%@, %@", card.customerId, card.token);
                                                                                                [self QR];
                                                                                            }
                                                                                            failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                                NSLog(@"error:%@", error);
                                                                                                [self QR];
                                                                                            }
                                             ];
        [operation start];
        // save
        [card save];
    }
    
    // qr
    //[self QR];
    
}

-(void) QR{
    // data.
    if (!card) {
        return;
    }
    [card save];
    NSString *qr_str=@"";
    NSString *qr_data=card.cardNumber;
    qr_str = [NSString stringWithFormat:@"token:%@,customerId:%@,tip:%@",card.token, card.customerId,tip];
    UIImage *qr_img;
    
    // new.
    NSError* error = nil;
    int w_H = 300;
    if ([UIScreen mainScreen].bounds.size.height < 1136/2) {
        w_H = 260;
    }
    ZXMultiFormatWriter* writer = [ZXMultiFormatWriter writer];
    ZXBitMatrix* result = [writer encode:qr_str
                                  format:kBarcodeFormatQRCode
                                   width:w_H
                                  height:w_H
                                   error:&error];
    if (result) {
        // create.
        CGImageRef generated_image = [[ZXImage imageWithMatrix:result] cgimage];
        qr_img = [UIImage imageWithCGImage:generated_image];
    } else {
        // error.
        NSString* errorMessage = [error localizedDescription];
        [[App sharedApp] alert:errorMessage];
        NSLog(@"%@",errorMessage);
    }
    
    // show.
    if (qr_img_v) {
        [qr_img_v removeFromSuperview];
    }
    qr_img_v = [[UIImageView alloc] initWithImage:qr_img];
    qr_img_v.$x = (320- qr_img.size.width)/2;
    qr_img_v.$y = 30;
    [self.view addSubview:qr_img_v];
    
    //bring
    [value_select_view bringSubviewToFront:qr_img_v];
    
    
}

#pragma - CardIOPaymentViewControllerDelegate

-(void) userDidCancelPaymentViewController:(CardIOPaymentViewController *)scanViewController {
    NSLog(@"User canceled payment info");
    [card_io_vc dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void) userDidProvideCreditCardInfo:(CardIOCreditCardInfo *)info inPaymentViewController:(CardIOPaymentViewController *)scanViewController {
    
    // card new
    NSLog(@"Received card info. Number: %@, expiry: %02i/%i, cvv: %@.", info.redactedCardNumber, info.expiryMonth, info.expiryYear, info.cvv);
    
    card = [Card new];
    card.redactedCardNumber = info.redactedCardNumber;
    card.cardNumber = info.cardNumber;
    card.expiryMonth = [NSString stringWithFormat:@"%d",info.expiryMonth];
    card.expiryYear = [NSString stringWithFormat:@"%d",info.expiryYear];
    card.cvv = info.cvv;
    [card p];
    [self cardNew];
    
    // dismiss
    [card_io_vc dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma - IZValueSelectorViewDataSource
- (NSInteger)numberOfRowsInSelector:(IZValueSelectorView *)valueSelector{
    return tips.count;
}

- (CGFloat)rowHeightInSelector:(IZValueSelectorView *)valueSelector{
    return 70;
}

- (CGFloat)rowWidthInSelector:(IZValueSelectorView *)valueSelector{
    return 48;
}

- (UIView *)selector:(IZValueSelectorView *)valueSelector viewForRowAtIndex:(NSInteger)index{
    return [self selector:valueSelector viewForRowAtIndex:index selected:NO];
}

- (UIView *)selector:(IZValueSelectorView *)valueSelector viewForRowAtIndex:(NSInteger)index selected:(BOOL)selected {
    UILabel * label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, 0, 48, 70);
    label.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:30];
    label.text = [tips objectAtIndex:index];
    label.textAlignment =  NSTextAlignmentCenter;
    label.backgroundColor = [UIColor colorWithRed:225/255.0f green:225/255.0f blue:225/255.0f alpha:1];
    if (selected) {
        label.textColor = [UIColor colorWithRed:79/255.0f green:158/255.0f blue:232/255.0f alpha:1];
    } else {
        label.textColor = [UIColor whiteColor];
    }
    return label;
}

- (CGRect)rectForSelectionInSelector:(IZValueSelectorView *)valueSelector {
    return CGRectMake(0,0,48,70);
}

#pragma - IZValueSelectorViewDelegate
- (void)selector:(IZValueSelectorView *)valueSelector didSelectRowAtIndex:(NSInteger)index{
    // select
    tip = [tips objectAtIndex:index];
    [self QR];
}
@end
