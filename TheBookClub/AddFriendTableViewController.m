//
//  AddFriendTableViewController.m
//  TheBookClub
//
//  Created by Kyle Magnesen on 1/28/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import "AddFriendTableViewController.h"
#import "AppDelegate.h"
#import "FriendListViewController.h"
#import "Friend.h"

@interface AddFriendTableViewController ()

@property (nonatomic) NSArray *friendsArray;
@property NSManagedObjectContext *moc;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation AddFriendTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView setAllowsMultipleSelection:YES];
    self.moc = [AppDelegate appDelegate].managedObjectContext;

    [self loadFriends];
}

- (void) setFriendsArray:(NSArray *)friendsArray {
    _friendsArray = friendsArray;
    [self.tableView reloadData];
}

- (void) loadFriends {
    NSURL *url = [NSURL URLWithString:@"http://s3.amazonaws.com/mobile-makers-assets/app/public/ckeditor_assets/attachments/18/friends.json"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {

        self.friendsArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&connectionError];
//        NSLog(@"%@", self.friendsArray);
        [self.tableView reloadData];
    }];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.friendsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"addFriendCell" forIndexPath:indexPath];
    cell.textLabel.text = self.friendsArray[indexPath.row];

    if (cell.selected == YES) {
        [cell setSelected:YES animated:YES];
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    } else {
        [cell setSelected:NO animated:NO];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    if (cell.selected == YES) {
        [cell setSelected:YES animated:YES];
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        Friend *friends = [NSEntityDescription insertNewObjectForEntityForName:@"Friend" inManagedObjectContext:self.moc];
        friends.name = [self.friendsArray objectAtIndex:indexPath.row];
        [self.moc save:nil];
    } else {
        [cell setSelected:NO animated:NO];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
}

@end
