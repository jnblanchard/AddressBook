//
//  DetailViewController.m
//  AddressBook
//
//  Created by John Blanchard on 10/3/14.
//  Copyright (c) 2014 John Blanchard. All rights reserved.
//

#import "DetailViewController.h"
#import "ContactViewController.h"

@interface DetailViewController () <UIPickerViewDataSource, UIPickerViewDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *barButton;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *addressField;
@property (weak, nonatomic) IBOutlet UIButton *stateButton;
@property (weak, nonatomic) IBOutlet UITextField *zipField;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UISwitch *favoriteSwitch;
@property UIView* maskView;
@property UIPickerView* _providerPickerView;
@property UIToolbar *_providerToolbar;
@property (weak, nonatomic) IBOutlet UIButton *printButton;
@property (weak, nonatomic) IBOutlet UITextField *cityField;
@property NSArray* states;
@property Contact* contactCopy;
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpView];
    self.contactCopy = self.person;
    self.states = @[@"AL",@"AK",@"AZ",@"AR",@"CA",@"CO",@"CT",@"DE",@"FL",@"GA",@"HI",@"ID",@"IL",@"IN",@"IA",@"KS",@"KY",@"LA",@"ME",@"MD",@"MA",@"MI",@"MN",@"MS",@"MO",@"MT",@"NE",@"NV",@"NH",@"NJ",@"NM",@"NY",@"NC",@"ND",@"OH",@"OK",@"OR",@"PA",@"RI",@"SC",@"SD",@"TN",@"TX",@"UT",@"VT",@"VA",@"WA",@"WV",@"WI",@"WY"];
}

-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound)
    {
        
    }
    [super viewWillDisappear:animated];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        self.person = self.contactCopy;
        [self.moc save:nil];
    }
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

-(void) setUpView
{
    self.nameField.userInteractionEnabled = NO;
    self.phoneNumber.userInteractionEnabled = NO;
    self.zipField.userInteractionEnabled = NO;
    self.addressField.userInteractionEnabled = NO;
    self.lastNameField.userInteractionEnabled = NO;
    self.stateButton.userInteractionEnabled = NO;
    self.cityField.userInteractionEnabled = NO;
    self.printButton.clipsToBounds = YES;
    self.printButton.layer.cornerRadius = 20;
    UIColor *color = [UIColor lightGrayColor];
    self.nameField.attributedPlaceholder =
    [[NSAttributedString alloc]
     initWithString:self.person.firstName
     attributes:@{NSForegroundColorAttributeName:color}];
    self.lastNameField.attributedPlaceholder =
    [[NSAttributedString alloc]
     initWithString:self.person.lastName
     attributes:@{NSForegroundColorAttributeName:color}];
    self.phoneNumber.attributedPlaceholder =
    [[NSAttributedString alloc]
     initWithString:self.person.phoneNumber
     attributes:@{NSForegroundColorAttributeName:color}];
    self.zipField.attributedPlaceholder =
    [[NSAttributedString alloc]
     initWithString:self.person.zip
     attributes:@{NSForegroundColorAttributeName:color}];
    self.addressField.attributedPlaceholder =
    [[NSAttributedString alloc]
     initWithString:self.person.address
     attributes:@{NSForegroundColorAttributeName:color}];
    self.cityField.attributedPlaceholder =
    [[NSAttributedString alloc]
     initWithString:self.person.city
     attributes:@{NSForegroundColorAttributeName:color}];
    [self.stateButton setTitle:self.person.state forState:UIControlStateNormal];
    self.navigationController.navigationBar.tintColor = [UIColor redColor];
    if (![self.person isEqual:nil]) {
        [self.navigationItem setTitle:self.person.name];
    }
    if (!self.person.isFavorite) {
        self.person.isFavorite = [NSNumber numberWithBool:NO];
        [self.moc save:nil];
    }
    if ([self.person.isFavorite  isEqual: @1]) {
        self.favoriteButton.backgroundColor = [UIColor whiteColor];
        [self.favoriteButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.favoriteButton setTitle:@"Unfavorite" forState:UIControlStateNormal];
        self.favoriteSwitch.on = YES;
    } else {
        self.favoriteButton.backgroundColor = [UIColor blackColor];
        [self.favoriteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.favoriteButton setTitle:@"Favorite" forState:UIControlStateNormal];
        self.favoriteSwitch.on = NO;
    }
}

- (IBAction)stateButtonPressed:(id)sender
{
    [self createPickerView];
}

