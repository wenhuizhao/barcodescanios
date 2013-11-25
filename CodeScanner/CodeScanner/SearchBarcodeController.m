//
//  SearchBarcodeController.m
//  CodeScanner
//
//  Created by Jack on 13-11-25.
//  Copyright (c) 2013年 violetmoon. All rights reserved.
//

#import "SearchBarcodeController.h"
#import "BarCode.h"
#import "App.h"

@interface SearchBarcodeController ()

@end

@implementation SearchBarcodeController
@synthesize bar_code;

+ (SearchBarcodeController*) search{
    return [[self alloc] initWithNibName:[self description] bundle:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)searchBarcode {
    double delayInSeconds = 0.1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        NSString *host = @"http://api.upcdatabase.org/json/";
        NSString *key = @"cefcc6a41cd57a3091134fd9b46596cd";
        NSString *upc =         bar_code.data;
        
        NSString *url = [[[host stringByAppendingString:key] stringByAppendingString:@"/"] stringByAppendingString:upc];
        NSString *resp = [NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:nil];
        [[App sharedApp] alert:resp];

    });
    
    
    
    // 判断是否是UPC
    
    // xml rpc 方式查询
    
    // 更新界面信息
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    MTKObservePropertySelf(bar_code, BarCode*, {
        [self searchBarcode];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
