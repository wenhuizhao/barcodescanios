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

@interface SearchBarcodeController ()<XMLRPCConnectionDelegate>

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
    NSString *upc = @"123456";
    // 判断是否是UPC
    
    // xml rpc 方式查询
    NSURL *URL = [NSURL URLWithString: @"http://www.upcdatabase.com/xmlrpc"];
    XMLRPCRequest *request = [[XMLRPCRequest alloc] initWithURL: URL];
    XMLRPCConnectionManager *manager = [XMLRPCConnectionManager sharedManager];
    
    
    NSArray *params = [NSArray arrayWithObjects:@"<value><upc_key>e4a741a3abe480a1007bf8a1460d99c3698670b7</upc_key></value>",@"<value><upc>123456789012</upc></value>", nil];
    
    [request setMethod: @"lookup" withParameters: params];
    
    NSLog(@"Request body: %@", [request body]);
    
    [manager spawnConnectionWithXMLRPCRequest: request delegate: self];
    
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

#pragma XMLRPCConnectionDelegate
- (void)request: (XMLRPCRequest *)request didReceiveResponse: (XMLRPCResponse *)response{
    NSLog(@"%@",[response body]);
}

@end
