//
//  BarCodeController.h
//  CodeScanner
//
//  Created by Jack on 13-11-11.
//  Copyright (c) 2013年 violetmoon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BarCode;

@interface BarCodeController : UIViewController{
    BarCode *bar_code;
    IBOutlet UIButton *button_search;
}
@property (nonatomic,strong) BarCode *bar_code;
@property (nonatomic,strong) UIButton *button_search;

- (void) showSaveButton:(BOOL) sender;
- (void) showDeleteButton:(BOOL) sender;
- (void) showStep:(BOOL) sender;

@end
