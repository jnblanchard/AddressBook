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

@interface CreateContactViewController () <UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberField;
@property (weak, nonatomic) IBOutlet UITextField *zipField;
@property (weak, nonatomic) IBOutlet UITextField *cityField;
@property (weak, nonatomic) IBOutlet UIButton *stateButton;
@property (weak, nonatomic) IBOutlet UITextField *addressField;
@property UIView* maskView;
@property UIPickerView* _providerPickerView;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property UIToolbar *_providerToolbar;
@property NSArray* states;
@property NSData* photo;
@property Contact* contact;
@end

@implementation CreateContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.states = @[@"AL",@"AK",@"AZ",@"AR",@"CA",@"CO",@"CT",@"DE",@"FL",@"GA",@"HI",@"ID",@"IL",@"IN",@"IA",@"KS",@"KY",@"LA",@"ME",@"MD",@"MA",@"MI",@"MN",@"MS",@"MO",@"MT",@"NE",@"NV",@"NH",@"NJ",@"NM",@"NY",@"NC",@"ND",@"OH",@"OK",@"OR",@"PA",@"RI",@"SC",@"SD",@"TN",@"TX",@"UT",@"VT",@"VA",@"WA",@"WV",@"WI",@"WY"];
    self.doneButton.clipsToBounds = YES;
    self.doneButton.layer.cornerRadius = 20;
    self.stateButton.clipsToBounds = YES;
    self.stateButton.layer.cornerRadius = 10;
}

- (IBAction)editingEnded:(UITextField*)sender {
    [sender resignFirstResponder];
}

- (IBAction)cameraButtonPressed:(UIBarButtonItem *)sender
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    self.photo = UIImagePNGRepresentation([info objectForKey:UIImagePickerControllerOriginalImage]);
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self.stateButton setTitle:[self.states objectAtIndex:row] forState:UIControlStateNormal];
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 50;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.states objectAtIndex:row];
}

- (IBAction)stateButtonPressed:(UIButton*)sender
{
    [self.nameField resignFirstResponder];
    [self.phoneNumberField resignFirstResponder];
    [self.addressField resignFirstResponder];
    [self.lastNameField resignFirstResponder];
    [self.zipField resignFirstResponder];
    [self.cityField resignFirstResponder];
    [self createPickerView];

}

- (IBAction)doneButtonPressed:(id)sender
{
    if ([self checkFields]) {
        [self.nameField resignFirstResponder];
        [self.phoneNumberField resignFirstResponder];
        [self.addressField resignFirstResponder];
        [self.lastNameField resignFirstResponder];
        [self.zipField resignFirstResponder];
        [self.cityField resignFirstResponder];
        [[UIBarButtonItem appearance] setTintColor:[UIColor redColor]];
        self.navigationController.navigationBar.tintColor = [UIColor redColor];
        Contact* person = [NSEntityDescription insertNewObjectForEntityForName:@"Contact" inManagedObjectContext:self.moc];
        person.name = [self.nameField.text stringByAppendingString:[NSString stringWithFormat:@" %@",self.lastNameField.text]];
        person.firstName = self.nameField.text;
        person.lastName = self.lastNameField.text;
        person.zip = self.zipField.text;
        person.state = self.stateButton.titleLabel.text;
        person.phoneNumber = self.phoneNumberField.text;
        person.address = self.addressField.text;
        person.city = self.cityField.text;
        person.isFavorite = [NSNumber numberWithBool:NO];
        if (![self.photo isEqual:nil]) {
            person.photo = self.photo;
        }
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
        message = [message stringByAppendingString:@"Enter a first name\n"];
    }

    if ([self.addressField.text isEqualToString:@""]) {
        message = [message stringByAppendingString:@"Enter an address\n"];
    }
    
    if ([self.phoneNumberField.text isEqualToString:@""]) {
        message = [message stringByAppendingString:@"Enter a phone number\n"];
    }
    if (![self isThePhoneNumberValid]) {
        message = [message stringByAppendingString:@"phone number must contain 10 digits. ex: 7079356401\n"];
    }

    if ([self.zipField.text isEqualToString:@""]) {
        message = [message stringByAppendingString:@"Enter a zip code\n"];
    }
    if (![self isTheZIPvalid]) {
        message = [message stringByAppendingString:@"The zip is invalid, enter a valid zip code\n"];
    }

    if ([self.lastNameField.text isEqualToString:@""]) {
        message = [message stringByAppendingString:@"Enter a last name\n"];
    }
    
    if ([self.stateButton.titleLabel.text isEqualToString:@""]) {
        message = [message stringByAppendingString:@"Click State button and select state\n"];
    }


    if ([self.cityField.text isEqualToString:@""]) {
        message = [message stringByAppendingString:@"Enter a city"];
    }
    if (![self iscityValid]) {
        message = [message stringByAppendingString:@"City contains a number\n"];
    }

    return message;
}

