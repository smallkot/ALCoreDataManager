//
//  ALTableViewController.m
//  ALCoreDataManager
//
//  Created by Aziz U. Latypov on 3/15/15.
//  Copyright (c) 2015 aziz u. latypov. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <ALCoreDataManager/ALCoreData.h>

#import "ALTableViewController.h"
#import "Item.h"

static NSString *const UpdateFinishedNotification = @"UpdateFinished";
static NSString *const TableViewCellReuseIdentifier = @"Cell";

@interface ALTableViewController ()

@property (weak, nonatomic) IBOutlet UIRefreshControl *activityIndicator;
@property (nonatomic, strong) NSArray *items;

@end

@implementation ALTableViewController

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	[self loadItems];
	
	[[NSNotificationCenter defaultCenter] addObserverForName:UpdateFinishedNotification
													  object:nil
													   queue:nil
												  usingBlock:^(NSNotification *note)
	{
		[self.activityIndicator endRefreshing];
		[self loadItems];
	}];
}

- (void)loadItems
{
	self.items = [[[Item all] orderedBy:@[@"title", @"price"]] execute];
	[self.tableView reloadData];
}

- (IBAction)actionDeleteAll:(id)sender {
	[self.items makeObjectsPerformSelector:@selector(remove)];
	[[ALCoreDataManager defaultManager] saveContext];
	[self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:TableViewCellReuseIdentifier forIndexPath:indexPath];
	Item * item = [self.items objectAtIndex:indexPath.row];
	cell.textLabel.text = item.title;
	cell.detailTextLabel.text = [item.price stringValue];
	return cell;
}

- (IBAction)actionRefresh:(id)sender {
	[[ALCoreDataManager defaultManager] performBlock:^(NSManagedObjectContext *localContext) {
		
		int i;
		ALManagedObjectFactory *factory = [[ALManagedObjectFactory alloc] initWithManagedObjectContext:localContext];
		
		for(i=0; i<18; i++){
			Item *a = (Item*)[Item createWithFields:nil
									   usingFactory:factory];
			
			a.title = [NSString stringWithFormat:@"%c",'A'+i];
			a.price = @(100 + (rand()%10));
			a.amount = @(10 + (rand()%10));
		}
		
	} andPostNotification:UpdateFinishedNotification];
}


@end
