//
//  GroupEditViewController.h
//  AddressBook
//
//  Created by John Blanchard on 10/4/14.
//  Copyright (c) 2014 John Blanchard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreData/CoreData.h"
#import "AddressBook.h"
#import "AddressBookViewController.h"

@interface EditAddressBookViewController : UIViewController
@property NSManagedObjectContext* moc;
@property AddressBook* book;
@property AddressBookViewController* gvc;
@end
