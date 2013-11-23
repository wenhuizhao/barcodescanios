//
//  BarCode.m
//  CodeScanner
//
//  Created by Jack on 13-11-12.
//  Copyright (c) 2013年 violetmoon. All rights reserved.
//

#import "BarCode.h"

@implementation BarCode

@synthesize data,id,imagePath,time,type,count,scanID;

- (id)init
{
    self = [super init];
    if (self) {
        self.id = self.count = 0;
        scanID = data = imagePath = time = type = @"";
    }
    return self;
}

-(void)dealloc{
    scanID =  data = imagePath = time = type = nil;
}

@end
