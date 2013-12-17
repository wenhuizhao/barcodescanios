//
//  SearchBarcodeController.m
//  CodeScanner
//
//  Created by Jack on 13-11-25.
//  Copyright (c) 2013年 violetmoon. All rights reserved.
//

#import "SearchBarcodeController.h"
#import "BarCode.h"
#import "XMLRPC.h"
#import "App.h"
#import "ProductInfo.h"

@interface SearchBarcodeController () <XMLRPCConnectionDelegate>

@end

@implementation SearchBarcodeController
@synthesize bar_code,product_info;

+ (SearchBarcodeController*) search{
    return [[SearchBarcodeController alloc] initWithNibName:[self description] bundle:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)searchBarcode {
    if (bar_code.data.length ==0) {
        return;
    }
    // xmlrpc 方式查询
    NSString *rpcKey = @"e4a741a3abe480a1007bf8a1460d99c3698670b7";
    NSString *ean = bar_code.data;
    
    NSURL *URL = [NSURL URLWithString: @"http://www.upcdatabase.com/xmlrpc"];
    
    XMLRPCRequest *request = [[XMLRPCRequest alloc] initWithURL:URL];
    XMLRPCConnectionManager *manager = [XMLRPCConnectionManager sharedManager];
    
    NSArray *params = [NSArray arrayWithObjects:
                       [NSDictionary dictionaryWithObjectsAndKeys:
                        rpcKey, @"rpc_key",
                        ean, @"ean",
                        nil],
                       nil];
    
    [request setMethod:@"lookup" withParameters:params];
    
    NSLog(@"Request body: %@", [request body]);
    
    [manager spawnConnectionWithXMLRPCRequest:request delegate:self];
    
}

- (void)updateUserInterface{
    [SVProgressHUD dismiss];
    if (!product_info) {
        return;
    }
    
    label_ean.text = [@"Ean: " stringByAppendingString:product_info.ean];
    label_size.text = [@"Size: " stringByAppendingString:product_info.size];
    label_country.text = [@"Country: " stringByAppendingString:product_info.issuerCountry];
    label_message.text = [@"Message: " stringByAppendingString:product_info.message];
    label_description.text = [@"Description: " stringByAppendingString:product_info.description];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [SVProgressHUD show];
    product_info = [[ProductInfo alloc] init];
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
    if ([response isFault]) {
        [[App sharedApp]alert:response.body];
    } else {
        // debug
        NSLog(@"Parsed response: %@", [response object]);
        
        // build model
        ProductInfo *info = [[ProductInfo alloc] init];
        info.description = [[response object] objectForKey:@"description"];
        info.ean = [[response object] objectForKey:@"ean"];
        info.found = [[response object] objectForKey:@"found"];
        info.issuerCountry = [[response object] objectForKey:@"issuerCountry"];
        info.issuerCountryCode = [[response object] objectForKey:@"issuerCountryCode"];
        info.lastModifiedUTC = [[response object] objectForKey:@"lastModifiedUTC"];
        info.message = [[response object] objectForKey:@"message"];
        info.noCacheAfterUTC = [[response object] objectForKey:@"noCacheAfterUTC"];
        info.pendingUpdates = [[response object] objectForKey:@"pendingUpdates"];
        info.size = [[response object] objectForKey:@"size"];
        info.status = [[response object] objectForKey:@"status"];
        info.upc = [[response object] objectForKey:@"upc"];
        
        info.description =  info.description==nil ? @"" : info.description;
        info.ean =  info.ean==nil ? @"" : info.ean;
        info.found =  info.found==nil ? @"" : info.found;
        info.issuerCountry =  info.issuerCountry==nil ? @"" : info.issuerCountry;
        info.issuerCountryCode =  info.issuerCountryCode==nil ? @"" : info.issuerCountryCode;
        info.lastModifiedUTC =  info.lastModifiedUTC==nil ? @"" : info.lastModifiedUTC;
        info.message =  info.message==nil ? @"" : info.message;
        info.noCacheAfterUTC =  info.noCacheAfterUTC==nil ? @"" : info.noCacheAfterUTC;
        info.pendingUpdates =  info.pendingUpdates==nil ? @"" : info.pendingUpdates;
        info.size =  info.size==nil ? @"" : info.size;
        info.status =  info.status==nil ? @"" : info.status;
        info.upc =  info.upc==nil ? @"" : info.upc;
        
        self.product_info = info;
        // refresh
        [self updateUserInterface];
    }
}

- (void)request: (XMLRPCRequest *)request didSendBodyData: (float)percent{
    
}

- (void)request: (XMLRPCRequest *)request didFailWithError: (NSError *)error{
    [[App sharedApp]alert:[error localizedDescription]];
}

- (BOOL)request: (XMLRPCRequest *)request canAuthenticateAgainstProtectionSpace: (NSURLProtectionSpace *)protectionSpace{
    
    return YES;
    
}

- (void)request: (XMLRPCRequest *)request didReceiveAuthenticationChallenge: (NSURLAuthenticationChallenge *)challenge{
    
}

- (void)request: (XMLRPCRequest *)request didCancelAuthenticationChallenge: (NSURLAuthenticationChallenge *)challenge{
    
}
@end
