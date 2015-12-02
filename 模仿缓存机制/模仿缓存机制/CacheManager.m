//
//  CacheManager.m
//  模仿缓存机制
//
//  Created by lanou3g on 15/11/21.
//  Copyright © 2015年 陈伟. All rights reserved.
//

#import "CacheManager.h"
static NSCache *s_imageCache = nil;
@implementation CacheManager
+ (NSCache *)Cache{
    if (s_imageCache == nil) {
        s_imageCache = [[NSCache alloc] init];
        s_imageCache.name = @"iamgeCache";
    }
    return s_imageCache;
}

+ (NSString *)cachePath{
    NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    return document;
}

+ (unsigned long long)cacheBytesCount{
    NSFileManager *manager = [NSFileManager defaultManager];
    NSEnumerator *filePathEnumrator = [[manager subpathsAtPath:[self cachePath]] objectEnumerator];
    NSString *fileName;
    unsigned long long folderFileSize = 0;
    while ((fileName = [filePathEnumrator nextObject]) != nil) {
        NSString *absoluteFilePath = [[self cachePath] stringByAppendingPathComponent:fileName];
        folderFileSize += [[manager attributesOfItemAtPath:absoluteFilePath error:nil] fileSize];
            }
    return folderFileSize;

}

+ (void)clearCache{
    [[NSFileManager defaultManager] removeItemAtPath:[self cachePath] error:nil];
    [[NSFileManager defaultManager] createDirectoryAtPath:[self cachePath] withIntermediateDirectories:YES attributes:nil error:nil];
    [[self Cache] removeAllObjects];
}

@end
