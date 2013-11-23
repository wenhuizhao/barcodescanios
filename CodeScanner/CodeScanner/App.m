//
//  App.m
//  CodeScanner
//
//  Created by Jack on 13-11-13.
//  Copyright (c) 2013年 violetmoon. All rights reserved.
//

#import "App.h"
#import "BarCode.h"
#import "ISqlite.h"

@implementation App{
    NSString *scanID;
    int currentSymbolCount; // 本次扫描的个数
}

+(App*)sharedApp{
    static App *app = nil;
    if (!app) {
        app = [App new];
    }
    return app;
}

-(void) startNewScan{
    time_t now;
    time(&now);
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:now];
    scanID = [NSString stringWithFormat:@"%.f",date.timeIntervalSince1970];
    
}

-(NSString*) getScanID{
    return scanID;
}

-(int) getCurrentSymbolCount{
    return [ISqlite findIdsByWhere:[NSString stringWithFormat:@"scanID = '%@';",scanID] class:[BarCode class]].count;
}
@end
