//
//  AddressBookAppDelegate.m
//  AddressBook
//
//  Created by digicorp on 07/09/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import "AddressBookAppDelegate.h"
#import "AddressBookViewController.h"

@implementation AddressBookAppDelegate

@synthesize window;
@synthesize viewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
