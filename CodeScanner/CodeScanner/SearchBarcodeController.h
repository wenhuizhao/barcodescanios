//
//  SearchBarcodeController.h
//  CodeScanner
//
//  Created by Jack on 13-11-25.
//  Copyright (c) 2013年 violetmoon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BarCode;

@interface SearchBarcodeController : UIViewController{
    BarCode *bar_code;
}

@property (nonatomic,strong) BarCode *bar_code;

+(SearchBarcodeController*) search;

@end
