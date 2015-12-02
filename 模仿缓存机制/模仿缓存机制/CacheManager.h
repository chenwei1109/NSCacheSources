//
//  CacheManager.h
//  模仿缓存机制
//
//  Created by lanou3g on 15/11/21.
//  Copyright © 2015年 陈伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CacheManager : NSObject
+ (NSCache *)Cache;
+ (NSString *)cachePath;
+ (void)clearCache;
+ (unsigned long long)cacheBytesCount;
@end
