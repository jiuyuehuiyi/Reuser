//
//  ViewController.m
//  TestUpdate
//
//  Created by dengweihao on 15/10/14.
//  Copyright © 2015年 vcyber. All rights reserved.
//

#import "ViewController.h"
#import "CheckUpdate.h"

#define APP_URL @"http://itunes.apple.com/lookup?id=739680648"

@interface ViewController ()<UIAlertViewDelegate>

@property (nonatomic,retain) NSString *trackViewUrl;
@property (nonatomic, strong) CheckUpdate *update;

@end

@implementation ViewController

- (CheckUpdate *)update
{
    if (!_update) {
        _update = [[CheckUpdate alloc] init];
    }
    return _update;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor greenColor];
    
    [self.update checkUpdate];
    
    NSLog(@"%f, %f", [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);

    
    // Do any additional setup after loading the view, typically from a nib.
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
