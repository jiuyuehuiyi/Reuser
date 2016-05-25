//
//  AddressBookManager.m
//  testtest
//
//  Created by dengweihao on 15/9/17.
//  Copyright (c) 2015年 vcyber. All rights reserved.
//

#import "AddressBookManager.h"
#import <AddressBook/AddressBook.h>
#import "WHAddressBook.h"
#import <Contacts/Contacts.h>

@interface AddressBookManager ()

@end

@implementation AddressBookManager

- (void)ReadAllPeoples
{
    __block BOOL isGranted; // 是否授权
    //取得本地通信录句柄
    ABAddressBookRef tmpAddressBook = nil;
    
    if ([[UIDevice currentDevice].systemVersion floatValue]>=6.0) {
        tmpAddressBook=ABAddressBookCreateWithOptions(NULL, NULL);
        dispatch_semaphore_t sema=dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(tmpAddressBook, ^(bool granted, CFErrorRef error){
            isGranted = granted;
            dispatch_semaphore_signal(sema);
        });
        
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    }
    else
    {
        tmpAddressBook = ABAddressBookCreate();
    }
    
    self.isGranted = isGranted;
    if (!isGranted) {
        return ;
    }
    
    //取得本地所有联系人记录
    
    NSArray* tmpPeoples = CFBridgingRelease(ABAddressBookCopyArrayOfAllPeople(tmpAddressBook));
    
    for(id tmpPerson in tmpPeoples)
        
    {
        WHAddressBook *addressBook = [[WHAddressBook alloc] init];
        addressBook.recordID = (int)ABRecordGetRecordID((__bridge ABRecordRef)(tmpPerson));
//        NSLog(@"%ld", (long)addressBook.recordID);
        
        //获取的联系人单一属性:First name
        
        NSString* tmpFirstName = CFBridgingRelease(ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonFirstNameProperty));
        addressBook.FirstName = tmpFirstName;
        
//        NSLog(@"First name:%@", tmpFirstName);
        
        //获取的联系人单一属性:Last name
        
        NSString* tmpLastName = CFBridgingRelease(ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonLastNameProperty));
        addressBook.LastName = tmpLastName;
        
//        NSLog(@"Last name:%@", tmpLastName);
        
        //获取的联系人单一属性:Nickname
        
        NSString* tmpNickname = CFBridgingRelease(ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonNicknameProperty));
        
//        NSLog(@"Nickname:%@", tmpNickname);
        addressBook.Nickname = tmpNickname;
        
        
        //获取的联系人单一属性:Company name
        
        NSString* tmpCompanyname = CFBridgingRelease(ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonOrganizationProperty));
        
//        NSLog(@"Company name:%@", tmpCompanyname);
        addressBook.Companyname = tmpCompanyname;
        
        //获取的联系人单一属性:Full name
        
        NSString *nameString = CFBridgingRelease(ABRecordCopyCompositeName((__bridge ABRecordRef)tmpPeoples));
        
        NSString *tmpFullName = nameString;
        if (nameString != nil) {
            tmpFullName = nameString;
        } else {
            if (tmpLastName != nil)
            {
                if (tmpFirstName != nil) {
                    tmpFullName = [NSString stringWithFormat:@"%@ %@", tmpLastName, tmpFirstName];
                } else {
                    tmpFullName = [NSString stringWithFormat:@"%@", tmpLastName];
                }
                
            } else {
                if (tmpFirstName != nil) {
                    tmpFullName = [NSString stringWithFormat:@"%@", tmpFirstName];
                } else {
                    if (tmpCompanyname != nil) {
                        tmpFullName = [NSString stringWithFormat:@"%@", tmpCompanyname];
                    } else {
                        tmpFullName = NULL;
                    }
                }
            }
        }
        addressBook.FullName = tmpFullName;
//        NSLog(@"FullName:%@", tmpFullName);
        
        
        //获取的联系人单一属性:Job Title
        
        NSString* tmpJobTitle= CFBridgingRelease(ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonJobTitleProperty));
        
//        NSLog(@"Job Title:%@", tmpJobTitle);
        addressBook.JobTitle = tmpJobTitle;
        
        
        //获取的联系人单一属性:Department name
        
        NSString* tmpDepartmentName = CFBridgingRelease(ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonDepartmentProperty));
        
//        NSLog(@"Department name:%@", tmpDepartmentName);
        addressBook.DepartmentName = tmpDepartmentName;
        
        //获取的联系人单一属性:Email(s)
        
        ABMultiValueRef tmpEmails = ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonEmailProperty);
        
        for(NSInteger j = 0; j<ABMultiValueGetCount(tmpEmails); j++)
            
        {
            NSString* tmpEmailIndex = CFBridgingRelease(ABMultiValueCopyValueAtIndex(tmpEmails, j));
            [addressBook.Emails addObject:tmpEmailIndex];
//            NSLog(@"Emails%ld:%@", (long)j, tmpEmailIndex);
        }
        CFRelease(tmpEmails);
        
        //获取的联系人单一属性:Birthday
        
        NSDate* tmpBirthday = CFBridgingRelease(ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonBirthdayProperty));
        addressBook.Birthday = tmpBirthday;
        
//        NSLog(@"Birthday:%@", tmpBirthday);
        
        //获取的联系人单一属性:Note
        
        NSString* tmpNote = CFBridgingRelease(ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonNoteProperty));
        addressBook.Note = tmpNote;
        
//        NSLog(@"Note:%@", tmpNote);
        
        //获取的联系人单一属性:Generic phone number
        
        ABMultiValueRef tmpPhones = ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonPhoneProperty);
        
        for(NSInteger j = 0; j < ABMultiValueGetCount(tmpPhones); j++)
        {
            NSMutableDictionary *subDic = [NSMutableDictionary dictionary];
            NSString * personPhoneLabel = (__bridge NSString*)ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(tmpPhones, j));
//            NSLog(@"personPhoneLabel:%@", personPhoneLabel);
            [subDic setObject:personPhoneLabel forKey:@"ContactType"];
            
            NSString* tmpPhoneIndex = CFBridgingRelease(ABMultiValueCopyValueAtIndex(tmpPhones, j));
//            NSLog(@"tmpPhoneIndex%ld:%@", (long)j, tmpPhoneIndex);
            [subDic setObject:tmpPhoneIndex forKey:@"PhoneNum"];
            
            [addressBook.Phones addObject:subDic];
        }
        CFRelease(tmpPhones);
        
        [self.contactArray addObject:addressBook];
        
    }
    
    //释放内存
    CFRelease(tmpAddressBook);
    
}

- (NSMutableArray *)contactArray
{
    if (!_contactArray) {
        _contactArray = [NSMutableArray array];
    }
    return _contactArray;
}

@end
