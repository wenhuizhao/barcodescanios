//
//  BrowseController.h
//  CodeScanner
//
//  Created by violetmoon on 13-11-14.
//  Copyright (c) 2013年 violetmoon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BrowseController : UIViewController{
    NSArray *bar_codes;
    NSNumber *index_of_bar_code;
}
@property (nonatomic,strong) NSArray *bar_codes;
@property (nonatomic,strong) NSNumber *index_of_bar_code;

+(BrowseController*) browser;
@end
