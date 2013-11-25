//
//  SearchBarcodeController.m
//  CodeScanner
//
//  Created by Jack on 13-11-25.
//  Copyright (c) 2013年 violetmoon. All rights reserved.
//

#import "SearchBarcodeController.h"
#import "XMLRPC.h"
#import "BarCode.h"

@interface SearchBarcodeController ()

@end

@implementation SearchBarcodeController
@synthesize bar_code;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)searchBarcode{
    // 判断是否是UPC
    
    // xml rpc 方式查询
    
    // 更新界面信息
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    MTKObservePropertySelf(bar_code, BarCode*, {
        [self searchBarcode];
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
