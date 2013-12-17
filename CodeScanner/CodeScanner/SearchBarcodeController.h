//
//  SearchBarcodeController.h
//  CodeScanner
//
//  Created by Jack on 13-11-25.
//  Copyright (c) 2013年 violetmoon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BarCode;
@class ProductInfo;

@interface SearchBarcodeController : UIViewController{
    BarCode *bar_code;
    ProductInfo *product_info;
    __weak IBOutlet UILabel *label_ean;
    __weak IBOutlet UILabel *label_size;
    __weak IBOutlet UILabel *label_country;
    __weak IBOutlet UILabel *label_message;
    __weak IBOutlet UILabel *label_description;
}

@property (nonatomic,strong) BarCode *bar_code;
@property (nonatomic,strong) ProductInfo *product_info;

+(SearchBarcodeController*) search;

@end
