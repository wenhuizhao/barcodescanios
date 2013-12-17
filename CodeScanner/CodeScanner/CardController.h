//
//  CardController.h
//  CodeScanner
//
//  Created by Jack on 13-12-2.
//  Copyright (c) 2013年 violetmoon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardIO.h"
#import "IZValueSelectorView.h"

@interface CardController : UIViewController <CardIOPaymentViewControllerDelegate,IZValueSelectorViewDataSource,IZValueSelectorViewDelegate>
{
    __weak IZValueSelectorView *value_select_view;
}
@property (weak, nonatomic) IBOutlet IZValueSelectorView *value_select_view;

@end
