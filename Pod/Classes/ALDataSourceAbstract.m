//
//  ALDataSource.m
//  Pods
//
//  Created by Aziz U. Latypov on 8/11/14.
//
//

#import "ALDataSourceAbstract.h"

@implementation ALDataSourceAbstract

- (NSInteger)numberOfSections {
    return 0;
}

- (NSInteger)numberOfObjectsInSection:(NSInteger)sectionIndex {
    return 0;
}

- (id<ALDataSourceAbstractSectionItem>)sectionAtIndex:(NSInteger)sectionIndex {
    return nil;
}

- (id)objectAtIndexPath:(NSIndexPath*)indexPath {
    return nil;
}

- (NSIndexPath*)indexPathForObject:(id)object {
    return nil;
}

@end
