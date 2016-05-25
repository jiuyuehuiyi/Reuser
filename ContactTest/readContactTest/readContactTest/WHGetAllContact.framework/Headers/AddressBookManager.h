//
//  AddressBookManager.h
//  testtest
//
//  Created by dengweihao on 15/9/17.
//  Copyright (c) 2015年 vcyber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AddressBookManager : NSObject

@property (nonatomic, strong) NSMutableArray *contactArray;

@property (nonatomic, assign) BOOL isGranted; // 是否授权

/** 读取所有联系人 */
-(void)ReadAllPeoples;

@end
