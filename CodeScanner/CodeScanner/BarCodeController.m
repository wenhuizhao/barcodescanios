//
//  BarCodeController.m
//  CodeScanner
//
//  Created by Jack on 13-11-11.
//  Copyright (c) 2013年 violetmoon. All rights reserved.
//

#import "BarCodeController.h"
#import "ZBarSDK.h"
#import "FlatUIKit.h"
#import "UIImage+RoundedCorner.h"
#import "BarCode.h"
#import "ISqlite.h"
#import "IDevice.h"
#import "App.h"

@interface BarCodeController (){
    
}
@end

@implementation BarCodeController{
    __weak IBOutlet UIImageView *symbol_image_view;
    __weak IBOutlet UIButton *button_rescan;
    __weak IBOutlet UIButton *button_save;
    __weak IBOutlet UILabel *label_type;
    __weak IBOutlet UILabel *label_data;
    __weak IBOutlet UILabel *label_time;
    __weak IBOutlet UIStepper *step;
    __weak IBOutlet UITextField *tf_count;
}
@synthesize bar_code;

- (void)updateUserinterface/*更新用户界面*/{
    label_data.text = bar_code.data;
    label_type.text = bar_code.type;
    NSDateFormatter *dateformat=[[NSDateFormatter alloc] init];
    [dateformat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    label_time.text =[dateformat stringFromDate:[NSDate dateWithTimeIntervalSince1970:bar_code.time.floatValue]];
    symbol_image_view.image = [UIImage imageWithCGImage:[UIImage imageWithContentsOfFile:bar_code.imagePath].CGImage
                                                  scale:1 orientation:UIImageOrientationRight];
    tf_count.text = [NSString stringWithFormat:@"%d",bar_code.count];
    step.value = (double)bar_code.count;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)save:(id)sender{
    [bar_code save];
    [self goBack];
}

- (IBAction)delete:(id)sender{
    [bar_code delete];
    [self goBack];
}

- (void)setCountOfTF:(id) sender /*点击step触发*/{
    [tf_count setText:[NSString stringWithFormat:@"%d",(int)step.value]];
    bar_code.count = (int)step.value;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"Bar Code";
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg-pattern"]]];

    /*Change Navigation Back Button With Image*/
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:@"left-arrow"];
    [backButton setBackgroundImage:image forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    backButton.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton] ;
    self.navigationItem.leftBarButtonItem = backBarButtonItem;
    
    step.minimumValue = 1;
    step.maximumValue = 1000;
    [step addTarget:self action:@selector(setCountOfTF:) forControlEvents:UIControlEventValueChanged];
    
    // KVO
    MTKObservePropertySelf(bar_code, BarCode*, {
        [self updateUserinterface];
    });

}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) showSaveButton:(BOOL) sender{
    button_save.hidden = !sender;
}
- (void) showDeleteButton:(BOOL) sender{
    button_rescan.hidden = !sender;
}
- (void) showStep:(BOOL) sender{
    step.hidden = !sender;
}
@end
