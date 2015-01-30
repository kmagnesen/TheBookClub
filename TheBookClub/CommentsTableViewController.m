//
//  CommentsTableViewController.m
//  TheBookClub
//
//  Created by Kyle Magnesen on 1/29/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import "CommentsTableViewController.h"
#import "BookListViewController.h"
#import "AppDelegate.h"
#import "FriendListViewController.h"
#import "Friend.h"
#import "Book.h"


@interface CommentsTableViewController ()

@property (nonatomic) NSArray *commentsArray;
@property NSManagedObjectContext *moc;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *addButton;

@end

@implementation CommentsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView setAllowsMultipleSelection:YES];
    self.moc = [AppDelegate appDelegate].managedObjectContext;
}

- (void)setCommentsArray:(NSArray *)commentsArray{
    _commentsArray = commentsArray;
    [self.tableView reloadData];
}

- (void)loadComments {

    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Book"];
    NSSortDescriptor *commentSorter = [[NSSortDescriptor alloc]initWithKey:@"comments" ascending:YES];
    request.sortDescriptors = [NSMutableArray arrayWithObject:commentSorter];
    self.commentsArray = [self.moc executeFetchRequest:request error:nil];

    id error;
    if (error) {
        NSLog(@"%@", error);
    }
    [self.tableView reloadData];
}

#pragma mark ------------ ON ADD BUTTON TAPPED -------------

- (IBAction)onAddButtonTapped:(UIBarButtonItem *)sender {

}


#pragma mark ------------ UITableViewController DataSource And Delegate -------------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.commentsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commentCell" forIndexPath:indexPath];
    cell.textLabel.text = self.commentsArray[indexPath.row];

    return cell;
}

@end
