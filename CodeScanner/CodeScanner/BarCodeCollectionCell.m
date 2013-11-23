//
//  BarCodeCollectionCell.m
//  CodeScanner
//
//  Created by Jack on 13-11-14.
//  Copyright (c) 2013年 violetmoon. All rights reserved.
//

#import "BarCodeCollectionCell.h"
#import "BarCode.h"

@implementation BarCodeCollectionCell{
    BarCode *bar_code;
}

@synthesize label_of_bar_code,label_count;

- (IBAction)goDetail:(id)sender /*显示详细的条形码=>BarCodesController*/{
    
}

- (void) setBarCode:(BarCode*) sender{
    bar_code = sender;
    label_of_bar_code.text = bar_code.data;
    label_count.text = [NSString stringWithFormat:@"%d",bar_code.count];
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
