
#import <Foundation/Foundation.h>

@interface ISqlModel : NSObject

-(void) save;
-(void) delete;

@end

/* 约定
1. 类名和表明相同
2. id必须存在且为'id'
3. 顺序必须与数据库相同
4. 各个属性必须在init中初始化
*/