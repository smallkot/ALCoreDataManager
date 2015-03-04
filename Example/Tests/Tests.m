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

#import <ALCoreDataManager/ALCoreDataManager+Singleton.h>
#import <ALCoreDataManager/ALManagedObjectFactory+Singleton.h>
#import <ALCoreDataManager/NSManagedObject+Create.h>
#import <ALCoreDataManager/NSManagedObject+FetchRequest.h>
#import <ALCoreDataManager/ALFetchRequest+QueryBuilder.h>
#import <ALCoreDataManager/NSManagedObject+ActiveQuery.h>

#import "Item.h"

SpecBegin(ALCoreDataManager)

describe(@"default managed object context", ^{
	it(@"should not be nil", ^{
		expect([ALCoreDataManager defaultManager].managedObjectContext).notTo.beNil;
	});
});

//describe(@"CRUD", ^{
//	
//	__block NSManagedObjectContext *context;
//	__block ALManagedObjectFactory *factory;
//	
//	Item*(^item)(NSString *title, NSNumber *price, NSNumber *amount) =
//	^(NSString *title, NSNumber *price, NSNumber *amount)
//	{
//		NSPredicate *predicate =
//		[NSPredicate predicateWithFormat:@"title = %@ && price = %@ && amount = %@",title,price,amount];
//		NSArray *items =
//		[[[[Item all] where:predicate] limit:1] execute];
//		
//		Item *a = [items firstObject];
//		return a;
//	};
//	
//	
//	beforeEach(^{
//		context = mock([NSManagedObjectContext class]);
//		factory = mock([ALManagedObjectFactory class]);
//	});
//	
//	afterEach(^{
//		context = nil;
//		factory = nil;
//	});
//
//	it(@"should create item without dictionary", ^{
//		Item *itemMock = mock([Item class]);
//		[given([factory createObjectForEntityName:@"Item"]) willReturn:itemMock];
//		
//		Item *a = (Item*)[Item createWithFields:nil
//								   usingFactory:factory];
//
//		expect(a).notTo.beNil;
//	});
//
//	
//	it(@"should create item", ^{
//		Item *itemMock = mock([Item class]);
//		[given([factory createObjectForEntityName:@"Item"]) willReturn:itemMock];
//
//		Item *a = (Item*)[Item createWithFields:@{
//												  @"title" : @"A",
//												  @"price" : @(100),
//												  @"amount" : @(10)
//												  }
//						  usingFactory:factory];
//		
//		expect(a).notTo.beNil;
//		[verify(a) setValue:@"A" forKey:@"title"];
//		[verify(a) setValue:@(100) forKey:@"price"];
//		[verify(a) setValue:@(10) forKey:@"amount"];
//
//	});
//	
//	it(@"should be fetched", ^{
//		
//		Item *a = item(@"A",@(100),@(10));
//		
//		expect(a).notTo.beNil;
//		expect(a.title).to.equal(@"A");
//		expect(a.price).to.equal(@(100));
//		expect(a.amount).to.equal(@(10));
//	});
//	
//	it(@"should be update", ^{
//		Item *a = item(@"A",@(100),@(10));
//		
//		a.title = @"B";
//		a.price = @(120);
//		a.amount = @(160);
//		expect(a).notTo.beNil;
//		expect(a.title).to.equal(@"B");
//		expect(a.price).to.equal(@(120));
//		expect(a.amount).to.equal(@(160));
//
//	});
//	
//	it(@"should be remove",^{
//		Item *a = item(@"B",@(120),@(160));
//		
//		[a remove];
//		expect(a.deleted).to.beTruthy;
//	});
//	
//});

describe(@"in memory store", ^{
	
	__block ALCoreDataManager *manager;
	__block NSManagedObjectContext *context;
	__block ALManagedObjectFactory *factory;
	
	beforeAll(^{
		manager = [[ALCoreDataManager alloc] initWithInMemoryStore];
		context = manager.managedObjectContext;
		factory = [[ALManagedObjectFactory alloc] initWithManagedObjectContext:context];
	});
	
});

describe(@"query builder", ^{
	
	__block ALCoreDataManager *manager;
	__block NSManagedObjectContext *context;
	__block ALManagedObjectFactory *factory;
	
	beforeAll(^{
				
		manager = [[ALCoreDataManager alloc] initWithInMemoryStore];
		context = manager.managedObjectContext;
		factory = [[ALManagedObjectFactory alloc] initWithManagedObjectContext:context];
		
		// populate
		int i;
		for(i=0; i<20; i++){
			Item *a = (Item*)[Item createWithFields:nil
									   usingFactory:factory];
			
			a.title = [NSString stringWithFormat:@"%c",'A'+i];
			a.price = @(10 + i*(rand()%50));
			a.amount = @(100 + i*(rand()%200));
		}
	});
	
	it(@"should fetch all", ^{
		expect([[[Item allInManagedObjectContext:context] array] count]).equal(20);
	});
	
	afterAll(^{
		manager = nil;
		context = nil;
		factory = nil;
	});
});


SpecEnd
