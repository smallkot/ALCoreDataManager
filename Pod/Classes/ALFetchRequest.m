//
//  ALFetchRequest.m
//  Pods
//
//  Created by Aziz U. Latypov on 3/3/15.
//
//

#import "ALFetchRequest.h"

@implementation ALFetchRequest

- (instancetype)init
{
	self = [super init];
	if (self) {
		[self configureFetchRequest];
	}
	return self;
}

- (instancetype)initWithEntityName:(NSString *)entityName
{
	self = [super initWithEntityName:entityName];
	if (self) {
		[self configureFetchRequest];
	}
	return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self configureFetchRequest];
	}
	return self;
}

- (void)configureFetchRequest
{
}

@end
