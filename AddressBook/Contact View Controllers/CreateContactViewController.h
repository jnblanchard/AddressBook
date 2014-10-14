//
//  CreateAddressViewController.h
//  AddressBook
//
//  Created by John Blanchard on 10/3/14.
//  Copyright (c) 2014 John Blanchard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressBook.h"
#import "CoreData/CoreData.h"

@interface CreateContactViewController : UIViewController
@property NSManagedObjectContext* moc;
@property AddressBook* book;
@end
