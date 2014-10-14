//
//  CreateAddressViewController.m
//  AddressBook
//
//  Created by John Blanchard on 10/3/14.
//  Copyright (c) 2014 John Blanchard. All rights reserved.
//

#import "CreateContactViewController.h"
#import "ContactViewController.h"
#import "Contact.h"

@interface CreateContactViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *addressField;
@end

@implementation CreateContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)doneButtonPressed:(id)sender
{
    if ([self checkFields]) {
        [self.nameField resignFirstResponder];
        [self.phoneNumberField resignFirstResponder];
        [self.emailField resignFirstResponder];
        [self.addressField resignFirstResponder];
        [[UIBarButtonItem appearance] setTintColor:[UIColor blackColor]];
        Contact* person = [NSEntityDescription insertNewObjectForEntityForName:@"Contact" inManagedObjectContext:self.moc];
        person.name = self.nameField.text;
        person.phoneNumber = self.phoneNumberField.text;
        person.email = self.emailField.text;
        person.address = self.addressField.text;
        person.isFavorite = [NSNumber numberWithBool:NO];
        if(self.book) {
            [self.book addContactsObject:person]; 
        }
        [self.moc save:nil];
        ContactViewController* avc = self.navigationController.viewControllers.firstObject;
        avc.moc = self.moc;
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Missing information for the new contact" message:[self missingMessage] delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
        [alert show];
    }
}

-(NSString*) missingMessage
{
    NSString* message = @"";
    if ([self.nameField.text isEqualToString:@""]) {
        message = [message stringByAppendingString:@"Enter a first, last name\n"];
    }
    if ([self.addressField.text isEqualToString:@""]) {
        message = [message stringByAppendingString:@"Enter an address\n"];
    }
    if ([self.phoneNumberField.text isEqualToString:@""]) {
        message = [message stringByAppendingString:@"Enter a phone number\n"];
    }
    if ([self.emailField.text isEqualToString:@""]) {
        message = [message stringByAppendingString:@"Enter an email"];
    }
    return message;
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
