//
//  BarCodeCollectionController.h
//  CodeScanner
//
//  Created by Jack on 13-11-14.
//  Copyright (c) 2013年 violetmoon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BarCodeCollectionController : UICollectionViewController{
    NSMutableArray *bar_codes;
}
@property (nonatomic,strong) NSMutableArray *bar_codes;
@end
