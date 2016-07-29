//
//  HLAuthor+CoreDataProperties.h
//  books
//
//  Created by 韩露露 on 16/7/29.
//  Copyright © 2016年 韩露露. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "HLAuthor.h"

NS_ASSUME_NONNULL_BEGIN

@interface HLAuthor (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *authorDesc;
@property (nullable, nonatomic, retain) NSSet<HLBook *> *books;

@end

@interface HLAuthor (CoreDataGeneratedAccessors)

- (void)addBooksObject:(HLBook *)value;
- (void)removeBooksObject:(HLBook *)value;
- (void)addBooks:(NSSet<HLBook *> *)values;
- (void)removeBooks:(NSSet<HLBook *> *)values;

@end

NS_ASSUME_NONNULL_END
