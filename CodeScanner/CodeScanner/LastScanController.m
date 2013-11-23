//
//  LastScanController.m
//  CodeScanner
//
//  Created by Jack on 13-11-13.
//  Copyright (c) 2013年 violetmoon. All rights reserved.
//

#import "LastScanController.h"
#import "ISqlite.h"
#import "BarCode.h"
#import "LastScanCell.h"
#import "App.h"

@interface LastScanController () <UITableViewDataSource,UITableViewDelegate>

@end

@implementation LastScanController{
    NSMutableArray *barCodes;
    IBOutlet UITableView *table;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"本次扫描";
    
    /*Change Navigation Back Button With Image*/
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:@"left-arrow"];
    [backButton setBackgroundImage:image forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    backButton.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton] ;
    self.navigationItem.leftBarButtonItem = backBarButtonItem;
    /*-*/
    
    table.delegate = self;
    table.dataSource = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadLastScan:) name:@"loadLastScan" object:nil];
}

- (void)loadLastScan:(NSNotification*) aNotification{
    barCodes = [NSMutableArray new];
    [[ISqlite findIdsByWhere:[NSString stringWithFormat:@"scanID = '%@';",[[App sharedApp] getScanID]] class:[BarCode class]] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSNumber *number = obj;
        int id_ = [number intValue];
        [barCodes addObject:[ISqlite findById:id_ class:[BarCode class]]];
    }];
    [table reloadData];
}

- (void)viewDidAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"loadLastScan" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return barCodes.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [LastScanCell height];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentify = @"LastScanCell";
    LastScanCell *cell = (LastScanCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (!cell) {
        cell = (LastScanCell*)[[[NSBundle mainBundle] loadNibNamed:@"LastScanCell" owner:self options:nil] objectAtIndex:0];
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
