//
//  Book.h
//  TheBookClub
//
//  Created by Kyle Magnesen on 1/28/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Book : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *friends;
@end

@interface Book (CoreDataGeneratedAccessors)

- (void)addFriendsObject:(NSManagedObject *)value;
- (void)removeFriendsObject:(NSManagedObject *)value;
- (void)addFriends:(NSSet *)values;
- (void)removeFriends:(NSSet *)values;

@end
