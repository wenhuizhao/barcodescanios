//
//  ViewController.m
//  CodeScanner
//
//  Created by violetmoon on 13-11-8.
//  Copyright (c) 2013年 violetmoon. All rights reserved.
//

#import "HomeController.h"
#import <AVFoundation/AVFoundation.h>  
#import "BarCodeController.h"
#import "UIImage+Resize.h"
#import "UIImage+FixRotation.h"
#import "FlatUIKit.h"
#import "SoundManager.h"
#import "BarCode.h"
#import "App.h"
#import "LastScanController.h"
#import "ISqlite.h"
#import "IDevice.h"
#import "ZXingObjC.h"
#import <AFNetworking/AFNetworking.h>

@interface HomeController () <ZBarReaderViewDelegate>

@end

@implementation HomeController{
    
    UIImageView *img_line;
    UIImageView *img_bg;
    UIButton *button_flash;
    UIButton *current_scan;
    
    UIImage *target_image;
    ZBarSymbol *target_symbol;
    CGRect image_rect;
    
    BOOL play_sound_flag;
    
    
}

- (void)goLastScanController:(id)sender {
    
    LastScanController *c = [[LastScanController alloc]initWithNibName:[LastScanController description] bundle:nil];
    
    [self.navigationController pushViewController:c animated:YES];
}

- (void)upgradeCountOfScan:(NSNotification*) aNotification{
    if (current_scan) {
        [current_scan setTitle:[NSString stringWithFormat:@"本次扫描 %d 个",[[App sharedApp] getCurrentSymbolCount]] forState:0];
    }
}

- (void)setButtonStateOfFalsh{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device.torchActive == NO) {
        [button_flash setImage:[UIImage imageNamed:@"on-button"] forState:UIControlStateNormal];
        button_flash.$size = [UIImage imageNamed:@"on-button"].size;
    } else {
        [button_flash setImage:[UIImage imageNamed:@"off-button"] forState:UIControlStateNormal];
        button_flash.$size = [UIImage imageNamed:@"off-button"].size;
    }
}

- (void)openFlashlight{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device hasTorch]) {
        [device lockForConfiguration:nil];
        [device setTorchMode: !device.torchActive ? AVCaptureTorchModeOn : AVCaptureTorchModeOff];
        [device unlockForConfiguration];
    }
    [self setButtonStateOfFalsh];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.videoQuality = UIImagePickerControllerQualityTypeIFrame960x540;
    
    self.navigationItem.title = @"Barcode Scanner";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(upgradeCountOfScan:) name:@"upgradeCountOfScan" object:nil];
    
    if ([UIScreen mainScreen].bounds.size.height == 568) {
        img_bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home-bg-568h"]];
        [self.view addSubview:img_bg];
    } else {
        img_bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home-bg"]];
        [self.view addSubview:img_bg];
    }
    
    img_line = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scan-line"]];
    img_line.$y = self.view.center.y;
    img_line.$x = self.view.center.x - [UIImage imageNamed:@"scan-line"].size.width / 2;
    [self.view addSubview:img_line];
    
    button_flash = [[UIButton alloc] init];
    [button_flash addTarget:self action:@selector(openFlashlight) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button_flash];
    [self setButtonStateOfFalsh];
    button_flash.$x = 30;
    button_flash.$y = 30;
    

}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"Sound"] == nil) {
        play_sound_flag = YES;
    } else {
        play_sound_flag =  [[[NSUserDefaults standardUserDefaults] objectForKey:@"Sound"] isEqualToString:@"YES"] ? YES : NO;
    }
    if (!current_scan) {
        current_scan = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *img = [UIImage imageNamed:@"current-scan"];
        [current_scan setBackgroundImage:img forState:UIControlStateNormal];
//        current_scan.alpha = 0.6;
        current_scan.$size = img.size;
        current_scan.$x = self.view.center.x - img.size.width/2;
        current_scan.$y = self.view.center.y - img.size.height/2+130;
        [self.view addSubview:current_scan];
    }
    [current_scan setTitleColor:[UIColor whiteColor] forState:0];
    [current_scan addTarget:self action:@selector(goLastScanController:) forControlEvents:UIControlEventTouchUpInside];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"upgradeCountOfScan" object:nil];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma overwrite;
- (void) readerView: (ZBarReaderView*) readerView didReadSymbols: (ZBarSymbolSet*) syms fromImage: (UIImage*) image {
    // QR-Code,EAN-13,CODE-39,CODE-93,I2/5
    
    [readerDelegate imagePickerController: (UIImagePickerController*)self didFinishPickingMediaWithInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                                                         image,UIImagePickerControllerOriginalImage,
                                                                                                         syms, ZBarReaderControllerResults,nil]];
    ZBarSymbol *sym = nil;
    for (ZBarSymbol *s in syms){
        NSLog(@"%@",s.typeName);
        sym = s;
    }
    
    NSLog(@"%d %@ %@",sym.type, sym.typeName,sym.data);
    
    /*识别二维码的类型*/
    int format = -1;
    
    if ([sym.typeName isEqualToString:@"EAN-13"]) {
        format = kBarcodeFormatEan13;
    }
    if ([sym.typeName isEqualToString:@"EAN-8"]) {
        format = kBarcodeFormatEan8;
    }
    if ([sym.typeName isEqualToString:@"QR-Code"]) {
        format = kBarcodeFormatQRCode;
    }
    if ([sym.typeName isEqualToString:@"I2/5"]) {
        format = kBarcodeFormatITF;
    }
    if ([sym.typeName isEqualToString:@"Codabar"]) {
        format = kBarcodeFormatCodabar;
    }
    if ([sym.typeName isEqualToString:@"CODE-39"]) {
        format = kBarcodeFormatCode39;
    }
    if ([sym.typeName isEqualToString:@"CODE-128"]) {
        format = kBarcodeFormatCode128;
    }
    
    if (format==-1) {
        return;
    }
    
    /*生成图片*/
    NSError* error = nil;
    ZXMultiFormatWriter* writer = [ZXMultiFormatWriter writer];
    ZXBitMatrix* result = [writer encode:sym.data
                                  format:format
                                   width:320
                                  height:200
                                   error:&error];
    if (result) {
        CGImageRef generated_image = [[ZXImage imageWithMatrix:result] cgimage];
         target_image = [UIImage imageWithCGImage:generated_image];
    } else {
        NSString* errorMessage = [error localizedDescription];
        NSLog(@"%@",errorMessage);
    }
    
