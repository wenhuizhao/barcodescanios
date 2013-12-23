//
//  Card.h
//  CodeScanner
//
//  Created by Jack on 13-12-2.
//  Copyright (c) 2013年 violetmoon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ISqlModel.h"

@interface Card : ISqlModel{
    int id;
    NSString *cardNumber;
    NSString *redactedCardNumber;
    NSString *expiryMonth;
    NSString *expiryYear;
    NSString *cvv;
    NSString *customerId;
    NSString *token;
}
@property (nonatomic,assign) int id;
@property (nonatomic,strong) NSString *cardNumber;
@property (nonatomic,strong) NSString *redactedCardNumber;
@property (nonatomic,strong) NSString *expiryMonth;
@property (nonatomic,strong) NSString *expiryYear;
@property (nonatomic,strong) NSString *cvv;
@property (nonatomic,strong) NSString *customerId;
@property (nonatomic,strong) NSString *token;

- (void) p;
@end
