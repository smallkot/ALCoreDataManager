//
//  ALManagedObjectFactory+Singleton.h
//  
//
//  Created by Aziz U. Latypov on 8/11/14.
//
//

#import "ALManagedObjectFactory.h"

@interface ALManagedObjectFactory (Singleton)

+ (ALManagedObjectFactory*)defaultFactory;

@end
