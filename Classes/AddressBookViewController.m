//
//  AddressBookViewController.m
//  AddressBook
//
//  Created by digicorp on 07/09/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import "AddressBookViewController.h"


#import <AddressBook/AddressBook.h>
#import <AddressBook/ABAddressBook.h>
#import <AddressBook/ABPerson.h>

@implementation AddressBookViewController



/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	contactList=[[NSMutableArray alloc] init];
    [self SyncContactData];
}

-(void)SyncContactData
{
    
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined){
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error)
                                                 {
                                                     if(granted)
                                                     {
                                                         [self _addContactToAddressBook];
                                                     }
                                                     else
                                                     {
                                                         UIAlertView *Notpermitted=[[UIAlertView alloc] initWithTitle:@"Message!" message:@"The contact could not be added." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                                         [Notpermitted show];
                                                     }
                                                 });
    }
    else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized){
        [self _addContactToAddressBook];
    }
    else{
        //alert(@"Message!", @"Please change privacy settings in Setting App.");
    }
}

-(void)_addContactToAddressBook
{
    CFErrorRef * error = NULL;
    
    ABAddressBookRef m_addressbook = ABAddressBookCreateWithOptions(NULL, error);
    
    if (!m_addressbook)
    {
        NSLog(@"opening address book");
    }
    
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(m_addressbook);
    CFIndex nPeople = ABAddressBookGetPersonCount(m_addressbook);
    
    for (int i=0;i < nPeople;i++)
    {
        NSMutableDictionary *dOfPerson=[NSMutableDictionary dictionary];
        
        ABRecordRef ref = CFArrayGetValueAtIndex(allPeople,i);
        
        //For username and surname
        ABMultiValueRef phones =(NSString*)ABRecordCopyValue(ref, kABPersonPhoneProperty);
        CFStringRef firstName, lastName;
        firstName = ABRecordCopyValue(ref, kABPersonFirstNameProperty);
        lastName  = ABRecordCopyValue(ref, kABPersonLastNameProperty);
        [dOfPerson setObject:[NSString stringWithFormat:@"%@ %@", firstName, lastName] forKey:@"name"];
        
        //For Email ids
        ABMutableMultiValueRef eMail  = ABRecordCopyValue(ref, kABPersonEmailProperty);
        if(ABMultiValueGetCount(eMail) > 0) {
            [dOfPerson setObject:(NSString *)ABMultiValueCopyValueAtIndex(eMail, 0) forKey:@"email"];
            
        }
        
        //For Phone number
        NSString* mobileLabel;
        for(CFIndex i = 0; i < ABMultiValueGetCount(phones); i++) {
            mobileLabel = (NSString*)ABMultiValueCopyLabelAtIndex(phones, i);
            if([mobileLabel isEqualToString:(NSString *)kABPersonPhoneMobileLabel])
            {
                [dOfPerson setObject:(NSString*)ABMultiValueCopyValueAtIndex(phones, i) forKey:@"Phone"];
            }
            else if ([mobileLabel isEqualToString:(NSString*)kABPersonPhoneIPhoneLabel])
            {
                [dOfPerson setObject:(NSString*)ABMultiValueCopyValueAtIndex(phones, i) forKey:@"Phone"];
                break ;
            }
            
            [contactList addObject:dOfPerson];
//            CFRelease(ref);
//            CFRelease(firstName);
//            CFRelease(lastName);
        }
        NSLog(@"array is %@",contactList);
    }

}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

@end
