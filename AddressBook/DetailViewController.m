//
//  DetailViewController.m
//  AddressBook
//
//  Created by John Blanchard on 10/3/14.
//  Copyright (c) 2014 John Blanchard. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *barButton;
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
    UIColor *color = [UIColor redColor];
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

@end
