SARAddressBookBackup
====================

	An iOS library to take Backup of the device contacts as .vcf file.

<b>Instructions :</b>

	(i) Copy/Include the "SARAddressBookBackup.h" & "SARAddressBookBackup.m" into your project.
	(ii) Copy/Include  "MessageUI.framework" & "AddressBook.framework" into your project.
	That's it. Your done.

<br/>

	Also, the Example project illustrates on how to email the .vcf file.

<br/>

<b>Installation :</b><br/>
Add the following to your <a href="http://cocoapods.org/">CocoaPods</a> Podfile

	pod 'SARAddressBookBackup'

or clone as a git submodule,

or just copy SARAddressBookBackup.h and .m into your project.

<br/>

<b>Usage :</b>
	
	SARAddressBookBackup *addressBook = [[SARAddressBookBackup alloc]init];
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




<br/>
<br/>

## 👨🏻‍💻 Author
[1.1]: http://i.imgur.com/tXSoThF.png
[1]: http://www.twitter.com/saruhere

* Saravanan [![alt text][1.1]][1]

<a class="bmc-button" target="_blank" href="https://www.buymeacoffee.com/saru2020"><img src="https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png" alt="Buy me a coffee/beer" style="height: 41px !important;width: 174px !important;box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;-webkit-box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;"><span style="margin-left:5px"></span></a>
