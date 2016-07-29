//
//  HLBook+CoreDataProperties.h
//  books
//
//  Created by 韩露露 on 16/7/29.
//  Copyright © 2016年 韩露露. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "HLBook.h"

NS_ASSUME_NONNULL_BEGIN

@interface HLBook (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *publishHouse;
@property (nullable, nonatomic, retain) NSDate *date;
@property (nullable, nonatomic, retain) HLAuthor *author;

@end

NS_ASSUME_NONNULL_END
