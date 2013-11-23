#import <objc/runtime.h>
#import "IDevice.h"
#import "FMDatabase.h"
#import "ISqlite.h"

static FMDatabase *db;

@implementation ISqlite

+(id) db{
    if (! db) {
        [ISqlite openWithName:SQLFILE passeord:PASSWORD];
    }
    return db;
}

+(void) openWithName:(NSString *)name passeord:(NSString*) password{
    NSString *file_name = [[name componentsSeparatedByString:@"."] objectAtIndex:0];
    NSString *file_type = [[name componentsSeparatedByString:@"."] objectAtIndex:1];
    
    NSString *source_file_path = [[NSBundle mainBundle] pathForResource:file_name ofType:file_type];
    NSString *taget_file_path = [[IDevice documentPath] stringByAppendingFormat:@"%@.%@",file_name,file_type];
    if ([[NSFileManager defaultManager] fileExistsAtPath:source_file_path]) {
        if (! [[NSFileManager defaultManager] fileExistsAtPath:taget_file_path]) {
            // copy file.
            NSError *error;
            [[NSFileManager defaultManager] copyItemAtPath:source_file_path toPath:taget_file_path error:&error];
            if (error) {
                NSLog(@"COPY SQLITE FILE ERROR...%@",error);
            } else {
                NSLog(@"COPY SQLITE FILE SUCCESS...");
                [ISqlite openWithPath:taget_file_path password:password];
            }
        } else {
            // open file.
            [ISqlite openWithPath:taget_file_path password:password];
        }
    } else{
        NSLog(@"SQLITE FILE NOT EXISTS IN PROJECT... Go to : Target -> Build Phases -> copy bundle Resources");
    }
}

+(void) openWithName:(NSString*) name{
    NSString *file_name = [[name componentsSeparatedByString:@"."] objectAtIndex:0];
    NSString *file_type = [[name componentsSeparatedByString:@"."] objectAtIndex:1];
    
    NSString *source_file_path = [[NSBundle mainBundle] pathForResource:file_name ofType:file_type];
    NSString *taget_file_path = [[IDevice documentPath] stringByAppendingFormat:@"%@.%@",file_name,file_type];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:source_file_path]) {
        if (! [[NSFileManager defaultManager] fileExistsAtPath:taget_file_path]) {
            // copy file.
            NSError *error;
            [[NSFileManager defaultManager] copyItemAtPath:source_file_path toPath:taget_file_path error:&error];
            if (error) {
                NSLog(@"COPY SQLITE FILE ERROR...%@",error);
            } else {
                NSLog(@"COPY SQLITE FILE SUCCESS...");
                [ISqlite openWithPath:taget_file_path];
            }
        } else {
            // open file.
            [ISqlite openWithPath:taget_file_path];
        }
    } else{
        NSLog(@"SQLITE FILE NOT EXISTS AT PROJECT... Go to : Target -> Build Phases -> copy bundle Resources");
    }
}

+(void) openWithPath:(NSString*) path{
    db = [FMDatabase databaseWithPath:path];
    [db open];
}

+(void) openWithPath:(NSString*) path password:(NSString*) password{
    db = [FMDatabase databaseWithPath:path];
    [db open];
    [db setKey:password];
}



+(BOOL) executeUpdate:(NSString*) str{
    return [db executeUpdate:str];
}

+(NSMutableArray*) findIdsByWhere:(NSString*) where class:(Class) class{
    NSMutableArray *ids = [NSMutableArray new];
    NSObject *res = [class new];
    NSString *table_name = (NSString*)[res class];
    
    
    NSString *execute_text =  [NSString stringWithFormat:@"SELECT id FROM %@ WHERE %@;",table_name,where];
    [ISqlite openWithName:SQLFILE passeord:PASSWORD];
    FMDatabase *db = [ISqlite db];
    FMResultSet *s = [db executeQuery:execute_text];
    while ([s next]) {
        [ids addObject:[NSNumber numberWithInt:[s intForColumnIndex:0]]];
    }
    [ISqlite close];
    
    
    return ids;
}

