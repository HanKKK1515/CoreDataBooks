//
//  HLBookListController.m
//  books
//
//  Created by 韩露露 on 16/7/29.
//  Copyright © 2016年 韩露露. All rights reserved.
//

#import "HLBookListController.h"
#import "HLAuthor.h"
#import "HLBook.h"
#import "AppDelegate.h"
#import "HLAddBookController.h"
#import "HLSortView.h"

@interface HLBookListController () <HLSortViewDelegate>

@property (nonatomic, strong) NSMutableArray *booksList;
@property (nonatomic, weak) AppDelegate *appDelegate;
@property (nonatomic, strong) NSString *sortKey;
@property (nonatomic, assign, getter = isAscending) BOOL ascending;
@property (nonatomic, assign, getter = isShowSort) BOOL showSort;
@property (nonatomic, strong) HLSortView *sortView;

- (IBAction)toggoleDelete:(UIBarButtonItem *)sender;
- (IBAction)sort:(UIBarButtonItem *)sender;

@end

@implementation HLBookListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [NSString stringWithFormat:@"%@的图书。", self.author.name];
    self.appDelegate = [UIApplication sharedApplication].delegate;
    self.sortKey = @"date"; // 默认以时间排序
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"HLBook"];
    // 设置搜索结果的排序
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:self.sortKey ascending:self.isAscending];
    // 过滤出选中作者的书
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"author=%@", self.author];
    request.sortDescriptors = @[sort];
    request.predicate = predicate;
    NSError *error = nil;
    self.booksList = [self.appDelegate.managedObjectContext executeFetchRequest:request error:&error].mutableCopy;
    if (self.booksList) {
        [self.tableView reloadData];
    } else {
        NSLog(@"未获取到%@的书籍：%@。", self.author.name, error.localizedDescription);
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.isShowSort) {
        [self.sortView removeFromSuperview];
        self.showSort = NO;
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.booksList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"bookCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    HLBook *book = self.booksList[indexPath.row];
    cell.textLabel.text = book.name;
    cell.detailTextLabel.text = book.publishHouse;
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        HLBook *book = self.booksList[indexPath.row];
        [self.appDelegate.managedObjectContext deleteObject:book];
        NSError *error = nil;
        if ([self.appDelegate.managedObjectContext save:&error]) {
            [self.booksList removeObject:book];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.isShowSort) {
        [self.sortView removeFromSuperview];
        self.showSort = NO;
    }
}

#pragma mark - 
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    HLAddBookController *addBookVc = segue.destinationViewController;
    addBookVc.author = self.author;
}

- (IBAction)toggoleDelete:(UIBarButtonItem *)sender {
    if (self.isShowSort) {
        [self.sortView removeFromSuperview];
        self.showSort = NO;
    }
    if (self.booksList.count) {
        [self.tableView setEditing:!self.tableView.isEditing animated:YES];
    } else {
        self.tableView.editing = NO;
    }
    sender.title = self.tableView.isEditing ? @"完成" : @"删除";
}

- (IBAction)sort:(UIBarButtonItem *)sender {
    if (self.isShowSort) {
        // 从主window中移除排序选项的View。
        [self.sortView removeFromSuperview];
        self.showSort = NO;
    } else {
        // 排序选项的View添加到主window中，添加约束。
        UIView *window = [UIApplication sharedApplication].keyWindow;
        self.sortView = [HLSortView sortView];
        [window insertSubview:self.sortView atIndex:1];
        self.sortView.delegate = self;
        self.sortView.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint *consTop = [NSLayoutConstraint constraintWithItem:self.sortView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:window attribute:NSLayoutAttributeTop multiplier:1 constant:60];
        NSLayoutConstraint *consRight = [NSLayoutConstraint constraintWithItem:self.sortView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:window attribute:NSLayoutAttributeRight multiplier:1 constant:-35];
        [window addConstraints:@[consTop, consRight]];
        self.showSort = YES;
    }
}

#pragma mark - HLSortView的代理方法
- (void)sortView:(HLSortView *)sortView sortType:(HLSortType)sortType {
    switch(sortType) {
        case kHLSortTypeNameAscending:
            self.sortKey = @"name";
            self.ascending = YES;
            break;
        case kHLSortTypeNameDescending:
            self.sortKey = @"name";
            self.ascending = NO;
            break;
        case kHLSortTypeDateAscending:
            self.sortKey = @"date";
            self.ascending = YES;
            break;
        case kHLSortTypeDateDescending:
            self.sortKey = @"date";
            self.ascending = NO;
            break;
    }
    [self viewWillAppear:YES];
}

@end
