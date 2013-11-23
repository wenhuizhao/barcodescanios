//
//  AllBarCodesNavigationController.m
//  CodeScanner
//
//  Created by violetmoon on 13-11-15.
//  Copyright (c) 2013年 violetmoon. All rights reserved.
//

#import "AllBarCodesNavigationController.h"
#import "BarCodeCollectionController.h"
#import "ISqlite.h"
#import "BarCode.h"

@interface AllBarCodesNavigationController ()

@end

@implementation AllBarCodesNavigationController{
    BarCodeCollectionController *collection;
}

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

}
- (void)viewDidAppear:(BOOL)animated{
    if (!collection) {
        collection = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"BarCodesController"];
        [self pushViewController:collection animated:YES];
    }
    collection.bar_codes = [ISqlite findAll:[BarCode class]];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
