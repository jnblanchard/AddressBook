//
//  GroupEditViewController.m
//  AddressBook
//
//  Created by John Blanchard on 10/4/14.
//  Copyright (c) 2014 John Blanchard. All rights reserved.
//

#import "EditAddressBookViewController.h"
#import "CreateContactViewController.h"
#import "AddressBookViewController.h"
#import "AddressBook.h"
#import "Contact.h"
#import "DetailViewController.h"
#import "MessageUI/MessageUI.h"

@interface EditAddressBookViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UIAlertViewDelegate, MFMailComposeViewControllerDelegate, UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property NSMutableArray* popArray;
@property NSMutableArray* popFavArray;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editDoneButton;
@property NSArray* allArray;
@property BOOL editSwitch;
@property AddressBook* bookCopy;
@property BOOL okayToEndSwitch;
@property Contact* person;
@end

@implementation EditAddressBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bookCopy = self.book;
    if (![self.book.name isEqual:nil]) {
        [self.navigationItem setTitle:self.book.name];
        self.nameTextField.text = self.book.name;
    } else {
        UIColor *color = [UIColor lightGrayColor];
        self.nameTextField.attributedPlaceholder =
        [[NSAttributedString alloc]
         initWithString:@"address book name"
         attributes:@{NSForegroundColorAttributeName:color}];
    }
    self.segmentedControl.selectedSegmentIndex = 1;
    [self.tableView reloadData];
    self.okayToEndSwitch = YES;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.layer.borderColor = [UIColor blackColor].CGColor;
    self.tableView.layer.borderWidth = 2.0f;
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.tintColor = [UIColor redColor];
    self.searchBar.layer.borderColor = [UIColor blackColor].CGColor;
    self.searchBar.layer.borderWidth = 2.0;
    for (UIView *subview in self.searchBar.subviews) {
        if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            [subview removeFromSuperview];
            break;
        }
    }
    self.searchBar.backgroundColor = [UIColor blackColor];
    self.searchBar.barTintColor = [UIColor whiteColor];
    self.searchBar.backgroundColor = [UIColor whiteColor];
    self.searchBar.barStyle = UIBarStyleDefault;

    self.editSwitch = 0;
}

-(void)viewDidAppear:(BOOL)animated
{
    [self readSwitchPopulateGroup];
}

-(void) readSwitchPopulateGroup
{
    self.popArray = [NSMutableArray new];
    self.popFavArray = [NSMutableArray new];
    NSFetchRequest* request = [[NSFetchRequest alloc] initWithEntityName:@"Contact"];
    self.popArray = [[self.moc executeFetchRequest:request error:nil] mutableCopy];
    if (self.book.contacts.count > 0) {
        for (Contact* address in [self.book.contacts allObjects]) {
            [self.popFavArray addObject:address];
        }
    }
    [self setUpArrays];
}

- (void) searchResultsAndReload
{
    [self readSwitchPopulateGroup];
    if (![self.searchBar.text isEqualToString:@""]) {
        self.popArray = [[self.popArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name BEGINSWITH[c] %@", self.searchBar.text]] mutableCopy];
        self.popFavArray = [[self.popFavArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name BEGINSWITH[c] %@", self.searchBar.text]] mutableCopy];
    }
    [self.tableView reloadData];
}


- (void) setUpArrays
{
    NSFetchRequest* request = [[NSFetchRequest alloc] initWithEntityName:@"Contact"];
    [request setSortDescriptors:@[[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES]]];
    if (![self.searchBar.text isEqualToString:@""]) {
        [request setPredicate:[NSPredicate predicateWithFormat:@"name BEGINSWITH[c] %@", self.searchBar.text]];
    }
    if (self.segmentedControl.selectedSegmentIndex == 1) {
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"isFavorite == YES"];
        [request setPredicate:predicate];
        if (![self.searchBar.text isEqualToString:@""]) {
            NSPredicate* predicateTwo = [NSPredicate predicateWithFormat:@"name BEGINSWITH[c] %@", self.searchBar.text];
            NSCompoundPredicate* compPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[predicate, predicateTwo]];
            [request setPredicate:compPredicate];
        }
    }
    self.allArray = [self.moc executeFetchRequest:request error:nil];
    [self.tableView reloadData];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self searchResultsAndReload];
//    if (self.editSwitch) {
//        [self setUpArrays];
//    } else {
//        [self searchResultsAndReload];
//    }
}

- (NSString*) createEmailBookString
{
    NSString* message = @"";
    for (Contact* contact in self.popFavArray ) {
        NSLog(@"%@", contact);
        message = [message stringByAppendingString:[NSString stringWithFormat:@"%@\n", contact.name]];
        message = [message stringByAppendingString:[NSString stringWithFormat:@"%@\n\n", contact.address]];
        message = [message stringByAppendingString:[NSString stringWithFormat:@"%@ %@ %@", contact.city, contact.state, contact.zip]];
    }
    return message;
}

- (IBAction)editButtonHit:(UIBarButtonItem *)sender
{
    UIActionSheet* sheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"Actions for %@ address book", self.navigationItem.title] delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Add Contact", @"Import Contact", @"Export Address Book", nil];
    [sheet showInView:self.view];

}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0){
        [self performSegueWithIdentifier:@"create" sender:self];
    }
    if(buttonIndex == 1) {
        NSLog(@"import contact");
    }
    if(buttonIndex == 2) {
            // Email Subject
            NSString *emailTitle = [NSString stringWithFormat:@"%@ address book", self.book.name];
            // Email Content
            NSString *messageBody = [self createEmailBookString];
            // To address
            NSArray *toRecipents = [NSArray arrayWithObject:@"jnblanchard@mac.com"];
        
            MFMailComposeViewController *mc = [MFMailComposeViewController new];
            mc.mailComposeDelegate = self;
            [mc setSubject:emailTitle];
            [mc setMessageBody:messageBody isHTML:NO];
            [mc setToRecipients:toRecipents];
        
            // Present mail view controller on screen
            [self presentViewController:mc animated:YES completion:NULL];
    }
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }

    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Contact* person;
    //    if (self.editSwitch) {
    //        person = [self.allArray objectAtIndex:indexPath.row];
    //        if ([self.popArray containsObject:person]) {
    //            [self.popArray removeObject:person];
    //            [self.book removeContactsObject:person];
    //        } else {
    //            [self.popArray addObject:person];
    //            [self.book addContactsObject:person];
    //        }
    //        [self.tableView reloadData];
    //    } else {
    if(self.segmentedControl.selectedSegmentIndex == 0) {
        person = [self.popArray objectAtIndex:indexPath.row];
        if ([self.book.contacts containsObject:person]) {
            [self.book removeContactsObject:person];
            [self.popFavArray removeObject:person];
            [self.tableView reloadData];

        } else {
            [self.book addContactsObject:person];
            [self.popFavArray addObject:person];
            [self.tableView reloadData];
        }

    } else {
        person = [self.popFavArray objectAtIndex:indexPath.row];
        [self.book removeContactsObject:person];
        [self.popFavArray removeObject:person];
        [self.tableView reloadData];
    }
    if (![self.book.contacts isEqual:self.bookCopy.contacts]) {
        self.okayToEndSwitch = NO;
    } else {
        self.okayToEndSwitch = YES;
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    Contact* person;
    //    if (self.editSwitch) {
    //        person = [self.allArray objectAtIndex:indexPath.row];
    //    } else {
    if (self.segmentedControl.selectedSegmentIndex == 1) {
        person = [self.popFavArray objectAtIndex:indexPath.row];
    } else {
        person = [self.popArray objectAtIndex:indexPath.row];
    }
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = person.name;
    if ([self.book.contacts containsObject:person]) {
        cell.detailTextLabel.text = @"X";
    } else {
        cell.detailTextLabel.text = @"";
    }
    return cell;
}

