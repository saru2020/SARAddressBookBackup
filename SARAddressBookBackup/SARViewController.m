//
//  SARViewController.m
//  SARAddressBookBackup
//
//  Created by Saravanan V on 17/05/13.
//  Copyright (c) 2013 Saravanan V. All rights reserved.
//

#import "SARViewController.h"
#import <AddressBook/AddressBook.h>
#import <MessageUI/MessageUI.h>

@interface SARViewController ()

@end

@implementation SARViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    addressBook = [[SARAddressBookBackup alloc]init];
    addressBook.backupPath = [self applicationDocumentsDirectory];//(Optional). If not given, then the backup file is stored under the Documents directory.
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
//            [self_weak emailBackup:addressBook_weak.backupPath];
            [NSTimer scheduledTimerWithTimeInterval:1.0 target:self_weak selector:@selector(emailBackup:) userInfo:addressBook_weak.backupPath repeats:NO];
        }
    };
    [addressBook backupContacts];
    //    [addressBook otherCode];
    
}

-(void)emailBackup:(id)timer {
    NSTimer *timer_local = (NSTimer*)timer;
    NSString *filePath = (NSString*)[timer_local userInfo];
    NSLog(@"filePath : %@",filePath);
    NSData *vcfData = [NSData dataWithContentsOfFile:filePath];
    
    if (![MFMailComposeViewController canSendMail]) {
        NSLog(@"Am not able send any mails. :( ");
        return;
    }
    MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
    controller.mailComposeDelegate = self;
    
    [controller setSubject:@"My Contacts Backup through SARAddressBookBackup library"];
    [controller setMessageBody:@"Got my vcf file here." isHTML:NO];
    [controller addAttachmentData:vcfData mimeType:@"text/x-vcard" fileName:@"MyContacts.vcf"];
//    [self presentModalViewController:controller animated:YES];
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)dismissViewControllerAnimated: (BOOL)flag completion: (void (^)(void))completion {
    NSLog(@"Dismissed");
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error{
    [controller dismissModalViewControllerAnimated:YES];
    NSLog(@"result : %d",result);
    NSLog(@"error : %@",error);
}

- (NSString *) applicationDocumentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
