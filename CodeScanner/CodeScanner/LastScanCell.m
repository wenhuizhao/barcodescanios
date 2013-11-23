//
//  LastScanCell.m
//  CodeScanner
//
//  Created by Jack on 13-11-13.
//  Copyright (c) 2013年 violetmoon. All rights reserved.
//

#import "LastScanCell.h"
#import "BarCode.h"

@implementation LastScanCell{
    BarCode *bar_code;
}

@synthesize symbol_image_view,label_data,label_time,label_type;

+ (float) height{
    return 160.f;
}
- (void) setBarCode:(BarCode*) sender{
    bar_code = sender;
    
    /*加载图片*/
//    NSData *img_data = [NSData dataWithContentsOfFile:bar_code.imagePath];
//    UIImage *img = [UIImage imageWithCGImage:[UIImage imageWithData:img_data].CGImage
//                                       scale:1.0f
//                                 orientation:UIImageOrientationRight];
//    self.symbol_image_view.image = img;
    
    
    
    self.label_type .text = bar_code.type;
    self.label_data.text = bar_code.data;
    
    NSTimeInterval seconds = [bar_code.time floatValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:seconds];
    NSDateFormatter *dateformat=[[NSDateFormatter alloc] init];
    [dateformat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString * time = [dateformat stringFromDate:date];
    self.label_time.text = time;

}

- (IBAction)delete:(id)sender{
    [bar_code delete];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.alpha = 0;
        self.$x = 320;
    } completion:^(BOOL finished) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"loadLastScan" object:nil];
    }];
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
