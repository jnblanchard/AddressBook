//
//  DetailViewController.m
//  AddressBook
//
//  Created by John Blanchard on 10/3/14.
//  Copyright (c) 2014 John Blanchard. All rights reserved.
//

#import "DetailViewController.h"
#import "ContactViewController.h"

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *barButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UISwitch *favoriteSwitch;
@property (weak, nonatomic) IBOutlet UITextField *addressField;
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpView];
}

-(void) setUpView
{
    self.nameField.userInteractionEnabled = NO;
    self.phoneField.userInteractionEnabled = NO;
    self.emailField.userInteractionEnabled = NO;
    self.addressField.userInteractionEnabled = NO;
    UIColor *color = [UIColor blackColor];
    self.nameField.attributedPlaceholder =
    [[NSAttributedString alloc]
     initWithString:self.person.name
     attributes:@{NSForegroundColorAttributeName:color}];
    self.phoneField.attributedPlaceholder =
    [[NSAttributedString alloc]
     initWithString:self.person.phoneNumber
     attributes:@{NSForegroundColorAttributeName:color}];
    self.emailField.attributedPlaceholder =
    [[NSAttributedString alloc]
     initWithString:self.person.email
     attributes:@{NSForegroundColorAttributeName:color}];
    self.addressField.attributedPlaceholder =
    [[NSAttributedString alloc]
     initWithString:self.person.address
     attributes:@{NSForegroundColorAttributeName:color}];
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

- (IBAction)editButtonPressed:(UIBarButtonItem*)sender
{
    if (!self.nameField.userInteractionEnabled) {
        [self.barButton setTitle:@"Done"];
        self.nameField.userInteractionEnabled = YES;
        self.phoneField.userInteractionEnabled = YES;
        self.emailField.userInteractionEnabled = YES;
        self.addressField.userInteractionEnabled = YES;
    } else {
        [self.barButton setTitle:@"Edit"];
        self.nameField.userInteractionEnabled = NO;
        self.phoneField.userInteractionEnabled = NO;
        self.emailField.userInteractionEnabled = NO;
        self.addressField.userInteractionEnabled = NO;
        if (![self.nameField.text isEqualToString:@""]) {
            self.person.name = self.nameField.text;
        }
        if (![self.phoneField.text isEqualToString:@""]) {
            self.person.phoneNumber = self.phoneField.text;
        }
        if (![self.emailField.text isEqualToString:@""]) {
            self.person.email = self.emailField.text;
        }
        if (![self.addressField.text isEqualToString:@""]) {
            self.person.address = self.addressField.text;
        }
        [self.moc save:nil];
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[ContactViewController class]]) {
        ContactViewController* avc = segue.destinationViewController;
        avc.moc = self.moc;
        [avc setUpAddressArray];
    }
}

@end
