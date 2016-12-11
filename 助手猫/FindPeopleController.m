//
//  FindPeopleController.m
//  助手猫
//
//  Created by ping on 16/6/6.
//  Copyright © 2016年 ping. All rights reserved.
//

#import "FindPeopleController.h"
#import "FindPeoplePhotoController.h"
#import "UIImageView+WebCache.h"
#import "FMDB.h"
#import "IWStudent.h"
#import "IWStudentCell.h"
@interface FindPeopleController()<UISearchBarDelegate>
@property (nonatomic, strong) FMDatabaseQueue *queue;
@end

@implementation FindPeopleController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.searchBar.delegate  = self;
    
    //    // 0.获得沙盒中的数据库文件名
    NSString *filename = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"stu.db"];
    NSError *error;
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *filenameAgo = [bundle pathForResource:@"stu" ofType:@"db"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager copyItemAtPath:filenameAgo toPath:filename error:&error];
    NSLog(@"filenameAgo>>>>%@",filenameAgo);
    NSLog(@"filename%@",filename);
    // 1.创建数据库队列
    self.queue = [FMDatabaseQueue databaseQueueWithPath:filename];
    // 2.创表
    [self.queue inDatabase:^(FMDatabase *db) {
        BOOL result = [db executeUpdate:@"create table if not exists person (id integer primary key autoincrement, name text, age integer);"];
        if (result) {
            NSLog(@"创表成功");
        } else {
            NSLog(@"创表失败");
        }
    }];
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"click%@",searchBar.text);
    self.myStudents = [NSMutableArray array];
    
    [self.queue inDatabase:^(FMDatabase *db) {
        NSString *inputText = [self.searchBar text];
        
        NSLog(@"query %@",inputText);
        NSMutableArray *students = [NSMutableArray array];
        // 1.查询数据
        FMResultSet *rs = [db executeQuery:@"select * from person where name like ? or tel like ? or classname like ? or qq like ? or stunum like ? or address like ?;",[NSString stringWithFormat:@"%%%@%%",inputText],[NSString stringWithFormat:@"%%%@%%",inputText],[NSString stringWithFormat:@"%%%@%%",inputText],[NSString stringWithFormat:@"%%%@%%",inputText],[NSString stringWithFormat:@"%%%@%%",inputText],[NSString stringWithFormat:@"%%%@%%",inputText]];
        // 2.遍历结果集王磊
        while (rs.next) {
            IWStudent *student =  [[IWStudent alloc] init];
            student.name = [rs stringForColumn:@"name"];
            student.photo = [rs stringForColumn:@"photourl"];
            student.classname = [rs stringForColumn:@"classname"];
            student.qq = [rs stringForColumn:@"qq"];
            student.tel = [rs stringForColumn:@"tel"];
            student.stunum = [rs stringForColumn:@"stunum"];
            student.address = [rs stringForColumn:@"address"];
           // NSString *name = [rs stringForColumn:@"name"];
            NSLog(@" %@ ", student.tel);
//            [self goImage:student.photo];
            [students addObject: student];
            self.myStudents = students;
        }
    }];
    //[self performSegueWithIdentifier:@"second" sender:self];
    //hide button
    [searchBar resignFirstResponder];
    
    [self.tableView reloadData];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.myStudents.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IWStudentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"student"];
    cell.student = self.myStudents[indexPath.row];
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"toPhoto"]){
        IWStudent *stu = [IWStudent alloc];
        stu = self.myStudents[self.tableView.indexPathForSelectedRow.row];
        NSString *photoUrl = stu.photo;
        NSString *url = @"http://avatar.csdn.net/";
        url = [url stringByAppendingString:[NSString stringWithFormat:@"%@",photoUrl]];
        NSURL *photoUrlPath = [NSURL URLWithString:url];
        FindPeoplePhotoController *send = segue.destinationViewController;
        send.photoUrl = photoUrlPath;
    }

}
@end
