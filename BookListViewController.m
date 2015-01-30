//
//  ProfileViewController.m
//  TheBookClub
//
//  Created by Kyle Magnesen on 1/28/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import "BookListViewController.h"
#import "AppDelegate.h"
#import "FriendListViewController.h"
#import "Friend.h"
#import "Book.h"
#import "CommentsTableViewController.h"

@interface BookListViewController () <UITableViewDelegate, UITableViewDataSource>

@property NSManagedObjectContext *moc;
@property (nonatomic) NSArray *books;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *profileLabel;

@end

@implementation BookListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView setAllowsMultipleSelection:YES];
    self.moc = [AppDelegate appDelegate].managedObjectContext;
    self.profileLabel.text = [NSString stringWithFormat:@"%@'s Reading List:", self.title];
    [self loadBooks];
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

#pragma mark ----------ALERT VIEW FOR ADDING A BOOK------------


- (IBAction)onPlusButtonTapped:(UIButton *)sender {

    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Add New Book!"
                                                     message:@"Create Book Entry Below:"
                                                    delegate:self
                                           cancelButtonTitle:@"Cancel"
                                           otherButtonTitles:@"Add", nil];

    alert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    UITextField *alertTextField1 = [alert textFieldAtIndex:0];
    alertTextField1.keyboardType = UIKeyboardTypeDefault;
    alertTextField1.placeholder = @"Enter Book Title:";
    [[alert textFieldAtIndex:0] setSecureTextEntry:NO];

    UITextField *alertTextField2 = [alert textFieldAtIndex:1];
    alertTextField2.keyboardType = UIKeyboardTypeDefault;
    alertTextField2.placeholder = @"Enter Author's Name:";
    [[alert textFieldAtIndex:1] setSecureTextEntry:NO];

    [alert show];
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

//handle add button
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"Add"])
    {
        UITextField *bookDescription = [alertView textFieldAtIndex:0];
        UITextField *authorName = [alertView textFieldAtIndex:1];
        Book *book = [NSEntityDescription insertNewObjectForEntityForName:@"Book" inManagedObjectContext:self.moc];
        book.title = bookDescription.text;
        book.name = authorName.text;
        [self.moc save:nil];
        [self.tableView reloadData];
        [self loadBooks];

        NSLog(@"Desc: %@\nName: %@", bookDescription.text, authorName.text);
    } else if ([title isEqualToString:@"Cancel"]){
        [self loadBooks];
    }

}

#pragma mark ---------- Add UserComments ----------

- (IBAction)onAddCommentTapped:(UIBarButtonItem *)sender {
    
}


#pragma mark ----------UITableViewCell DataSource And Delegate------------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.books.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bookListCell"];
    Book *book = self.books[indexPath.row];
    cell.textLabel.text = book.title;
    cell.detailTextLabel.text = book.name;
    
    return cell;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    Friend *friend = self.books[indexPath.row];
//    if ([self.friend.books containsObject:friend]) {
//        [self.friend removeBooksObject:friend];
//    } else {
//        [self.friend addBooksObject:friend];
//    }
//
//
//    [self.moc save:nil];
//    [self.tableView reloadData];
//}

#pragma mark -----------------PREPARE FOR SEGUE-------------------

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

        BookListViewController *commentsTVC = segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        Friend *friendProfile = self.books[indexPath.row];
        commentsTVC.friendProfile = friendProfile;
        commentsTVC.title = @"Comments";
}

@end
