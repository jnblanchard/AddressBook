//
//  AddressBookViewController.h
//  AddressBook
//
//  Created by John Blanchard on 10/3/14.
//  Copyright (c) 2014 John Blanchard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreData/CoreData.h"

@interface AddressBookViewController : UIViewController
@property NSManagedObjectContext* moc;
- (void) setUpAddressArray;
@end
