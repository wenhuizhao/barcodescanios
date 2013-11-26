//
//  ProductInfo.m
//  CodeScanner
//
//  Created by Jack on 13-11-26.
//  Copyright (c) 2013年 violetmoon. All rights reserved.
//

#import "ProductInfo.h"

@implementation ProductInfo

@synthesize description,upc,ean,found,issuerCountry,issuerCountryCode,lastModifiedUTC,message,noCacheAfterUTC,pendingUpdates,size,status;

- (id)init
{
    self = [super init];
    if (self) {
        description = @"";
        upc = @"";
        ean = @"";
        found = @"";
        issuerCountry = @"";
        issuerCountryCode = @"";
        lastModifiedUTC = @"";
        message = @"";
        noCacheAfterUTC = @"";
        pendingUpdates = @"";
        size = @"";
        status = @"";
    }
    return self;
}

@end
