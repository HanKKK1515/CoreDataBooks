//
//  HLAddAuthorController.m
//  books
//
//  Created by 韩露露 on 16/7/29.
//  Copyright © 2016年 韩露露. All rights reserved.
//

#import "HLAddAuthorController.h"
#import "AppDelegate.h"
#import "HLAuthor.h"


@interface HLAddAuthorController ()

@property (weak, nonatomic) AppDelegate *appDelegate;
@property (weak, nonatomic) IBOutlet UITextField *author;
@property (weak, nonatomic) IBOutlet UITextField *authorDesc;

- (IBAction)done:(id)sender;

@end

@implementation HLAddAuthorController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.appDelegate = [UIApplication sharedApplication].delegate;
}

- (IBAction)done:(id)sender {
    NSString *msg = nil;
    if (self.author.text && self.author.text.length > 0) {
        HLAuthor *author = [NSEntityDescription insertNewObjectForEntityForName:@"HLAuthor" inManagedObjectContext:self.appDelegate.managedObjectContext];
        author.name = self.author.text;
        author.authorDesc = self.authorDesc.text;
        author.date = [NSDate date];
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
