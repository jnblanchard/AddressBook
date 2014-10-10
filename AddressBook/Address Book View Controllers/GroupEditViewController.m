//
//  GroupEditViewController.m
//  AddressBook
//
//  Created by John Blanchard on 10/4/14.
//  Copyright (c) 2014 John Blanchard. All rights reserved.
//

#import "GroupEditViewController.h"
#import "GroupsViewController.h"
#import "AddressBook.h"
#import "Address.h"
#import "DetailViewController.h"

@interface GroupEditViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UIAlertViewDelegate>
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
@property Address* person;
@end

@implementation GroupEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bookCopy = self.book;
    if (![self.book.name isEqual:nil]) {
        [self.navigationItem setTitle:self.book.name];
        self.nameTextField.text = self.book.name;
    }
    self.okayToEndSwitch = YES;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.layer.borderColor = [UIColor blackColor].CGColor;
    self.tableView.layer.borderWidth = 2.0f;
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
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
    for (Address* address in [self.book.addresses allObjects]) {
        [self.popArray addObject:address];
        if ([address.isFavorite  isEqual: @1]) {
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
    NSFetchRequest* request = [[NSFetchRequest alloc] initWithEntityName:@"Address"];
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
    if (self.editSwitch) {
        [self setUpArrays];
    } else {
        [self searchResultsAndReload];
    }
}

- (IBAction)editButtonHit:(UIBarButtonItem *)sender
{
    if([sender.title isEqualToString:@"Edit"]) {
        sender.title = @"Done";
        self.editSwitch = 1;
        [self setUpArrays];
    } else {
        sender.title = @"Edit";
        self.editSwitch = 0;
        [self.tableView reloadData];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Address* person;
    if (self.editSwitch) {
        person = [self.allArray objectAtIndex:indexPath.row];
        if ([self.popArray containsObject:person]) {
            [self.popArray removeObject:person];
            [self.book removeAddressesObject:person];
            NSLog(@"Editing popArray contains person");
        } else {
            [self.popArray addObject:person];
            [self.book addAddressesObject:person];
            NSLog(@"Editing popArray NO person");
        }
        [self.tableView reloadData];
    } else {
        person = [self.popArray objectAtIndex:indexPath.row];
        [self.popArray removeObject:person];
        [self.book removeAddressesObject:person];
        [self.tableView reloadData];
    }
    if (![self.book.addresses isEqual:self.bookCopy.addresses]) {
        self.okayToEndSwitch = NO;
    } else {
        self.okayToEndSwitch = YES;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    Address* person;
    if (self.editSwitch) {
        person = [self.allArray objectAtIndex:indexPath.row];
    } else {
        if (self.segmentedControl.selectedSegmentIndex == 1) {
            person = [self.popFavArray objectAtIndex:indexPath.row];
        } else {
            person = [self.popArray objectAtIndex:indexPath.row];
        }
    }
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = person.name;
    if ([self.popArray containsObject:person]) {
        cell.detailTextLabel.text = @"X";
    } else {
        cell.detailTextLabel.text = @"";
    }
    return cell;
}

- (IBAction)nameTextFieldDoneEditing:(UITextField*)sender
{
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
    if (self.editSwitch) {
        return self.allArray.count;
    } else {
        if (self.segmentedControl.selectedSegmentIndex == 1) {
            return self.popFavArray.count;
        } else {
            return self.popArray.count;
        }
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 7) {
        if (buttonIndex == 1) {
            self.book.name = [alertView textFieldAtIndex:0].text;
            self.nameTextField.text = self.book.name;
            [self.moc save:nil];
            NSLog(@"here");
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    if (alertView.tag == 2) {
        if (buttonIndex == 1) {
            self.editDoneButton.title = @"Done";
            self.editSwitch = 1;
            [self setUpArrays];
            NSLog(@"here");
            [self checkEmptyAddressBookName];
        } else {
            NSLog(@"here part2");
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
    if (self.book.addresses.count > 0) {
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
    if (self.editSwitch) {
        self.person = [self.allArray objectAtIndex:indexPath.row];
    } else {
        if (self.segmentedControl.selectedSegmentIndex == 1) {
            self.person = [self.popFavArray objectAtIndex:indexPath.row];
        } else {
            self.person = [self.popArray objectAtIndex:indexPath.row];
        }
    }
    [self performSegueWithIdentifier:@"detail" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    DetailViewController* dvc = segue.destinationViewController;
    dvc.person = self.person;
}

@end
