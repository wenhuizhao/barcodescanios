#import <Foundation/Foundation.h>

#define kOpenUDIDErrorNone          0
#define kOpenUDIDErrorOptedOut      1
#define kOpenUDIDErrorCompromised   2

@interface IDevice : NSObject

+ (CGSize) screenSize;

+ (NSString*) uuid;

+ (NSString*) valueWithError:(NSError **)error;

+ (NSString*) cachePath;

+ (NSString*) documentPath;

@end
