//
//  BarCode.h
//  CodeScanner
//
//  Created by Jack on 13-11-12.
//  Copyright (c) 2013年 violetmoon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ISqlModel.h"

@interface BarCode : ISqlModel{
    int id;
    NSString *imagePath;
    NSString *type;
    NSString *data;
    NSString *time;
    int count;      // 同一条形码的个数
    NSString *scanID;
}

@property (nonatomic,assign) int id;
@property (nonatomic,strong) NSString *imagePath;
@property (nonatomic,strong) NSString *type;
@property (nonatomic,strong) NSString *data;
@property (nonatomic,strong) NSString *time;
@property (nonatomic,assign) int count;
@property (nonatomic,strong) NSString *scanID;

@end
