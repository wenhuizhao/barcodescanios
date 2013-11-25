//
//  BrowseController.m
//  CodeScanner
//
//  Created by violetmoon on 13-11-14.
//  Copyright (c) 2013年 violetmoon. All rights reserved.
//

#import "BrowseController.h"
#import "BarCodeController.h"
#import "SearchBarcodeController.h"

@interface BrowseController ()

@end

@implementation BrowseController{
    BarCodeController *bar_code_controller;
    IBOutlet UIButton *left_button;
    IBOutlet UIButton *right_button;
}

@synthesize bar_codes,index_of_bar_code;

-(void) goSearch{
    SearchBarcodeController *s = [SearchBarcodeController search];
    [self.navigationController pushViewController:s animated:YES];
    s.bar_code = bar_code_controller.bar_code;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)gestureHandle:(UISwipeGestureRecognizer*) sender{
    if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
        [self left:nil];
    } else if (sender.direction == UISwipeGestureRecognizerDirectionLeft){
        [self right:nil];
    }
}

- (void)update{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        // animation
        self.view.alpha = 0.6;
    } completion:^(BOOL finished) {
        // result
        NSLog(@"%d",[self.index_of_bar_code integerValue]);
        if (!bar_code_controller) {
            bar_code_controller = [[BarCodeController alloc] initWithNibName:[BarCodeController description] bundle:nil];
            [self.view addSubview:bar_code_controller.view];
            [bar_code_controller showDeleteButton:NO];
            [bar_code_controller showSaveButton:NO];
            [bar_code_controller showStep:NO];
            // 重定位search click 事件
            [bar_code_controller.button_search addTarget:self action:@selector(goSearch) forControlEvents:UIControlEventTouchUpInside];
            
        }
        bar_code_controller.bar_code = [bar_codes objectAtIndex:[index_of_bar_code intValue]];
        [self.view addSubview:left_button];
        [self.view addSubview:right_button];

        self.view.alpha = 1;
    }];

}

- (IBAction)right:(id)sender/*向右滑动*/{
    if (index_of_bar_code.intValue == bar_codes.count-1) {
        return;
    }
    self.index_of_bar_code = [NSNumber numberWithInt:index_of_bar_code.intValue+1];
}

- (IBAction)left:(id)sender/*向左滑动*/{
    if (index_of_bar_code.intValue == 0) {
        return;
    }
    self.index_of_bar_code = [NSNumber numberWithInt:index_of_bar_code.intValue-1];
}

- (void) viewDidLoad{
    [super viewDidLoad];
//    [(UIScrollView*)self.view setContentSize:(CGSize){320,800}];
    
    // bg
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg-pattern"]];
    // KVO
    MTKObservePropertySelf(index_of_bar_code, NSNumber*, {
        [self update];
        // bring
    });
    
    // Gesture
    UISwipeGestureRecognizer *left_ges = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(gestureHandle:)];
    [left_ges setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:left_ges];
    
    UISwipeGestureRecognizer *right_ges = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(gestureHandle:)];
    [right_ges setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:right_ges];


    
}

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (BrowseController*) browser{
    return [[BrowseController alloc] initWithNibName:[BrowseController description] bundle:nil];
}

@end
