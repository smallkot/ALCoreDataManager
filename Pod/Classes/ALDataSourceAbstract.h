//
//  ALDataSource.h
//  Pods
//
//  Created by Aziz U. Latypov on 8/11/14.
//
//

#import <Foundation/Foundation.h>

@class ALDataSourceAbstract;

@protocol ALDataSourceAbstractSectionItem <NSObject>

/* Name of the section
 */
@property (nonatomic, readonly) NSString *name;

/* Title of the section (used when displaying the index)
 */
@property (nonatomic, readonly) NSString *indexTitle;

/* Number of objects in section
 */
@property (nonatomic, readonly) NSUInteger numberOfObjects;

@end

@interface ALDataSourceAbstract : NSObject

- (NSInteger)numberOfSections;
- (NSInteger)numberOfObjectsInSection:(NSInteger)sectionIndex;

- (id<ALDataSourceAbstractSectionItem>)sectionAtIndex:(NSInteger)sectionIndex;

- (id)objectAtIndexPath:(NSIndexPath*)indexPath;
- (NSIndexPath*)indexPathForObject:(id)object;

// predicate
@property (nonatomic, strong) NSPredicate *predicate;

@end
