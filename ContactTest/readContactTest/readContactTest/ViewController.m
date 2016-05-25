//
//  ViewController.m
//  readContactTest
//
//  Created by dengweihao on 15/9/25.
//  Copyright © 2015年 vcyber. All rights reserved.
//

#import "ViewController.h"
#import <WHGetAllContact/WHGetAllContact.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AddressBookManager *addressBookManager = [[AddressBookManager alloc] init];
    
    [addressBookManager ReadAllPeoples];
    
    if (addressBookManager.isGranted) {
        NSMutableArray *array = [NSMutableArray array];
        
        for (WHAddressBook *addressBook in addressBookManager.contactArray) {
            NSMutableDictionary *tmpDic = [NSMutableDictionary dictionary];
            [tmpDic setValue:addressBook.FullName forKey:@"Name"];
            
            NSMutableArray *subArray = [NSMutableArray array];
            
            for (NSDictionary *PhoneNumDic in addressBook.Phones) {
                NSMutableDictionary *subDic = [NSMutableDictionary dictionary];
                [subDic setValue:[PhoneNumDic objectForKey:@"PhoneNum"] forKey:@"PhoneNum"];
                [subDic setValue:[PhoneNumDic objectForKey:@"ContactType"] forKey:@"ContactType"];
                [subDic setValue:@"" forKey:@"Info"];
                
                [subArray addObject:subDic];
            }
            
            [tmpDic setValue:subArray forKey:@"Tel"];
            
            [array addObject:tmpDic];
        }
        
        NSLog(@"%@", array);

    } else {
        NSLog(@"----未授权----");
    }

    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
