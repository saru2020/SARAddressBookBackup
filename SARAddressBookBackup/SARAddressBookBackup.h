//
//  SARAddressBookBackup.h
//  AddressBookBackup
//
//  Created by Saravanan V on 17/05/13.
//  Copyright (c) 2013 Saravanan V. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^backupCompletionStatus)( NSString* );
#define UNIQUE_KEY( x ) NSString * const x = @#x

static UNIQUE_KEY( BACKUPSUCCESS );
static UNIQUE_KEY( BACKUPFAILED );
static UNIQUE_KEY( ACCESSDENIED );

@interface SARAddressBookBackup : NSObject

@property (nonatomic, strong)NSString *backupPath;
@property (nonatomic, strong)backupCompletionStatus backupCompletionStatusBlock;

-(void)backupContacts;

@end
