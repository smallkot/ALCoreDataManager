//
//  ALCoreDataManagerTests.m
//  ALCoreDataManagerTests
//
//  Created by aziz u. latypov on 08/10/2014.
//  Copyright (c) 2014 aziz u. latypov. All rights reserved.
//

#import <Specta/Specta.h>
#import <Expecta/Expecta.h>

#import <ALCoreDataManager/ALCoreDataManager+Singleton.h>
#import <ALCoreDataManager/NSManagedObject+Create.h>
#import <ALCoreDataManager/NSManagedObject+Query.h>
#import <ALCoreDataManager/ALFetchRequest.h>
#import <ALCoreDataManager/NSManagedObject+FetchRequest.h>
#import <ALCoreDataManager/ALFetchRequest+QueryBuilder.h>

#import "Item.h"

SpecBegin(ALCoreDataManager)

/*
 NSLog(@"%@",[ALCoreDataManager defaultManager].managedObjectContext);
	
	Item *a = (Item*)[Item create];
	a.title = @"A";
	a.price = @(100);
	a.amount = @(100);
	
	Item *b = (Item*)[Item create];
	b.title = @"B";
	b.price = @(150);
	b.amount = @(200);
 
	Item *c = (Item*)[Item create];
	c.title = @"C";
	c.price = @(200);
	c.amount = @(300);
	
	NSLog(@"All:\n %@",
	[Item findAll]);
	
	NSLog(@"All with price > 100:\n %@",
	[Item findAllWithPredicate:[NSPredicate predicateWithFormat:@"price > 100"]]);
 
	NSLog(@"All sorted by price DESC, title ASC:\n %@",
	[Item findSortedBy:@[
 @[@"price", @(NO)],
 @[@"title"]
 ]]);
 
	NSLog(@"All sorted by price DESC, title ASC and price > 100:\n %@",
	[Item findSortedBy:@[
 @[@"price", @(NO)],
 @[@"title"]
 ]
 withPredicate:[NSPredicate predicateWithFormat:@"price > 100"]]);
	
	[[ALCoreDataManager defaultManager] saveContext];
	
	NSLog(@"Sum amount:\n %@",
	[Item findAggregatedBy:@[
 @[@"sum:", @"amount"]
 ]
 withPredicate:[NSPredicate predicateWithFormat:@"price > 0"]]);
	
	NSArray *all = [Item findAll];
	for (Item *item in all) {
 [[ALCoreDataManager defaultManager].managedObjectContext deleteObject:item];
	}
 
	[[ALCoreDataManager defaultManager] saveContext];

 */

describe(@"default managed object context", ^{
	it(@"should not be nil", ^{
		expect([ALCoreDataManager defaultManager].managedObjectContext).notTo.beNil;
	});
});


describe(@"CRUD", ^{
	
	it(@"should create item", ^{
		Item *a = (Item*)[Item create];
		a.title = @"A";
		a.price = @(100);
		a.amount = @(100);
		
		expect(a).notTo.beNil;
		expect(a.title).to.equal(@"A");
		expect(a.price).to.equal(@(100));
		expect(a.amount).to.equal(@(100));
	});
	
	it(@"should be fetched", ^{
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title = 'A' && price = 100 && amount = 100"];
		NSFetchRequest *fetchA =
		[[[Item fetchRequest] where:predicate] limit:1];
		NSArray *items = [Item findWithFetchRequest:fetchA];
		
		Item *a = [items firstObject];
		
		expect(a).notTo.beNil;
		expect(a.title).to.equal(@"A");
		expect(a.price).to.equal(@(100));
		expect(a.amount).to.equal(@(100));
	});
	
	
});




SpecEnd
