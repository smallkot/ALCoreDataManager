//
//  ALDataSource.m
//  Pods
//
//  Created by Aziz U. Latypov on 8/11/14.
//
//

#import "ALDataSourceAbstract.h"

@implementation ALDataSourceAbstract

- (NSInteger)itemsCount
{
    return 0;
}

- (id)itemAtIndexPath:(NSIndexPath*)indexPath
{
    return nil;
}

- (NSIndexPath*)indexPathForItem:(id)item
{
    return nil;
}

@end
