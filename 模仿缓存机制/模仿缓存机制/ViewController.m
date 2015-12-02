//
//  ViewController.m
//  模仿缓存机制
//
//  Created by lanou3g on 15/11/21.
//  Copyright © 2015年 陈伟. All rights reserved.
//

#import "ViewController.h"
#define  clearcache  @"正在清理缓存..."
@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *imageArray;
    MBProgressHUD *hud;
}

@end
static NSString *idefine = @"cell";
BOOL add = NO;
UITableViewCellEditingStyle style;
@implementation ViewController
- (IBAction)delete:(UIBarButtonItem *)sender {
    style = UITableViewCellEditingStyleDelete;
    add = !add;
    sender.title = add ? @"完成" : @"删除";
    [self.tableView setEditing:add animated:YES];
}
- (IBAction)didClickRefreshUI:(UIBarButtonItem *)sender {
    [self BeginDownload];
}
- (IBAction)didClickClearCache:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"显示" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
       
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = clearcache;
        [hud hide:YES afterDelay:2.0];
        sleep(0.5);
        [CacheManager clearCache];
           }]];
    NSString *string = [NSString stringWithFormat:@"清空缓存大小为%llu",[CacheManager cacheBytesCount]];
    alert.message = string;
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)BeginDownload{
    imageArray = [NSMutableArray array];
    NSString *key = @"http://api.tietuku.com/v2/api/getpiclist?key=aJnHxsVik5mYmpaWxWTImWFvn2aVnMNrmWuXZWaYmJqal8qWlGlqmsOblWmZZ5U=";
    NSURL *url = [NSURL URLWithString:key];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionDownloadTask *task = [[NSURLSession sharedSession] downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSData *content = [NSData dataWithContentsOfURL:location];
        NSDictionary *dic = [content objectFromJSONData];
        imageArray = [dic objectForKey:@"pic"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
    [task resume];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self BeginDownload];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return imageArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSDictionary *item = [imageArray objectAtIndex:indexPath.row];
    cell.textLabel.text = item[@"name"];
    NSString *url = item[@"linkurl"];
    __weak UITableViewCell *wcell = cell;
    [cell.imageView setImageWith:[NSURL URLWithString:url] completion:^(BOOL finished) {
        [wcell setNeedsLayout];
    }];
    return cell;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated{
    [super setEditing:editing animated:YES];
    [self.tableView setEditing:editing animated:YES];
    self.editButtonItem.title = editing ? @"完成":@"删除";
}
/**
 *  编辑第二步
 *
 *  @param tableView
 *  @param indexPath
 *
 *  @return 返回值
 */
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;

}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return style;

}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [imageArray removeObjectAtIndex:indexPath.row];;
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
    }
}

- (BOOL)hidesBottomBarWhenPushed{
    return YES;
}
- (BOOL)prefersStatusBarHidden{
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
