//
//  UITableView+Cache.h
//  模仿缓存机制
//
//  Created by lanou3g on 15/11/21.
//  Copyright © 2015年 陈伟. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^SetImageBlock)(BOOL finished);
@interface UIImageView (Cache)
- (void)setImageWith:(NSURL *)url completion:(SetImageBlock)block;
@end
