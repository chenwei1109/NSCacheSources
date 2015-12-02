//
//  UITableView+Cache.m
//  模仿缓存机制
//
//  Created by lanou3g on 15/11/21.
//  Copyright © 2015年 陈伟. All rights reserved.
//

#import "UIImageView+Cache.h"
#import <CommonCrypto/CommonCrypto.h>
#import "CacheManager.h"

@interface NSURL (md5)
- (NSString *)md5;
@end
@implementation NSURL (md5)

- (NSString *)md5{
    CC_MD5_CTX md5;
    CC_MD5_Init(&md5);
    NSData *data =[self.absoluteString dataUsingEncoding:NSUTF8StringEncoding];
    CC_MD5_Update(&md5, data.bytes, (int)data.length);
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &md5);
    NSString *s = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                  digest[0], digest[1],
                   digest[2], digest[3],
                   digest[4], digest[5],
                   digest[6], digest[7],
                   digest[8], digest[9],
                   digest[10], digest[11],
                   digest[12], digest[13],
                   digest[14], digest[15]];
    return s;
}

@end

@implementation UIImageView (Cache)

- (void)setImageWith:(NSURL *)url completion:(SetImageBlock)block{
    __block NSData *imageData = [[CacheManager Cache] objectForKey:url.md5];
    if (imageData != nil) {
        NSLog(@"缓存加载图片");
        UIImage *images = [UIImage imageWithData:imageData];
        self.image = images;
        block(YES);
        return;
    }
    NSString *file = [[CacheManager cachePath] stringByAppendingFormat:@"/%@.jpg",url.md5];
    imageData = [NSData dataWithContentsOfFile:file];
    if (imageData != nil) {
        NSLog(@"本地加载图片");
        UIImage *image = [UIImage imageWithData:imageData];
        self.image = image;
        [[CacheManager Cache] setObject:imageData forKey:url.md5];
        block(YES);
        return;
    }
    
    NSURLSessionDownloadTask *task = [[NSURLSession sharedSession] downloadTaskWithRequest:[NSURLRequest requestWithURL:url] completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSURL *fileURl = [NSURL fileURLWithPath:file];
        NSFileManager *manager = [NSFileManager defaultManager];
        [manager copyItemAtURL:location toURL:fileURl error:nil];
        imageData = [NSData dataWithContentsOfURL:fileURl];
        [[ CacheManager Cache] setObject:imageData forKey:url.md5];
        NSLog(@"网络加载图片");
        dispatch_async(dispatch_get_main_queue(), ^{
            self.image = [UIImage imageWithData:imageData];
            block(YES);
        });
    }];
    [task resume];
    
}
@end
