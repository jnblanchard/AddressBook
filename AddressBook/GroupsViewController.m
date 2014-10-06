//
//  GroupsViewController.m
//  AddressBook
//
//  Created by John Blanchard on 10/4/14.
//  Copyright (c) 2014 John Blanchard. All rights reserved.
//

#import "GroupsViewController.h"
#import "AddressBook.h"
#import "GroupEditViewController.h"

@interface GroupsViewController () <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property NSArray* groups;
@end

@implementation GroupsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
}

- (void) viewDidAppear:(BOOL)animated
{
    [self setUpAddressBookArray];
}

-(void) setUpAddressBookArray
{
    NSFetchRequest* request = [[NSFetchRequest alloc] initWithEntityName:@"AddressBook"];
    [request setSortDescriptors:@[[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES]]];
    if (![self.searchBar.text isEqualToString:@""]) {
        [request setPredicate:[NSPredicate predicateWithFormat:@"name BEGINSWITH[c] %@", self.searchBar.text]];
    }
    self.groups = [self.moc executeFetchRequest:request error:nil];
    [self.tableView reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.groups.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddressBook* book = [self.groups objectAtIndex:indexPath.row];
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = book.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)book.addresses.count];
    return cell;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddressBook* book = [self.groups objectAtIndex:indexPath.row];
    [self.moc deleteObject:book];
    [self.moc save:nil];
    [self setUpAddressBookArray];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[GroupEditViewController class]]) {
        GroupEditViewController* gvc = segue.destinationViewController;
        gvc.moc = self.moc;
        if ([sender isKindOfClass:[UIBarButtonItem class]]) {
            AddressBook* book = [NSEntityDescription insertNewObjectForEntityForName:@"AddressBook" inManagedObjectContext:self.moc];
            gvc.book = book;
            gvc.gvc = self;
            NSLog(@"%@", book);
        } else {
            NSIndexPath* path = self.tableView.indexPathForSelectedRow;
            gvc.book = [self.groups objectAtIndex:path.row];
        }
    }
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self setUpAddressBookArray];
}

@end
