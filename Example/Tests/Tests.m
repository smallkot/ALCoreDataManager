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

SpecBegin(ALCoreDataManager)

describe(@"default manger", ^{
	it(@"should not be nil", ^{
		expect([ALCoreDataManager defaultManager]).notTo.beNil;
	});
});

SpecEnd
