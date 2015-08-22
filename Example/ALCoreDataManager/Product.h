//
//  Item.h
//  ALCoreDataManager
//
//  Created by Aziz U. Latypov on 2/18/15.
//  Copyright (c) 2015 aziz u. latypov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Product : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * price;
@property (nonatomic, retain) NSNumber * amount;
@property (nonatomic, retain) NSString * country;

@end
