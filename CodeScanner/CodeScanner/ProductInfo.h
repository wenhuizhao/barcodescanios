//
//  ProductInfo.h
//  CodeScanner
//
//  Created by Jack on 13-11-26.
//  Copyright (c) 2013年 violetmoon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductInfo : NSObject{
    NSString *description;
    NSString *ean;
    NSString *found;
    NSString *issuerCountry;
    NSString *issuerCountryCode;
    NSString *lastModifiedUTC;
    NSString *message;
    NSString *noCacheAfterUTC;
    NSString *pendingUpdates;
    NSString *size;
    NSString *status;
    NSString *upc;
}

@property (nonatomic,strong) NSString *description;
@property (nonatomic,strong) NSString *ean;
@property (nonatomic,strong) NSString *found;
@property (nonatomic,strong) NSString *issuerCountry;
@property (nonatomic,strong) NSString *issuerCountryCode;
@property (nonatomic,strong) NSString *lastModifiedUTC;
@property (nonatomic,strong) NSString *message;
@property (nonatomic,strong) NSString *noCacheAfterUTC;
@property (nonatomic,strong) NSString *pendingUpdates;
@property (nonatomic,strong) NSString *size;
@property (nonatomic,strong) NSString *status;
@property (nonatomic,strong) NSString *upc;

@end
