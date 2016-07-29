//
//  HLAddBookController.m
//  books
//
//  Created by 韩露露 on 16/7/29.
//  Copyright © 2016年 韩露露. All rights reserved.
//

#import "HLAddBookController.h"
#import "AppDelegate.h"
#import "HLBook.h"

@interface HLAddBookController ()
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *pubHouse;
@property (weak, nonatomic) AppDelegate *appDelegate;

- (IBAction)done:(id)sender;
@end

@implementation HLAddBookController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.appDelegate = [UIApplication sharedApplication].delegate;
}

- (IBAction)done:(id)sender {
    NSString *msg = nil;
    if (self.name.text && self.name.text.length > 0) {
        HLBook *book = [NSEntityDescription insertNewObjectForEntityForName:@"HLBook" inManagedObjectContext:self.appDelegate.managedObjectContext];
        book.name = self.name.text;
        book.publishHouse = self.pubHouse.text;
        book.date = [NSDate date];
        book.author = self.author;
        NSError *error = nil;
        if ([self.appDelegate.managedObjectContext save:&error]) {
            msg = @"保存作者成功";
        } else {
            msg = [NSString stringWithFormat:@"保存作者失败：%@", error.localizedDescription];
        }
    } else {
        msg = @"作者名是空，无法保存";
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:NO];
    }];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}
@end
