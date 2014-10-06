//
//  Address.h
//  AddressBook
//
//  Created by John Blanchard on 10/6/14.
//  Copyright (c) 2014 John Blanchard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AddressBook;

@interface Address : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSNumber * isFavorite;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * phoneNumber;
@property (nonatomic, retain) NSData * photo;
@property (nonatomic, retain) NSSet *addressBook;
@end

@interface Address (CoreDataGeneratedAccessors)

- (void)addAddressBookObject:(AddressBook *)value;
- (void)removeAddressBookObject:(AddressBook *)value;
- (void)addAddressBook:(NSSet *)values;
- (void)removeAddressBook:(NSSet *)values;

@end
