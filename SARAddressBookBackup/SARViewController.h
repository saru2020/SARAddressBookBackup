//
//  SARViewController.h
//  SARAddressBookBackup
//
//  Created by Saravanan V on 17/05/13.
//  Copyright (c) 2013 Saravanan V. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SARAddressBookBackup.h"
#import <MessageUI/MessageUI.h>

@interface SARViewController : UIViewController <MFMailComposeViewControllerDelegate>{
    SARAddressBookBackup *addressBook;
}

@end
