//
//  WHAddressBook.h
//  testtest
//
//  Created by dengweihao on 15/9/17.
//  Copyright (c) 2015年 vcyber. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WHAddressBook : NSObject

@property (nonatomic, assign) NSInteger recordID;

@property (nonatomic, copy) NSString *FirstName;      // FirstName
@property (nonatomic, copy) NSString *LastName;       // LastName
@property (nonatomic, copy) NSString *FullName;       // FullName
@property (nonatomic, copy) NSString *Nickname;       // Nickname
@property (nonatomic, copy) NSString *Companyname;    // Companyname
@property (nonatomic, copy) NSString *JobTitle;       // JobTitle
@property (nonatomic, copy) NSString *DepartmentName; // DepartmentName

@property (nonatomic, strong) NSMutableArray *Emails; // 邮箱

@property (nonatomic, strong) NSDate *Birthday;
@property (nonatomic, copy)   NSString *Note;

@property (nonatomic, strong) NSMutableArray *Phones; // 电话号码

@end
