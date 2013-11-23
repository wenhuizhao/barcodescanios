#import "ISqlite.h"
#import <objc/runtime.h>
#import "ISqlModel.h"

@implementation ISqlModel

-(void) save
{
    NSString *table_name = (NSString*)[self class];
    
    Class class = [self class];
    unsigned int outCount;
    objc_property_t *properties = class_copyPropertyList(class,&outCount);
    
    NSMutableArray *property_array = [NSMutableArray new];
    for(int i = 0 ; i<outCount ; i++){
        const char *pName = property_getName(properties[i]);
        NSString *propertyName = [NSString stringWithCString:pName encoding:NSUTF8StringEncoding];
        [property_array addObject:propertyName];
    }
    
    
    [ISqlite openWithName:SQLFILE passeord:PASSWORD];
    if (! [ISqlite isExistedById:[[self valueForKey:@"id"] integerValue] table:table_name])
    {
    // insert.
    __block NSString *execute_text = [NSString stringWithFormat:@"INSERT INTO %@ (",table_name];
    
    [property_array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (idx < property_array.count -1) {
            execute_text = [execute_text stringByAppendingFormat:@"'%@',",(NSString*)obj];
        }
        if(idx == property_array.count -1){
           execute_text = [execute_text stringByAppendingFormat:@"'%@') VALUES (",(NSString*)obj];
        }
    }];
    
    [property_array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        // __NSCFNumber  __NSCFConstantString
        NSString *property = obj;
        NSString *type = [NSString stringWithCString:class_getName([[self valueForKey:property] class]) encoding:NSUTF8StringEncoding];
        
        if (idx < property_array.count -1) {
            if ([type isEqualToString:@"__NSCFNumber"]) {
                execute_text = [execute_text stringByAppendingFormat:@"%d,",[[self valueForKey:property] integerValue]];
            } else {
                NSString *value = [self valueForKey:property];
                value = [value stringByReplacingOccurrencesOfString:@"'" withString:@"''"];

                execute_text = [execute_text stringByAppendingFormat:@"'%@',",value];
            }
        }
        if(idx == property_array.count -1){
            if ([type isEqualToString:@"__NSCFNumber"]) {
                execute_text = [execute_text stringByAppendingFormat:@"%d)",[[self valueForKey:property] integerValue]];
            } else {
                NSString *value = [self valueForKey:property];
                value = [value stringByReplacingOccurrencesOfString:@"'" withString:@"''"];

                execute_text = [execute_text stringByAppendingFormat:@"'%@');",value];
            }
        }
    }];
    
    if (![ISqlite executeUpdate:execute_text]) {
        NSLog(@"INSERT MODEL ERROR...");
    }
    
}
    else
    {
        // update.

        __block NSString *execute_text = [NSString stringWithFormat:@"UPDATE %@  SET ",table_name];
        
        [property_array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            // __NSCFNumber  __NSCFConstantString
            NSString *property = obj;
            NSString *type = [NSString stringWithCString:class_getName([[self valueForKey:property] class]) encoding:NSUTF8StringEncoding];
            
            if (idx < property_array.count -1) {
                if ([type isEqualToString:@"__NSCFNumber"]) {
                    execute_text = [execute_text stringByAppendingFormat:@"%@ = %d,",property,[[self valueForKey:property] integerValue]];
                } else {
                    NSString *value = [self valueForKey:property];
                    value = [value stringByReplacingOccurrencesOfString:@"'" withString:@"''"];

                    execute_text = [execute_text stringByAppendingFormat:@"%@ ='%@',",property,value];
                }
            }
            if(idx == property_array.count -1){
                if ([type isEqualToString:@"__NSCFNumber"]) {
                    execute_text = [execute_text stringByAppendingFormat:@"%@ = %d",property,[[self valueForKey:property] integerValue]];
                } else {
                    NSString *value = [self valueForKey:property];
                    value = [value stringByReplacingOccurrencesOfString:@"'" withString:@"''"];

                    execute_text = [execute_text stringByAppendingFormat:@"%@ = '%@'",property,value];
                }
            }
        }];
        execute_text = [execute_text stringByAppendingFormat:@" WHERE id = %d;",[[self valueForKey:@"id"] integerValue]];
        if (! [ISqlite executeUpdate:execute_text]) {
            NSLog(@"UPDATE MODEL ERROE...");
        }
        
    }
    
    [ISqlite close];
    
}

-(void) delete
{
    [ISqlite openWithName:SQLFILE passeord:PASSWORD];
    NSString *table_name = (NSString*)[self class];
    int id = [[self valueForKey:@"id"] intValue];
    NSString *execute_text = [NSString stringWithFormat:@"DELETE FROM %@ WHERE id = %d;",table_name, id];
    if(! [ISqlite executeUpdate:execute_text]){
        NSLog(@"DELETE MODEL ERROR...");
    }
    [ISqlite close];
}

@end