+(BOOL) isExistedById:(int) id_ table:(NSString*) table_name{
    
    BOOL res;
    NSString *query_string = [NSString stringWithFormat:@"select count(*) from %@ where id='%d';",table_name,id_];
    FMResultSet *s = [db executeQuery:query_string];
    while ([s next]) {
        if([s intForColumnIndex:0]==1){
            res = YES;
        } else {
            res = NO;
        }
    }
    return res;
}

+(id) findById:(int)id_ class:(Class) class{
    NSObject *res = [class new];
    NSString *table_name = (NSString*)[res class];
    //get property list.
    NSMutableArray *property_array = [NSMutableArray new];
    unsigned int outCount;
    objc_property_t *properties = class_copyPropertyList(class,&outCount);
    for(int i = 0 ; i<outCount ; i++){
        const char *pName = property_getName(properties[i]);
        NSString *propertyName = [NSString stringWithCString:pName encoding:NSUTF8StringEncoding];
        [property_array addObject:propertyName];
    }
    
    //search. select
    __block NSString *execute_text = [NSString stringWithFormat:@"SELECT "];
    [property_array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *property = obj;
        if (idx < property_array.count-1) {
            execute_text = [execute_text stringByAppendingFormat:@"%@,",property];

        } else if (idx == property_array.count-1) {
            execute_text = [execute_text stringByAppendingFormat:@"%@",property];
        }
    }];
    execute_text = [execute_text stringByAppendingFormat:@" FROM %@ ",table_name];
    execute_text = [execute_text stringByAppendingFormat:@" WHERE id = %d;",id_];
    
    
    [ISqlite openWithName:SQLFILE passeord:PASSWORD];
    FMResultSet *s = [db executeQuery:execute_text];
    while ([s next]) {
        //__NSCFNumber __NSCFConstantString
        for (int i=0; i<property_array.count; i++) {
            const char * c = class_getName( [[res valueForKey:[property_array objectAtIndex:i]]class] );
            NSString *property_type = [NSString stringWithCString:c encoding:NSUTF8StringEncoding];
            if ([property_type isEqualToString:@"__NSCFNumber"]) {
                [res setValue:[NSNumber numberWithInteger:[s intForColumnIndex:i]] forKey:[property_array objectAtIndex:i]];
            } else if ([property_type isEqualToString:@"__NSCFConstantString"]) {
                [res setValue:[s stringForColumnIndex:i] forKey:[property_array objectAtIndex:i]];
            }
        }
    }
    [ISqlite close];
    
    
    return res;
}

+(NSMutableArray*) findAll:(Class) class{
    NSMutableArray *res = [NSMutableArray new];
    NSString *table_name = (NSString*)[class class];
    NSString *exectue_text = [NSString stringWithFormat:@"SELECT * FROM %@;",table_name];
    
    

    //get property list.
    NSMutableArray *property_array = [NSMutableArray new];
    unsigned int outCount;
    objc_property_t *properties = class_copyPropertyList(class,&outCount);
    for(int i = 0 ; i<outCount ; i++){
        const char *pName = property_getName(properties[i]);
        NSString *propertyName = [NSString stringWithCString:pName encoding:NSUTF8StringEncoding];
        [property_array addObject:propertyName];
    }
    
    
    //build models;
    [ISqlite openWithName:SQLFILE passeord:PASSWORD];
    FMResultSet *s = [db executeQuery:exectue_text];
    while ([s next]) {
        NSObject *model = [class new];
        for (int i=0; i<property_array.count; i++) {
            NSString *property_name = [property_array objectAtIndex:i];
            const char * c = class_getName( [[model valueForKey:property_name]class] );
            NSString *property_type = [NSString stringWithCString:c encoding:NSUTF8StringEncoding];

            if ([property_type isEqualToString:@"__NSCFNumber"]) {
                [model setValue:[NSNumber numberWithInteger:[s intForColumnIndex:i]] forKey:property_name];
            } else if ([property_type isEqualToString:@"__NSCFConstantString"]) {
                [model setValue:[s stringForColumnIndex:i] forKey:property_name];
            }
        }
        [res addObject:model];
    }
    [ISqlite close];
    
    
    return res;
}

+(void) close{
    [db close];
    db = nil;
}


@end
