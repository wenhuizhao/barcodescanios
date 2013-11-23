//
//  HistoryController.m
//  CodeScanner
//
//  Created by Jack on 13-11-11.
//  Copyright (c) 2013年 violetmoon. All rights reserved.
//

#import "AllSymbolController.h"
#import "BarCode.h"
#import "ISqlite.h"
#import "FlatUIKit.h"
#import "BarCodeCell.h"

@interface AllSymbolController ()

@end

@implementation AllSymbolController{
    NSMutableArray *barCodes;
    __weak IBOutlet UITableView *table;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorFromHexCode:@"f3f3f3"];
    
    table.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64-49);
    table.delegate = self;
    table.dataSource = self;
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    barCodes = [ISqlite findAll:[BarCode class]];
    [table reloadData];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return barCodes.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 250;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentify = @"BarCodeCell";
    BarCodeCell *cell = (BarCodeCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (!cell) {
        cell = (BarCodeCell*)[[[NSBundle mainBundle] loadNibNamed:[BarCodeCell description] owner:self options:nil] objectAtIndex:0];
    }
    
    BarCode *bar_code = [barCodes objectAtIndex:[indexPath row]];
    [cell setBarCode:bar_code];
    
//    NSData *img_data = [NSData dataWithContentsOfFile:bar_code.imagePath];
//    UIImage *img = [UIImage imageWithCGImage:[UIImage imageWithData:img_data].CGImage
//                                       scale:1.0f
//                                 orientation:UIImageOrientationRight];
//    
//    cell.symbol_image_view.image = img;
//    cell.label_type .text = bar_code.type;
//    cell.label_data.text = bar_code.data;
//    
//    NSTimeInterval seconds = [bar_code.time floatValue];
//    NSDate *date = [NSDate dateWithTimeIntervalSince1970:seconds];
//    NSDateFormatter *dateformat=[[NSDateFormatter alloc] init];
//    [dateformat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSString * time = [dateformat stringFromDate:date];
//    cell.label_time.text = time;
    
    return cell;
}

#pragma <UITableViewDelegate>
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BarCode *bar_code = [barCodes objectAtIndex:[indexPath row]];
    NSAssert(bar_code!=nil,@"");
}

@end