- (IBAction)nameTextFieldDoneEditing:(UITextField*)sender
{
    if ([sender.text isEqualToString:@""] && [self.bookCopy.name isEqual:nil]) {
        self.book.name = self.bookCopy.name;
    }
    self.book.name = sender.text;
    [self.moc save:nil];
}

- (IBAction)segmentedControlChange:(id)sender
{
    if (self.editSwitch) {
        [self setUpArrays];
    } else {
        [self searchResultsAndReload];
    }
    [self.tableView reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (self.editSwitch) {
//        return self.allArray.count;
//    } else {
    if (self.segmentedControl.selectedSegmentIndex == 1) {
        return self.popFavArray.count;
    } else {
        return self.popArray.count;
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 7) {
        if (buttonIndex == 1) {
            self.book.name = [alertView textFieldAtIndex:0].text;
            self.nameTextField.text = self.book.name;
            [self.moc save:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    if (alertView.tag == 2) {
        if (buttonIndex == 1) {
            self.editDoneButton.title = @"Done";
            self.editSwitch = 1;
            [self setUpArrays];
            [self checkEmptyAddressBookName];
        } else {
            self.editDoneButton.title = @"Edit";
            self.editSwitch = 0;
            self.book = self.bookCopy;
            [self.moc save:nil];
            [self checkEmptyAddressBookName];
        }
    }
    if (alertView.tag == 6) {
        if (buttonIndex == 1) {
            [self.moc deleteObject:self.book];
            [self.moc save:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

-(void) checkEmptyAddressBookName
{
    if ([self.nameTextField.text isEqual:nil] || [self.nameTextField.text isEqualToString:@""]) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Missing group title" message:@"Enter a group title" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:@"Accept", nil];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        alert.tag = 7;
        [alert show];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)rewindButtonHit:(UIBarButtonItem *)sender
{
    if (self.book.contacts.count > 0) {
        if (!self.editSwitch) {
            [self.gvc setUpAddressBookArray];
            [self checkEmptyAddressBookName];
        } else {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Unsaved Changes" message:@"May lose changes in book" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:@"Save", nil];
            alert.tag = 2;
            [alert show];
        }
    } else {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Missing members" message:@"Address book will be deleted" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:@"Delete", nil];
        alert.tag = 6;
        [alert show];
    }
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCellEditingStyle style = UITableViewCellEditingStyleDelete;
    return style;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"View";
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.segmentedControl.selectedSegmentIndex == 1) {
        self.person = [self.popFavArray objectAtIndex:indexPath.row];
    } else {
        self.person = [self.popArray objectAtIndex:indexPath.row];
    }
    [self performSegueWithIdentifier:@"detail" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.destinationViewController isKindOfClass:[DetailViewController class]]) {
        DetailViewController* dvc = segue.destinationViewController;
        dvc.person = self.person;
    }
    if([segue.destinationViewController isKindOfClass:[CreateContactViewController class]]) {
        CreateContactViewController* cvc = segue.destinationViewController;
        cvc.book = self.book;
        cvc.moc = self.moc;
    }

}

@end
