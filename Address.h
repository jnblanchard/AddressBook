//
//  Address.h
//  AddressBook
//
//  Created by John Blanchard on 10/4/14.
//  Copyright (c) 2014 John Blanchard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Address : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * phoneNumber;
@property (nonatomic, retain) NSData * photo;
@property (nonatomic, retain) NSNumber * isFavorite;

@end
