
#import <Foundation/Foundation.h>

#define SQLFILE @"BarCodes.sqlite"
#define PASSWORD @""

@interface ISqlite : NSObject

+(void) openWithName:(NSString*) name;
+(void) openWithName:(NSString *)name passeord:(NSString*) password;
+(void) openWithPath:(NSString*) path;
+(void) openWithPath:(NSString*) path password:(NSString*) password;

+(id) db;

+(BOOL) executeUpdate:(NSString*) str;
+(BOOL) isExistedById:(int) id_ table:(NSString*) table_name;
+(void) close;

+(NSMutableArray*) findIdsByWhere:(NSString*) where class:(Class) class;
+(id) findById:(int)id_ class:(Class) class;
+(NSMutableArray*) findAll:(Class) class;

@end


/* 使用加密版sqlite
 cd /usr/local/Cellar/sqlcipher/2.1.1
 ./sqlite3
 
 1. 加密一个明文文件
 ./sqlite3 plaintext.db
 ATTACH DATABASE 'encrypted.db' AS encrypted KEY 'Sa1Tr0ng';
 SELECT sqlcipher_export('encrypted');
 DETACH DATABASE encrypted;
 
 2. 解密一个加密文件
 ./sqlite3 encrypted.db
 PRAGMA key = 'Sa1Tr0ng';
 ATTACH DATABASE 'plaintext.db' AS plaintext KEY '';
 SELECT sqlcipher_export('plaintext');
 DETACH DATABASE plaintext;
 
*/