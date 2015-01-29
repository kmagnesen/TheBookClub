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
#import "Friend.h"
#import "Book.h"

@interface FriendListViewController () <UITableViewDataSource, UITabBarDelegate>

@property (nonatomic) NSArray *friends;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSManagedObjectContext *moc;
@property NSArray *addFriends;

@end

@implementation FriendListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.moc = [AppDelegate appDelegate].managedObjectContext;
    [self loadFriends];
}

- (void)viewWillAppear:(BOOL)animated{
    [self loadFriends];
    [self.tableView reloadData];
}

- (void)loadFriends {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Friend"];
    self.friends = [self.moc executeFetchRequest:request error:nil];

    id error;
    if (error) {
        NSLog(@"%@", error);
    }
    [self.tableView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"profileSegue"]) {
        <#statements#>
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:@"addFriendSegue"]) {
        BOOL segueShouldOccur = YES;
        if (segueShouldOccur) {
            UIAlertView *alert = [[UIAlertView alloc]
                                         initWithTitle:@"First Rule of Book Club:"
                                         message:@"You Do Not Talk About Book Club!"
                                         delegate:nil
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil];

            [alert show];

            return YES;
        }
    }
    return NO;
}

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
