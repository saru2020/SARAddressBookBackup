SARAddressBookBackup
====================

	An iOS library to take Backup of the device contacts as .vcf file.

<b>Instructions :</b>

	(i) Copy/Include the "SARAddressBookBackup.h" & "SARAddressBookBackup.m" into your project.
	(ii) Copy/Include  "MessageUI.framework" & "AddressBook.framework" into your project.
	That's it. Your done.

<br/>

	Also, the Example project shows on how to email the .vcf file.

<b>Usage :</b>
	
	addressBook = [[SARAddressBookBackup alloc]init];
    addressBook.backupPath = [self applicationDocumentsDirectory];//(Optional). If not given, then the backup
    // file is stored under the Documents directory.
    __weak SARAddressBookBackup *addressBook_weak = addressBook;
    __weak SARViewController *self_weak = self;
    addressBook.backupCompletionStatusBlock = ^(NSString *status){
        if ( status == ACCESSDENIED) {
            NSLog(@"ACCESSDENIED : %@",ACCESSDENIED);
        }
        else if ( status == BACKUPFAILED) {
            NSLog(@"BACKUPFAILED : %@",BACKUPFAILED);
        }
        else if ( status == BACKUPSUCCESS) {
            NSLog(@"BACKUPSUCCESS : %@",BACKUPSUCCESS);
            NSLog(@"addressBook.backupPath : %@",addressBook_weak.backupPath);
            [NSTimer scheduledTimerWithTimeInterval:1.0 target:self_weak selector:@selector(emailBackup:) userInfo:addressBook_weak.backupPath repeats:NO];
        }
    };
    [addressBook backupContacts];

