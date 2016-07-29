//
//  HLAuthorListController.m
//  books
//
//  Created by 韩露露 on 16/7/29.
//  Copyright © 2016年 韩露露. All rights reserved.
//

#import "HLAuthorListController.h"
#import "AppDelegate.h"
#import "HLAuthor.h"
#import "HLBookListController.h"
#import "HLSortView.h"

@interface HLAuthorListController () <HLSortViewDelegate>

@property (nonatomic, weak) AppDelegate *appDelegate;
@property (nonatomic, strong) NSMutableArray *authors;
@property (nonatomic, strong) NSString *sortKey;
@property (nonatomic, assign, getter = isAscending) BOOL ascending;
@property (nonatomic, assign, getter = isShowSort) BOOL showSort;
@property (nonatomic, strong) HLSortView *sortView;

- (IBAction)toggoleDelete:(UIBarButtonItem *)sender;
- (IBAction)sort:(UIBarButtonItem *)sender;

@end

@implementation HLAuthorListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.appDelegate = [UIApplication sharedApplication].delegate;
    self.sortKey = @"date";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"HLAuthor"];
    // 设置搜索结果的排序
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:self.sortKey ascending:self.isAscending];
    request.sortDescriptors = @[sort];
    NSError *error = nil;
    self.authors = [self.appDelegate.managedObjectContext executeFetchRequest:request error:&error].mutableCopy;
    if (self.authors) {
        [self.tableView reloadData];
    } else {
        NSLog(@"未获取到作者：%@。", error.localizedDescription);
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.isShowSort) {
        [self.sortView removeFromSuperview];
        self.showSort = NO;
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.authors.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"authorCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    HLAuthor *author = self.authors[indexPath.row];
    cell.textLabel.text = author.name;
    cell.detailTextLabel.text = author.authorDesc;
    return cell;
}

- (IBAction)toggoleDelete:(UIBarButtonItem *)sender {
    if (self.isShowSort) {
        [self.sortView removeFromSuperview];
        self.showSort = NO;
    }
    if (self.authors.count) {
        [self.tableView setEditing:!self.tableView.isEditing animated:YES];
    } else {
        self.tableView.editing = NO;
    }
    sender.title = self.tableView.isEditing ? @"完成" : @"删除";
}

- (IBAction)sort:(UIBarButtonItem *)sender {
    if (self.isShowSort) {
        [self.sortView removeFromSuperview];
        self.showSort = NO;
    } else {
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

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"真的真的删删删？";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        HLAuthor *author = self.authors[indexPath.row];
        [self.appDelegate.managedObjectContext deleteObject:author];
        NSError *error = nil;
        if ([self.appDelegate.managedObjectContext save:&error]) {
            [self.authors removeObject:author];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.isShowSort) {
        [self.sortView removeFromSuperview];
        self.showSort = NO;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"bookSegue"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        HLBookListController *bookVc = segue.destinationViewController;
        bookVc.author = self.authors[indexPath.row];
    }
}

@end
