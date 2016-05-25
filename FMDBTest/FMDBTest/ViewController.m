//
//  ViewController.m
//  FMDBTest
//
//  Created by dengweihao on 15/12/17.
//  Copyright © 2015年 dengweihao. All rights reserved.
//

#import "ViewController.h"
#import "WHDataBaseCenter.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WHDataBaseCenter *center = [WHDataBaseCenter sharedDataBase];
    
    [center testCreateTable];
    [center testInsertData];
    [center testDeleteData];
    [center testSearchData];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
