//
//  SARAddressBookBackup.m
//  AddressBookBackup
//
//  Created by Saravanan V on 17/05/13.
//  Copyright (c) 2013 Saravanan V. All rights reserved.
//

#import "SARAddressBookBackup.h"
#import <AddressBook/AddressBook.h>

@implementation SARAddressBookBackup
@synthesize backupCompletionStatusBlock;

#pragma mark - Init Methods
- (id)init {
	if ((self = [super init])) {
        self.backupPath = [[NSString alloc]init];
	}
    return self;
}

#pragma mark - Helper Methods
- (NSString *) applicationDocumentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

-(BOOL)isABAddressBookCreateWithOptionsAvailable {
    return &ABAddressBookCreateWithOptions != NULL;
}

-(void)backupContacts {
    ABAddressBookRef addressBook;
    if ([self isABAddressBookCreateWithOptionsAvailable]) {
        CFErrorRef error = nil;
        addressBook = ABAddressBookCreateWithOptions(NULL,&error);
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            // callback can occur in background, address book must be accessed on thread it was created on
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    if ( backupCompletionStatusBlock != nil )
                        backupCompletionStatusBlock(BACKUPFAILED);
                } else if (!granted) {
                    if ( backupCompletionStatusBlock != nil )
                        backupCompletionStatusBlock(ACCESSDENIED);
                } else {
                    // access granted
                    AddressBookUpdated(addressBook, nil, self);
                    CFRelease(addressBook);
                }
            });
        });
    } else {
        // iOS 4/5
        addressBook = ABAddressBookCreate();
        AddressBookUpdated(addressBook, NULL, self);
        CFRelease(addressBook);
    }
}

void AddressBookUpdated(ABAddressBookRef addressBook, CFDictionaryRef info, id selfObject) {
    CFArrayRef people = ABAddressBookCopyArrayOfAllPeople(addressBook);
    NSData *vCardData = (__bridge_transfer NSData*)(ABPersonCreateVCardRepresentationWithPeople(people));
    
    [selfObject writeToFile:vCardData];
};

- (void)writeToFile: (NSData *)data{
    if ( self.backupPath.length <= 0 ) {
        self.backupPath = [self applicationDocumentsDirectory];
    }
    NSError *error = nil;
    NSString *path = [NSString stringWithFormat:@"%@/Contacts_Vcard.vcf",self.backupPath];
//    NSLog(@"path : %@",path);
    [data writeToFile:path options:NSDataWritingAtomic error:&error];
    NSLog(@"Write returned error: %@", [error localizedDescription]);
    
    if (error != nil) {
        if ( backupCompletionStatusBlock != nil )
            backupCompletionStatusBlock(BACKUPFAILED);
        NSLog(@"failed to write to the file.");
    }
    else{
        if ( backupCompletionStatusBlock != nil )
            backupCompletionStatusBlock(BACKUPSUCCESS);
        else
            NSLog(@"backupCompletionStatusBlock is nil");
    }
}


#pragma mark - Other unused codes
- (void)otherCode{
    /*
     ABAddressBookRef addressBook = ABAddressBookCreate();
     NSArray *arrayOfAllPeople = (__bridge_transfer NSArray *) ABAddressBookCopyArrayOfAllPeople(addressBook);
     NSUInteger peopleCounter = 0;
     for (peopleCounter = 0;peopleCounter < [arrayOfAllPeople count]; peopleCounter++){
     ABRecordRef thisPerson = (__bridge ABRecordRef) [arrayOfAllPeople objectAtIndex:peopleCounter];
     NSString *name = (__bridge_transfer NSString *) ABRecordCopyCompositeName(thisPerson);
     NSLog(@"First Name = %@", name);
     
     ABMultiValueRef emails = ABRecordCopyValue(thisPerson, kABPersonEmailProperty);
     
     for (NSUInteger emailCounter = 0; emailCounter < ABMultiValueGetCount(emails); emailCounter++){
     //             And then get the email address itself
     NSString *email = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(emails, emailCounter);
     NSLog(@"Email : %@",email);
     }
     }
     CFRelease(addressBook);
     */
    
    CFErrorRef myError = nil;
    ABAddressBookRef myAddressBook = ABAddressBookCreateWithOptions(NULL, &myError);
    ABAddressBookRequestAccessWithCompletion(myAddressBook,
                                             ^(bool granted, CFErrorRef error) {
                                                 dispatch_async(dispatch_get_main_queue(), ^{
                                                     if (granted) {
                                                         //                                                     NSArray *arrayOfAllPeople = (__bridge_transfer NSArray *) ABAddressBookCopyArrayOfAllPeople(myAddressBook);
                                                         //                                                     NSArray *arrayOfAllPeople = CFBridgingRelease(ABAddressBookCopyArrayOfAllPeople(myAddressBook));
                                                         
//                                                         CFArrayRef _allContacts = ABAddressBookCopyArrayOfAllPeople(myAddressBook);
                                                         
//                                                         NSArray *allContacts = (__bridge_transfer NSArray*)ABAddressBookCopyArrayOfAllPeople(myAddressBook);
                                                         
                                                         NSData *vCardData = (__bridge_transfer NSData*)(ABPersonCreateVCardRepresentationWithPeople(ABAddressBookCopyArrayOfAllPeople(myAddressBook)));
                                                         
                                                         [self writeToFile:vCardData];
                                                     } else {
                                                         // Handle the error
                                                     }
                                                 });
                                             });
    CFRelease(myAddressBook);
    
}

@end
