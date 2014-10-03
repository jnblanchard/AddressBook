//
//  AddressBookViewController.m
//  AddressBook
//
//  Created by John Blanchard on 10/3/14.
//  Copyright (c) 2014 John Blanchard. All rights reserved.
//

#import "AddressBookViewController.h"
#import "AddressBookTableViewCell.h"
#import "CreateAddressViewController.h"
#import "DetailViewController.h"
#import "Address.h"

@interface AddressBookViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property NSArray* addresses;
@property NSMutableArray* persons;
@end

@implementation AddressBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor yellowColor];
    self.tableView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.tableView.layer.borderWidth = 2.0f;
    [self.navigationController.navigationBar setBarTintColor:[UIColor yellowColor]];
    self.searchBar.layer.borderColor = [UIColor whiteColor].CGColor;
    self.searchBar.layer.borderWidth = 2.0;
    self.persons = [NSMutableArray new];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self setUpAddressArray];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self setUpAddressArray];
}


- (void) setUpAddressArray
{
    NSFetchRequest* request = [[NSFetchRequest alloc] initWithEntityName:@"Address"];
    [request setSortDescriptors:@[[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES]]];
    if (![self.searchBar.text isEqualToString:@""]) {
        [request setPredicate:[NSPredicate predicateWithFormat:@"name BEGINSWITH[c] %@", self.searchBar.text]];
    }
    self.addresses = [self.moc executeFetchRequest:request error:nil];
    [self.tableView reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.addresses.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Address* person = [self.addresses objectAtIndex:indexPath.row];
    AddressBookTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.backgroundColor = [UIColor blackColor];
    cell.nameLabel.text = person.name;
    cell.nameLabel.textColor = [UIColor whiteColor];
    cell.phoneLabel.text = person.phoneNumber;
    cell.phoneLabel.textColor = [UIColor whiteColor];
    cell.emailLabel.text = person.email;
    cell.emailLabel.textColor = [UIColor whiteColor];
    cell.addressLabel.text = person.address;
    cell.addressLabel.textColor = [UIColor whiteColor];
    cell.photoImageView.image = [UIImage imageNamed:@"placeholder"];
    return cell;
}



-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    Address* person = [self.addresses objectAtIndex:indexPath.row];
    [self.moc deleteObject:person];
    [self.moc save:nil];
    [self setUpAddressArray];
}

- (IBAction)editButtonPressed:(id)sender
{

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[CreateAddressViewController class]]) {
        CreateAddressViewController* cvc = segue.destinationViewController;
        cvc.moc = self.moc;
    }
    if ([segue.destinationViewController isKindOfClass:[DetailViewController class]]) {
        DetailViewController* dvc = segue.destinationViewController;
        NSIndexPath* selected = [self.tableView indexPathForSelectedRow];
        dvc.moc = self.moc;
        dvc.person = [self.addresses objectAtIndex:selected.row];
    }
}


@end
