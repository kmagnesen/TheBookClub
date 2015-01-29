//
//  ViewController.m
//  TheBookClub
//
//  Created by Kyle Magnesen on 1/28/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import "AppDelegate.h"
#import "FriendListViewController.h"
#import "AddFriendTableViewController.h"
#import "ProfileViewController.h"
#import "Friend.h"
#import "Book.h"

@interface FriendListViewController () <UITableViewDataSource, UITabBarDelegate, UISearchBarDelegate>

@property (nonatomic) NSArray *friends;
@property (nonatomic) NSArray *filteredFriends;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSManagedObjectContext *moc;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;


@end

@implementation FriendListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _searchBar.delegate = self;

    self.moc = [AppDelegate appDelegate].managedObjectContext;
    [self alertView];
    [self loadFriends];
}

- (void)viewWillAppear:(BOOL)animated{
    [self loadFriends];
    [self.tableView reloadData];
}

- (void)loadFriends {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Friend"];
    NSSortDescriptor *friendSorter = [[NSSortDescriptor alloc]initWithKey:@"name" ascending:YES];
    request.sortDescriptors = [NSMutableArray arrayWithObject:friendSorter];
    self.friends = [self.moc executeFetchRequest:request error:nil];

    id error;
    if (error) {
        NSLog(@"%@", error);
    }
    [self.tableView reloadData];
}

#pragma mark ------------ Add An Unlisted Friend ---------------------

- (IBAction)onPlusButtonTapped:(UIBarButtonItem *)sender {
    UIAlertController *alertcontroller = [UIAlertController alertControllerWithTitle:@"Add An Unlisted Friend" message:nil preferredStyle:UIAlertControllerStyleAlert];

    [alertcontroller addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        nil;
    }];

    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"Add New Friend"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   UITextField *nameTextField = alertcontroller.textFields.firstObject;
                                   Friend *friend = [NSEntityDescription insertNewObjectForEntityForName:@"Friend" inManagedObjectContext:self.moc];
                                   friend.name = nameTextField.text;
                                   [self.moc save:nil];
                                   [self loadFriends];
                               }];

    [alertcontroller addAction:okAction];

    [self presentViewController:alertcontroller animated:YES completion:^{
        nil;
    }];
}

- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    NSString *inputText = [[alertView textFieldAtIndex:0] text];

    if([inputText length] != 0)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

#pragma mark ------------ Search Bar Functionality ---------------------

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"name contains[c] %@", searchText];
    self.filteredFriends = [self.friends filteredArrayUsingPredicate:resultPredicate];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}


#pragma mark ------------ Segue To Friend's Profile ---------------------

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"profileSegue"]) {

        ProfileViewController *profileVC = segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        Friend *friendProfile = self.friends[indexPath.row];
        profileVC.friendProfile = friendProfile;
        profileVC.title = friendProfile.name;
    }
}

#pragma mark ------------ Segue To Add Friends List ---------------------

- (void)prepareForSegue:(UIStoryboardSegue *)segue profile:(id)profile {
    if ([segue.identifier isEqualToString:@"addFriendSegue"]) {
        AddFriendTableViewController *friendsTVC = segue.destinationViewController;
        friendsTVC.title = @"Friend's List";
    }
}

- (void)alertView {
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"First Rule of Book Club:"
                          message:@"You Do Not Talk About Book Club!"
                          delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];

    [alert show];
}

#pragma mark ------------ UITableViewCell Delegate and Data Source ---------------------


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.friends.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"friendCell"];
    Friend *friend = self.friends[indexPath.row];

    cell.textLabel.text = friend.name;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
