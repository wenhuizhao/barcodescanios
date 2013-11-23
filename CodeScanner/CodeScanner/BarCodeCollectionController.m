//
//  BarCodeCollectionController.m
//  CodeScanner
//
//  Created by Jack on 13-11-14.
//  Copyright (c) 2013年 violetmoon. All rights reserved.
//

#import "BarCodeCollectionController.h"
#import "BarCodeCollectionCell.h"
#import "ISqlite.h"
#import "BarCode.h"
#import "BrowseController.h"

@interface BarCodeCollectionController () <UICollectionViewDataSource,UICollectionViewDelegate>

@end

@implementation BarCodeCollectionController{
    __weak IBOutlet UICollectionView *collection_view;
    
}

@synthesize bar_codes;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    collection_view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg-pattern"]];
    self.navigationItem.title = @"条形码";
    MTKObservePropertySelf(bar_codes, NSMutableArray*, {
        [collection_view reloadData];
    });
}

- (void)viewDidAppear:(BOOL)animated{
//    self.bar_codes = [ISqlite findAll:[BarCode class]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

#pragma - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return bar_codes.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify_of_cell = @"BarCodeCollectionCell";
    BarCodeCollectionCell *cell = nil;
    cell = (BarCodeCollectionCell*)[collectionView dequeueReusableCellWithReuseIdentifier:identify_of_cell forIndexPath:indexPath];
    if (!cell) {
        cell = [[BarCodeCollectionCell alloc] init];
    }
    [cell setBarCode:[bar_codes objectAtIndex:[indexPath row]]];
    return cell;
}

#pragma - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%d",[indexPath row]);
    BrowseController *bc = [BrowseController browser];
    [self.navigationController pushViewController:bc
                                         animated:YES];
    bc.bar_codes = bar_codes;
    bc.index_of_bar_code = [NSNumber numberWithInt:[indexPath row]];
}

@end
