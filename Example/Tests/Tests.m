//
//  ALCoreDataManagerTests.m
//  ALCoreDataManagerTests
//
//  Created by aziz u. latypov on 08/10/2014.
//  Copyright (c) 2014 aziz u. latypov. All rights reserved.
//

#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#define MOCKITO_SHORTHAND
#import <OCMockito/OCMockito.h>

#import <ALCoreDataManager/ALCoreData.h>

#import "Item.h"

SpecBegin(ALCoreDataManager)

describe(@"default managed object context", ^{
	it(@"should not be nil", ^{
		expect([ALCoreDataManager defaultManager].managedObjectContext).notTo.beNil;
	});
});

describe(@"in memory store", ^{
	
	__block ALCoreDataManager *manager;
	__block NSManagedObjectContext *context;
	__block ALManagedObjectFactory *factory;
	
	Item*(^item)(NSString *title, NSNumber *price, NSNumber *amount) =
	^(NSString *title, NSNumber *price, NSNumber *amount)
	{
		NSPredicate *predicate =
		[NSPredicate predicateWithFormat:@"title = %@ && price = %@ && amount = %@",title,price,amount];
		NSArray *items =
		[[[[Item allInManagedObjectContext:context] where:predicate] limit:1] execute];
		
		Item *a = [items firstObject];
		return a;
	};

	
	beforeAll(^{
		manager = [[ALCoreDataManager alloc] initWithInMemoryStore];
		context = manager.managedObjectContext;
		factory = [[ALManagedObjectFactory alloc] initWithManagedObjectContext:context];
	});
	
	it(@"should create item without dictionary", ^{
		[factory createObjectForEntityName:@"Item"];
		
		Item *a = (Item*)[Item createWithFields:nil
								   usingFactory:factory];
		
		expect(a).notTo.beNil;
	});
	
	
	it(@"should create item", ^{
		[factory createObjectForEntityName:@"Item"];
		
		Item *a = (Item*)[Item createWithFields:@{
												  @"title" : @"A",
												  @"price" : @(100),
												  @"amount" : @(10)
												  }
								   usingFactory:factory];
		
		expect(a).notTo.beNil;
		expect([a valueForKey:@"title"]).equal(@"A");
		expect([a valueForKey:@"price"]).equal(@(100));
		expect([a valueForKey:@"amount"]).equal(@(10));
		
	});
	
	it(@"should be fetched", ^{
		
		Item *a = item(@"A",@(100),@(10));
		
		expect(a).notTo.beNil;
		expect(a.title).to.equal(@"A");
		expect(a.price).to.equal(@(100));
		expect(a.amount).to.equal(@(10));
	});
	
	it(@"should be update", ^{
		Item *a = item(@"A",@(100),@(10));
		
		a.title = @"B";
		a.price = @(120);
		a.amount = @(160);
		
		expect(a).notTo.beNil;
		expect(a.title).to.equal(@"B");
		expect(a.price).to.equal(@(120));
		expect(a.amount).to.equal(@(160));
		
	});
	
	it(@"should be remove",^{
		Item *a = item(@"B",@(120),@(160));
		
		[a remove];
		expect(a.deleted).to.beTruthy;
	});
	
	afterAll(^{
		manager = nil;
		context = nil;
		factory = nil;
	});
	
});

describe(@"query builder", ^{
	
	__block ALCoreDataManager *manager;
	__block NSManagedObjectContext *context;
	__block ALManagedObjectFactory *factory;
	
	beforeAll(^{
		
		manager = [ALCoreDataManager defaultManager];
		context = manager.managedObjectContext;
		factory = [[ALManagedObjectFactory alloc] initWithManagedObjectContext:context];
		
		NSArray *existingItems = [[Item allInManagedObjectContext:context] execute];
		for(Item *a in existingItems){
			[a remove];
		}
		
		[context save:NULL];
		
		// populate
		int i;
		
		for(i=0; i<18; i++){
			Item *a = (Item*)[Item createWithFields:nil
									   usingFactory:factory];
			
			a.title = [NSString stringWithFormat:@"%c",'A'+i];
			a.price = @(100 + (rand()%10));
			a.amount = @(10 + (rand()%10));
		}
		
		Item *a = (Item*)[Item createWithFields:nil
								   usingFactory:factory];
		
		a.title = [NSString stringWithFormat:@"%c",'a'];
		a.price = @(200);
		a.amount = @(10);

		Item *b = (Item*)[Item createWithFields:nil
								   usingFactory:factory];
		
		b.title = [NSString stringWithFormat:@"%c",'Z'];
		b.price = @(100);
		b.amount = @(10);

		[context save:NULL];
	});
	
	it(@"should fetch all", ^{
		NSArray *items = [[Item allInManagedObjectContext:context] execute];
		
		expect(items.count).equal(20);
	});
	
	it(@"should filter", ^{
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title = 'B'"];
		NSArray *items = [[[Item allInManagedObjectContext:context] where:predicate] execute];
		
		expect(items.count).equal(1);
	});
	
	it(@"should sort", ^{
		NSArray *items = [[[Item allInManagedObjectContext:context] orderedBy:@[@"title"]] execute];
		
		BOOL isSorted = YES;
		int i;
		Item *a = [items firstObject];
		for(i=1; i<items.count; i++){
			Item *b = [items objectAtIndex:i];
			NSComparisonResult r = [b.title compare:a.title];
			if(r == NSOrderedAscending){
				isSorted = NO;
				break;
			}
			a = b;
		}
		
		expect(isSorted).equal(YES);
	});
	
	it(@"should count all", ^{
		NSArray *items = [[[Item allInManagedObjectContext:context] count] execute];
		NSNumber *count = items.firstObject;
		
		expect(count.integerValue).equal(20);
	});
	
	it(@"should count with predicate", ^{
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title = 'B'"];
		NSArray *items = [[[[Item allInManagedObjectContext:context] where:predicate] count] execute];
		NSNumber *count = items.firstObject;
		
		expect(count.integerValue).equal(1);
	});

	it(@"should limit", ^{
		NSArray *items = [[[Item allInManagedObjectContext:context] limit:10] execute];
		
		expect(items.count).equal(10);
	});
	
	it(@"should return only distinct", ^{
		NSString *key = @"amount";
		NSArray *items = [[[[Item allInManagedObjectContext:context] properties:@[key]] distinct] execute];
		
		BOOL onlyDistinct = YES;
		Item *a = nil;
		NSMutableSet* set = [NSMutableSet new];
		
		for(Item *b in items){
			if(a){
				if([set containsObject:[b valueForKey:key]]){
					onlyDistinct = NO;
					break;
				}
			}
			a = b;
			[set addObject:[a valueForKey:key]];
		}

		expect(items.count).to.beGreaterThan(0);
		expect(items.count).to.beLessThan(20);
		expect(onlyDistinct).equal(YES);
	});
	
	it(@"should aggregate", ^{
		NSArray *items = [[[[[Item allInManagedObjectContext:context]
						   aggregatedBy:@[@[kAggregatorMax,@"price"]]]
						   groupedBy:@[@"amount"]]
						  having:[NSPredicate predicateWithFormat:@"amount >= 10"]]
						  execute];
		
		double maxPrice = -1;
		for(NSDictionary *d in items){
			double x = [[d valueForKey:@"maxPrice"] doubleValue];
			if(x>maxPrice){
				maxPrice = x;
			}
		}
		
		expect(maxPrice).equal(200.f);
	});
	
	afterAll(^{
		manager = nil;
		context = nil;
		factory = nil;
	});
});


SpecEnd
