//
//  App.h
//  CodeScanner
//
//  Created by Jack on 13-11-13.
//  Copyright (c) 2013年 violetmoon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface App : NSObject

+(App*) sharedApp;

-(void) startNewScan;

-(NSString*) getScanID;

-(int) getCurrentSymbolCount;

@end
