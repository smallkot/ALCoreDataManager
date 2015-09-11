//
//  Country.h
//  ALCoreDataManager
//
//  Created by Aziz Latypov on 9/11/15.
//  Copyright (c) 2015 aziz u. latypov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Product;

@interface Country : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) Product *products;

@end