- (BOOL) isThePhoneNumberValid
{
    NSNumberFormatter* formatter = [NSNumberFormatter new];
    NSNumber* number = [formatter numberFromString:self.phoneNumberField.text];
//    NSLog(@"Number - %@", number);
    if (![self.phoneNumberField.text isEqualToString:@""]&& number != nil && self.phoneNumberField.text.length == 10) {
        return YES;
    } else {
        self.zipField.text = @"";
        return NO;
    }
}

- (BOOL) isTheZIPvalid
{
    NSNumberFormatter* formatter = [NSNumberFormatter new];
    NSNumber* number = [formatter numberFromString:self.zipField.text];
//    NSLog(@"Number - %@", number);
    if (![self.zipField.text isEqualToString:@""] && (self.zipField.text.length == 5 || self.zipField.text.length == 9) && number != nil) {
        return YES;
    } else {
        self.zipField.text = @"";
        return NO;
    }
}

- (BOOL) isLastNameValid
{
    NSNumberFormatter* formatter = [NSNumberFormatter new];
    NSNumber* number = [formatter numberFromString:self.lastNameField.text];
    if (![self.lastNameField.text isEqualToString:@""] && number == nil) {
        return YES;
    } else {
        self.lastNameField.text = self.contact.lastName;
        return NO;
    }
}

- (BOOL) iscityValid
{
    NSNumberFormatter* formatter = [NSNumberFormatter new];
    NSNumber* number = [formatter numberFromString:self.cityField.text];
    if (![self.cityField.text isEqualToString:@""] && number == nil) {
        return YES;
    } else {
        self.cityField.text = self.contact.city;
        return NO;
    }
}

-(BOOL)checkFields
{
    NSLog(@"%lu", (unsigned long)self.zipField.text.length);
    if (![self.nameField.text isEqualToString:@""] && ![self.phoneNumberField.text isEqualToString:@""] && ![self.zipField.text isEqualToString:@""] && ![self.addressField.text isEqualToString:@""] && ![self.stateButton.titleLabel.text isEqualToString:@"State"] && ![self.lastNameField.text isEqualToString:@""] && ![self.cityField.text isEqualToString:@""] && [self isTheZIPvalid] && [self isThePhoneNumberValid]) {
        return YES;
    } else {
        return NO;
    }
}

-(BOOL)zipLength
{
    if (self.zipField.text.length == 5 || self.zipField.text.length == 9) {
        return YES;
    } else {
        self.zipField.text = @"";
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Invalid ZIP" message:@"ZIP has been reset, enter valid ZIP" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
        [alert show];
        return NO;
    }
}

- (void) createPickerView {
    self.maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.maskView setBackgroundColor:[UIColor clearColor]];

    [self.view addSubview:self.maskView];
    self._providerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 344, self.view.bounds.size.width, 44)];

    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissActionSheet:)];
    self._providerToolbar.items = @[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil], done];
    [self._providerToolbar setTintColor:[UIColor whiteColor]];
    self._providerToolbar.barStyle = UIBarStyleBlack;
    [self.view addSubview:self._providerToolbar];

    self._providerPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 300, 0, 0)];
    self._providerPickerView.backgroundColor = [UIColor whiteColor];
    self._providerPickerView.showsSelectionIndicator = YES;
    self._providerPickerView.dataSource = self;
    self._providerPickerView.delegate = self;

    [self.view addSubview:self._providerPickerView];

}

- (void)dismissActionSheet:(id)sender{
    [self.maskView removeFromSuperview];
    [self._providerPickerView removeFromSuperview];
    [self._providerToolbar removeFromSuperview];
}


@end
