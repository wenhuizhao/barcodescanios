//
//  BarCodeCell.m
//  CodeScanner
//
//  Created by Jack on 13-11-13.
//  Copyright (c) 2013年 violetmoon. All rights reserved.
//

#import "BarCodeCell.h"
#import "BarCode.h"

@implementation BarCodeCell{
    BarCode *bar_code;
}

@synthesize symbol_image_view,label_data,label_time,label_type,label_count;


- (void) setBarCode:(BarCode*) sender{
    bar_code = sender;
    
    NSData *img_data = [NSData dataWithContentsOfFile:bar_code.imagePath];
    UIImage *img = [UIImage imageWithCGImage:[UIImage imageWithData:img_data].CGImage
                                       scale:1.0f
                                 orientation:UIImageOrientationRight];
    
    self.symbol_image_view.image = img;
    self.label_type .text = [@"Type: " stringByAppendingString:bar_code.type];
    self.label_data.text = [@"Data: " stringByAppendingString:bar_code.data];
    self.label_count.text = [@"Count: " stringByAppendingString:[NSString stringWithFormat:@"%d",bar_code.count]];
    NSLog(@"=>%d",bar_code.count);
    
    
    NSTimeInterval seconds = [bar_code.time floatValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:seconds];
    NSDateFormatter *dateformat=[[NSDateFormatter alloc] init];
    [dateformat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString * time = [dateformat stringFromDate:date];
    self.label_time.text = time;
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
