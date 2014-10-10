//
//  AddressBook.h
//  AddressBook
//
//  Created by John Blanchard on 10/4/14.
//  Copyright (c) 2014 John Blanchard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Contact;

@interface AddressBook : NSManagedObject

@property (nonatomic, retain) NSNumber * isSaved;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *addresses;
@end

@interface AddressBook (CoreDataGeneratedAccessors)

- (void)addAddressesObject:(Contact *)value;
- (void)removeAddressesObject:(Contact *)value;
- (void)addAddresses:(NSSet *)values;
- (void)removeAddresses:(NSSet *)values;

@end
