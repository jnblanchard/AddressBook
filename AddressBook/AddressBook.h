//
//  AddressBook.h
//  AddressBook
//
//  Created by John Blanchard on 10/13/14.
//  Copyright (c) 2014 John Blanchard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Contact;

@interface AddressBook : NSManagedObject

@property (nonatomic, retain) NSNumber * isSaved;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *contacts;
@end

@interface AddressBook (CoreDataGeneratedAccessors)

- (void)addContactsObject:(Contact *)value;
- (void)removeContactsObject:(Contact *)value;
- (void)addContacts:(NSSet *)values;
- (void)removeContacts:(NSSet *)values;

@end