- (IBAction)editButtonPressed:(UIBarButtonItem*)sender
{
    if (!self.nameField.userInteractionEnabled) {
        [self.barButton setTitle:@"Done"];
        self.nameField.userInteractionEnabled = YES;
        self.phoneNumber.userInteractionEnabled = YES;
        self.zipField.userInteractionEnabled = YES;
        self.stateButton.userInteractionEnabled = YES;
        self.lastNameField.userInteractionEnabled = YES;
        self.cityField.userInteractionEnabled = YES;
        self.addressField.userInteractionEnabled = YES;
    } else {
        [self.barButton setTitle:@"Edit"];
        self.nameField.userInteractionEnabled = NO;
        self.phoneNumber.userInteractionEnabled = NO;
        self.zipField.userInteractionEnabled = NO;
        self.addressField.userInteractionEnabled = NO;
        self.lastNameField.userInteractionEnabled = NO;
        self.stateButton.userInteractionEnabled = NO;
        self.cityField.userInteractionEnabled = NO;
        if (![self.nameField.text isEqualToString:@""]) {
            if ([self isFirstNameValid]) {
                self.person.firstName = self.nameField.text;
                self.person.name = [NSString stringWithFormat:@"%@ %@",self.person.firstName, self.person.lastName];
            } else {
                self.nameField.text = @"";
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"First name invalid" message:@"First name must be alphabetical" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
                [alert show];
            }

        }
        if (![self.lastNameField.text isEqualToString:@""]) {
            if ([self isLastNameValid]) {
                self.person.lastName = self.lastNameField.text;
                self.person.name = [NSString stringWithFormat:@"%@ %@",self.person.firstName, self.person.lastName];
            } else {
                self.lastNameField.text = @"";
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Last name invalid" message:@"Last name must be alphabetical" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
                [alert show];
            }
        }
        if (![self.phoneNumber.text isEqualToString:@""]) {
            if ([self isThePhoneNumberValid]) {
                self.person.phoneNumber = self.phoneNumber.text;
            } else {
                self.phoneNumber.text = @"";
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Phone number invalid" message:@"phone numbers are 10 digits: ex ( 7079543232 )" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
                [alert show];
            }
        }
        if (![self.zipField.text isEqualToString:@""]) {
            if ([self isTheZIPvalid]) {
                self.person.zip = self.zipField.text;
            } else {
                self.zipField.text = @"";
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"ZIP invalid" message:@"Zip must have 5 or 9 digits" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
                [alert show];
            }
        }
        if (![self.addressField.text isEqualToString:@""]) {
            self.person.address = self.addressField.text;
        }
        if (![self.stateButton.titleLabel.text isEqualToString:@"State"]) {
            self.person.state = self.stateButton.titleLabel.text;
        }
        if (![self.cityField.text isEqualToString:@""]) {
            if ([self iscityValid]) {
                self.person.city = self.cityField.text;
            } else {
                self.cityField.text = @"";
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"City invalid" message:@"Citys must be alphabetical" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
                [alert show];
            }
        }
        [self.moc save:nil];
    }
}

- (BOOL) isThePhoneNumberValid
{
    NSNumberFormatter* formatter = [NSNumberFormatter new];
    NSNumber* number = [formatter numberFromString:self.phoneNumber.text];
    if (![self.phoneNumber.text isEqualToString:@""]&& number != nil && self.phoneNumber.text.length == 10) {
        return YES;
    } else {
        self.zipField.text = @"";
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
        self.cityField.text = self.person.city;
        return NO;
    }
}

- (BOOL) isTheZIPvalid
{
    NSNumberFormatter* formatter = [NSNumberFormatter new];
    NSNumber* number = [formatter numberFromString:self.zipField.text];
    if (![self.zipField.text isEqualToString:@""] && (self.zipField.text.length == 5 || self.zipField.text.length == 9) && number != nil) {
        return YES;
    } else {
        self.zipField.text = @"";
        return NO;
    }
}

- (BOOL) isFirstNameValid
{
    NSNumberFormatter* formatter = [NSNumberFormatter new];
    NSNumber* number = [formatter numberFromString:self.nameField.text];
    if ( number == nil) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL) isLastNameValid
{
    NSNumberFormatter* formatter = [NSNumberFormatter new];
    NSNumber* number = [formatter numberFromString:self.lastNameField.text];
    if ( number == nil) {
        return YES;
    } else {
        return NO;
    }
}

- (IBAction)favoriteButtonPressed:(id)sender
{
    if ([self.person.isFavorite isEqual:@1]) {
        self.favoriteButton.backgroundColor = [UIColor blackColor];
        [self.favoriteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.favoriteButton setTitle:@"Favorite" forState:UIControlStateNormal];
        self.person.isFavorite = @0;
        self.favoriteSwitch.on = NO;

    } else {
        self.favoriteButton.backgroundColor = [UIColor whiteColor];
        [self.favoriteButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.favoriteButton setTitle:@"Unfavorite" forState:UIControlStateNormal];
        self.person.isFavorite = [NSNumber numberWithBool:YES];
        self.favoriteSwitch.on = YES;
    }
    [self.moc save:nil];
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[ContactViewController class]]) {
        ContactViewController* avc = segue.destinationViewController;
        avc.moc = self.moc;
        [avc setUpAddressArray];
    }
}

- (IBAction)printPersonInMailingLabelFormat:(id)sender
{
    NSString* message = @"";
    message = [message stringByAppendingString:[NSString stringWithFormat:@"%@\n", self.person.name]];
    message = [message stringByAppendingString:[NSString stringWithFormat:@"%@\n", self.person.address]];
    message = [message stringByAppendingString:[NSString stringWithFormat:@"%@ %@ %@\n\n", self.person.city, self.person.state, self.person.zip]];
    NSLog(@"%@", message);
}

@end
