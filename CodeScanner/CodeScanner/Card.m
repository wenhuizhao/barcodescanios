//
//  Card.m
//  CodeScanner
//
//  Created by Jack on 13-12-2.
//  Copyright (c) 2013年 violetmoon. All rights reserved.
//

#import "Card.h"

@implementation Card

@synthesize cvv,id,redactedCardNumber,expiryMonth,expiryYear,cardNumber;

- (void) p{
    NSLog(@"%@\n%@\n%@\n%@\n%@",cardNumber,redactedCardNumber,expiryMonth,expiryYear,cvv);
}

- (id)init
{
    self = [super init];
    if (self) {
        self.id = 0;
        self.cvv = @"";
        self.expiryMonth = @"";
        self.expiryYear = @"";
        self.cardNumber = @"";
        self.redactedCardNumber = @"";
    }
    return self;
}

-(void)dealloc{
    redactedCardNumber=cvv=expiryMonth=expiryYear=cardNumber=nil;
}

@end
