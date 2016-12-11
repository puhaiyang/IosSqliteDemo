//
//  FindPeopleController.h
//  助手猫
//
//  Created by ping on 16/6/6.
//  Copyright © 2016年 ping. All rights reserved.
//

#import <UIKit/UIKit.h>
@class IWStudent;
@interface FindPeopleController : UITableViewController
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property NSMutableArray *myStudents;
@end
