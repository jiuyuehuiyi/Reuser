//
//  CheckUpdate.m
//  TestUpdate
//
//  Created by dengweihao on 15/10/14.
//  Copyright © 2015年 vcyber. All rights reserved.
//

#import "CheckUpdate.h"

#define APP_URL @"http://itunes.apple.com/lookup?id=739680648"

@interface CheckUpdate ()<UIAlertViewDelegate>

@end

@implementation CheckUpdate

- (void)checkUpdate
{
    
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    __block NSString *localVersion = [infoDict objectForKey:@"CFBundleVersion"];
    NSString *Version =[infoDict objectForKey:@"CFBundleShortVersionString"];
    
    NSLog(@"本地版本号为:%@ 测试版本号为:%@", Version, localVersion);

    NSURL *urlStr = [NSURL URLWithString:APP_URL];
    NSURLRequest *request= [NSURLRequest requestWithURL:urlStr];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *appInfoDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
        if (error) {
            NSLog(@"error: %@", error.description);
            return ;
        }
        NSArray *resultsArray = [appInfoDic objectForKey:@"results"];
        if([resultsArray count]){
            NSDictionary *infoDic = [resultsArray objectAtIndex:0];
            NSString *newVersion = [infoDic objectForKey:@"version"];
            self.trackViewUrl = [infoDic objectForKey:@"trackViewUrl"];
            if(![localVersion isEqualToString:newVersion])
            {
                NSString *message=[[NSString alloc] initWithFormat:@"当前版本为%@，最新版本为%@", localVersion, newVersion];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"检测版本更新"
                                                                message:message
                                                               delegate:self
                                                      cancelButtonTitle:@"取消"
                                                      otherButtonTitles:@"更新", nil];
                [self performSelectorOnMainThread:@selector(showAlert:) withObject:alert waitUntilDone:YES];
                [alert show];
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"检测版本更新"
                                                                message:@"已经是最新版本了"
                                                               delegate:self
                                                      cancelButtonTitle:@"取消"
                                                      otherButtonTitles:nil, nil];
                [alert show];
            }
        } else {
            NSLog(@"error: resultsArray==nil");
            return;
        }


    }];
    [dataTask resume];
}

- (void)showAlert:(UIAlertView *)alert
{
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"%ld", buttonIndex);
    if(buttonIndex == 1){
        NSURL *url = [NSURL URLWithString:self.trackViewUrl];
        [[UIApplication sharedApplication] openURL:url];
    }
}

@end
