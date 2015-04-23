//
//  AddressBookAppDelegate.h
//  AddressBook
//
//  Created by digicorp on 07/09/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AddressBookViewController;

@interface AddressBookAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    AddressBookViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet AddressBookViewController *viewController;

@end

