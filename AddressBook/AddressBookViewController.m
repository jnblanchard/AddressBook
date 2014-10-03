//
//  AddressBookViewController.m
//  AddressBook
//
//  Created by John Blanchard on 10/3/14.
//  Copyright (c) 2014 John Blanchard. All rights reserved.
//

#import "AddressBookViewController.h"
#import "CreateAddressViewController.h"
#import "DetailViewController.h"
#import "Address.h"

@interface AddressBookViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSArray* addresses;
@end

@implementation AddressBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self setUpAddressArray];
}

- (void) setUpAddressArray
{
    NSFetchRequest* request = [[NSFetchRequest alloc] initWithEntityName:@"Address"];
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
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = person.name;
    cell.detailTextLabel.text = person.phoneNumber;
    return cell;
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
        dvc.person = [self.addresses objectAtIndex:selected.row];
    }
}


@end
