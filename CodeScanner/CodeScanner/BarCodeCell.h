//
//  BarCodeCell.h
//  CodeScanner
//
//  Created by Jack on 13-11-13.
//  Copyright (c) 2013年 violetmoon. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BarCode;

@interface BarCodeCell : UITableViewCell{
    IBOutlet UIImageView *symbol_image_view;
    IBOutlet UILabel *label_data;
    IBOutlet UILabel *label_type;
    IBOutlet UILabel *label_time;
    IBOutlet UILabel *label_count;

}

@property(nonatomic,strong) UIImageView *symbol_image_view;
@property(nonatomic,strong) UILabel *label_data;
@property(nonatomic,strong) UILabel *label_type;
@property(nonatomic,strong) UILabel *label_time;
@property(nonatomic,strong) UILabel *label_count;

- (void) setBarCode:(BarCode*) sender;

@end
