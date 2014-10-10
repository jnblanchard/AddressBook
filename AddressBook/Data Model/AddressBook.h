//
//  AddressBook.h
//  AddressBook
//
//  Created by John Blanchard on 10/4/14.
//  Copyright (c) 2014 John Blanchard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Address;

@interface AddressBook : NSManagedObject

@property (nonatomic, retain) NSNumber * isSaved;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *addresses;
@end

@interface AddressBook (CoreDataGeneratedAccessors)

- (void)addAddressesObject:(Address *)value;
- (void)removeAddressesObject:(Address *)value;
- (void)addAddresses:(NSSet *)values;
- (void)removeAddresses:(NSSet *)values;

@end
