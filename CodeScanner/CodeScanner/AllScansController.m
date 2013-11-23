//
//  AllScansController.m
//  CodeScanner
//
//  Created by violetmoon on 13-11-15.
//  Copyright (c) 2013年 violetmoon. All rights reserved.
//

#import "AllScansController.h"
#import "BarCodeCollectionController.h"
#import "BarCode.h"
#import "ISqlite.h"
#import "FMDatabase.h"
#import "AllScansCell.h"

@interface AllScansController () <UICollectionViewDataSource,UICollectionViewDelegate>

@end

@implementation AllScansController{
    NSMutableArray *all_scan_ids;
    NSMutableArray *all_scan_counts;
    IBOutlet UICollectionView *collection_view;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    collection_view.backgroundColor = self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg-pattern"]];
    self.navigationItem.title = @"所有扫描";

}

- (void)viewDidAppear:(BOOL)animated{
    all_scan_ids = [NSMutableArray new];
    all_scan_counts = [NSMutableArray new];
    /*查询所有扫描id*/
    FMDatabase *db = [ISqlite db];
    FMResultSet *rs = [db executeQuery:@"select distinct scanID from BarCode;"];
    while ([rs next]) {
        [all_scan_ids addObject:[rs stringForColumnIndex:0]];

    }
    /*查询所有数量*/
    for (NSString *scanID in all_scan_ids){
        FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"select count(*) from BarCode where scanID = '%@';",scanID]];
        while ([rs next]) {
            int count = [rs intForColumnIndex:0];
            [all_scan_counts addObject:[NSNumber numberWithInt:count]];
        }
    }

    NSAssert(all_scan_counts.count == all_scan_ids.count, @"COUNT NOT EQUAL...");
    
    // 刷新数据
    [collection_view reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return all_scan_ids.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    AllScansCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AllScansCell" forIndexPath:indexPath];
    if (cell) {
        cell.label_count.text = [NSString stringWithFormat:@"%d",[(NSNumber*)[all_scan_counts objectAtIndex:[indexPath row]]intValue]];
    }
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *scanID = [all_scan_ids objectAtIndex:[indexPath row]];
    /*查询barcodes*/
    NSMutableArray *ids = [ISqlite findIdsByWhere:[NSString stringWithFormat:@"scanID=%@",scanID] class:[BarCode class]];
    NSMutableArray *bar_codes = [NSMutableArray new];
    [ids enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        int id_ = [(NSNumber*)obj intValue];
        [bar_codes addObject:[ISqlite findById:id_ class:[BarCode class]]];
    }];
    
    
    BarCodeCollectionController * c  = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"BarCodesController"];
    [self.navigationController pushViewController:c animated:YES];
    c.bar_codes = bar_codes;
}
@end
