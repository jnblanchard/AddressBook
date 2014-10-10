//
//  GroupsViewController.h
//  AddressBook
//
//  Created by John Blanchard on 10/4/14.
//  Copyright (c) 2014 John Blanchard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreData/CoreData.h"

@interface AddressBookViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSManagedObjectContext* moc;
-(void) setUpAddressBookArray;
@end
