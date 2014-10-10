//
//  DetailViewController.h
//  AddressBook
//
//  Created by John Blanchard on 10/3/14.
//  Copyright (c) 2014 John Blanchard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Contact.h"
#import "CoreData/CoreData.h"

@interface DetailViewController : UIViewController
@property Contact* person;
@property NSManagedObjectContext* moc;
@end
