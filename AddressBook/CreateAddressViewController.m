//
//  CreateAddressViewController.m
//  AddressBook
//
//  Created by John Blanchard on 10/3/14.
//  Copyright (c) 2014 John Blanchard. All rights reserved.
//

#import "CreateAddressViewController.h"
#import "AddressBookViewController.h"
#import "Address.h"

@interface CreateAddressViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *addressField;
@end

@implementation CreateAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)doneButtonPressed:(id)sender
{
    if ([self checkFields]) {
        Address* person = [NSEntityDescription insertNewObjectForEntityForName:@"Address" inManagedObjectContext:self.moc];
        person.name = self.nameField.text;
        person.phoneNumber = self.phoneNumberField.text;
        person.email = self.emailField.text;
        person.address = self.addressField.text;
        [self.moc save:nil];
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {

    }
}

-(BOOL)checkFields
{
    if (![self.nameField.text isEqualToString:@""] && ![self.phoneNumberField.text isEqualToString:@""] && ![self.emailField.text isEqualToString:@""] && ![self.addressField.text isEqualToString:@""]) {
        return YES;
    } else {
        return NO;
    }
}


@end
