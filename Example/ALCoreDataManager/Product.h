//
//  Product.h
//  ALCoreDataManager
//
//  Created by Aziz Latypov on 9/11/15.
//  Copyright (c) 2015 aziz u. latypov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Country;

@interface Product : NSManagedObject

@property (nonatomic, retain) NSNumber * amount;
@property (nonatomic, retain) NSNumber * price;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) Country *country;

@end