///**修改需求
//    /*特殊情况,取图失败*/
//    if (sym.bounds.size.width==0 || sym.bounds.size.height==0) {
//        NSLog(@"IMAGE ERROR");
//        return;
//    }
//    
//    /*裁剪图片*/
//    CGRect r = sym.bounds;
//    if(r.size.width <= 32 && r.size.height <= 32)
//        return;
//    r = CGRectInset(r, -24, -24);
//    
//    CGPoint cp = sym.bounds.origin;
//    CGPoint p = CGPointMake(CGRectGetMidX(r), CGRectGetMidY(r));
//    p = CGPointMake((p.x * 3 + cp.x) / 4, (p.y * 3 + cp.y) / 4);
//    
//    CGRect cr = sym.bounds;
//    r.origin = cr.origin;
//    r.size.width = (r.size.width * 3 + cr.size.width) / 4;
//    r.size.height = (r.size.height * 3 + cr.size.height) / 4;
//    image = [image croppedImage:r];

    
    
    /*构建二维码模型*/
    BarCode *bar_code = [BarCode new];
    bar_code.type = sym.typeName;
    bar_code.data = sym.data;
    time_t now;
    time(&now);
    bar_code.time = [NSString stringWithFormat:@"%.f",(float)now];
    bar_code.count = 1;     // 默认数量
    if (format == kBarcodeFormatQRCode) {
        NSString *token, *customerId, *tip;
        NSArray *strArr = [bar_code.data componentsSeparatedByString:@","];
        for (NSString *str in strArr) {
            NSArray *rs = [str componentsSeparatedByString:@":"];
            if ([(NSString*)[rs objectAtIndex:0] isEqualToString:@"token"]) {
                token = rs[1];
            } else if ([(NSString*)[rs objectAtIndex:0] isEqualToString:@"customerId"]) {
                customerId = rs[1];
            } else if ([(NSString*)[rs objectAtIndex:0] isEqualToString:@"tip"]) {
                tip = rs[1];
            }
        }
        NSLog(@"token:%@, customerId:%@, tip:%@",token, customerId, tip);
        NSString *amount = @"100.0";  //test amount
        NSURL *url = [NSURL URLWithString:@"http://test.goodchinese.com/transactions"];
        AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                token, @"transaction[credit_card_token]",
                                customerId, @"transaction[customer_id]",
                                amount, @"transaction[amount]",
                                @"1", @"transaction[submit_for_settlement]",
                                @"json", @"format",
                                nil];
        NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:@"/transactions" parameters: params];
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                            success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON){
                                                                                                NSString *status = [NSString stringWithFormat:@"%@", [JSON valueForKeyPath:@"status"]];
                                                                                                NSLog(@"Response :%@", status);
                                                                                    
                                                                                            }
                                                                                            failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                                NSString *errorMsg = [NSString stringWithFormat:@"%@", [JSON valueForKeyPath:@"error"]];
                                                                                                
                                                                                                NSLog(@"error:%@", errorMsg);
                                                                                              
                                                                                            }
                                             ];
        [operation start];

        
    }
    
    /*判断二维码是否已经扫描过*/
    NSArray *bar_code_ids = [ISqlite findIdsByWhere:[NSString stringWithFormat:@"data = '%@' and scanID = '%@';",bar_code.data,[[App sharedApp] getScanID]] class:[BarCode class]];
    BOOL scaned_flag = (bar_code_ids.count==0) ? NO : YES;
    if (scaned_flag == YES) /*本次扫描过了*/{
        int tmp_id = [(NSNumber*)[bar_code_ids objectAtIndex:0] intValue];
        BarCode *tmp_bar_code = [ISqlite findById:tmp_id class:[BarCode class]];
        bar_code.count = tmp_bar_code.count + 1;
        bar_code.id = tmp_id;
    } else /*未扫描过*/{
        BarCode *last_bar_code = (BarCode*)[[ISqlite findAll:[BarCode class]] lastObject];
        bar_code.id = last_bar_code.id + 1;
    }
    bar_code.imagePath = [[[[IDevice documentPath] stringByAppendingString:bar_code.time] stringByAppendingString:bar_code.data] stringByAppendingString:@".png"];
    bar_code.scanID = [[App sharedApp] getScanID];
    
    /*保存信息*/
    target_symbol = sym;
    
    if (!target_image) {
        return;
    } else /*保存图片*/{
        [UIImagePNGRepresentation(target_image) writeToFile:bar_code.imagePath atomically:NO];
    }
    
    /*播放音效*/
    if (play_sound_flag == YES) {
        [[SoundManager sharedManager] playSound:@"scan_finished_sound.mp3"];
    }
    
    /*跳转*/
    BarCodeController *aController = [[BarCodeController alloc] initWithNibName:[BarCodeController description] bundle:Nil];
    aController.bar_code = bar_code;
    [self.navigationController pushViewController:aController animated:YES];
    
}
@end
