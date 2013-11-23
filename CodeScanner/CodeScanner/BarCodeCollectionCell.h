//
//  BarCodeCollectionCell.h
//  CodeScanner
//
//  Created by Jack on 13-11-14.
//  Copyright (c) 2013年 violetmoon. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BarCode;

@interface BarCodeCollectionCell : UICollectionViewCell{
    IBOutlet UILabel *label_of_bar_code;
    IBOutlet UILabel *label_count;

}

@property (nonatomic,strong) UILabel *label_of_bar_code;
@property (nonatomic,strong) UILabel *label_count;
- (void) setBarCode:(BarCode*) sender;

@end
