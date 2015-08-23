//
//  ALDataSource.h
//  Pods
//
//  Created by Aziz U. Latypov on 8/11/14.
//
//

#import <Foundation/Foundation.h>

@interface ALDataSourceAbstract : NSObject

- (NSInteger)itemsCount;
- (id)itemAtIndexPath:(NSIndexPath*)indexPath;
- (NSIndexPath*)indexPathForItem:(id)item;

// predicate
@property (nonatomic, strong) NSPredicate *predicate;

@end
