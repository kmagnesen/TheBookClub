//
//  ProfileViewController.m
//  TheBookClub
//
//  Created by Kyle Magnesen on 1/28/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import "ProfileViewController.h"
#import "AppDelegate.h"
#import "FriendListViewController.h"
#import "Friend.h"
#import "Book.h"

@interface ProfileViewController () <UITableViewDelegate, UITableViewDataSource>

@property NSManagedObjectContext *moc;
@property (nonatomic) NSArray *books;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *profileLabel;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView setAllowsMultipleSelection:YES];
    self.moc = [AppDelegate appDelegate].managedObjectContext;
}

- (void) setBooks:(NSArray *)books{
    _books = books;
    [self.tableView reloadData];
}

- (void)loadBooks{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Book"];
    self.books = [self.moc executeFetchRequest:request error:nil];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.books.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    return cell;
}

@end
