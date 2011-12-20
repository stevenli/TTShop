//
//  TSTradeRemindController.m
//  TTShop
//
//  Created by Steven Li on 12/3/11.
//  Copyright (c) 2011 PlayStation. All rights reserved.
//

#import "TSTradeRemindController.h"
#import "TSSysNoticeController.h"
#import "TSTradeRemindCell.h"
#import "TSTradeRemindModel.h"
#import "EGORefreshTableHeaderView.h"


@implementation TSTradeRemindController

@synthesize sg_switch;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) dealloc
{
    self.sg_switch = nil;
    
    [refresh_view_h release];
    [refresh_view_b release];
    
    [model release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    UISegmentedControl *sg_ctrl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"交易提醒", @"系统公告", nil]];
	sg_ctrl.segmentedControlStyle = UISegmentedControlStyleBar;
	[sg_ctrl addTarget:self action:@selector(segmentedControlChange:) forControlEvents:UIControlEventValueChanged];
	sg_ctrl.frame = CGRectMake(0, 0, 207, 30);
	sg_ctrl.selectedSegmentIndex = 0;
	self.navigationItem.titleView = sg_ctrl;
    [sg_ctrl release];
    self.sg_switch = sg_ctrl;
    
        //top refresh header
	CGRect top_rect = CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, 320.0f, self.tableView.bounds.size.height);
	refresh_view_h = [[EGORefreshTableHeaderView alloc] initWithoutDateLabel:top_rect];
	refresh_view_h.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0];
	[self.tableView addSubview:refresh_view_h];
    
        //bottom refresh header
	CGRect bottom_rect = CGRectMake(0.0f, -50.0f, 320.0f, 60.0f);
	refresh_view_b = [[EGORefreshTableHeaderView alloc] initWithoutDateLabel:bottom_rect];
	refresh_view_b.backgroundColor = [UIColor whiteColor];
	refresh_view_b.state = EGOOPullRefreshNormalUP;
	[self.tableView addSubview:refresh_view_b];
	refresh_view_b.hidden = YES;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.sg_switch = nil;
    
    [refresh_view_h release];
    refresh_view_h = nil;
    
    [refresh_view_b release];
    refresh_view_b = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.sg_switch.selectedSegmentIndex = 0;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    TSTradeRemindCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[[TSTradeRemindCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setContent:nil];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.row + 1 == 10 && tableView.contentSize.height > tableView.bounds.size.height)
	{
		CGRect bottom_rect = CGRectMake(0.0f, tableView.contentSize.height, 320.0f, 60.0f);
		refresh_view_b.frame = bottom_rect;
		refresh_view_b.hidden = NO;
	}
}

- (void)scrollViewDidScroll: (UIScrollView *)scrollView
{	
	if (!scrollView.isDragging)
	{
		return;
	}
	
	if (refresh_view_h.state == EGOOPullRefreshPulling && scrollView.contentOffset.y > -65.0f && scrollView.contentOffset.y < 0.0f) 
	{
		[refresh_view_h setState:EGOOPullRefreshNormal];
	} 
	else if (refresh_view_h.state == EGOOPullRefreshNormal && scrollView.contentOffset.y < -65.0f) 
	{
		[refresh_view_h setState:EGOOPullRefreshPulling];
	}
	
	if (refresh_view_b.state == EGOOPullRefreshPulling &&
		scrollView.contentOffset.y + scrollView.bounds.size.height - scrollView.contentSize.height < 65.0f)
	{
		[refresh_view_b setState:EGOOPullRefreshNormalUP];
	}
	else if (refresh_view_b.state == EGOOPullRefreshNormalUP &&
			 scrollView.contentOffset.y + scrollView.bounds.size.height - scrollView.contentSize.height > 65.0f)
	{
		[refresh_view_b setState:EGOOPullRefreshPulling];
	}
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	if (scrollView.contentOffset.y < - 65.0f)
	{
		[refresh_view_h setState:EGOOPullRefreshLoading];
		self.tableView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
		
	}
	else if (scrollView.contentOffset.y + scrollView.bounds.size.height - scrollView.contentSize.height > 65.0f)
	{
		[refresh_view_b setState:EGOOPullRefreshLoading];
		self.tableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 60.0f, 0.0f);
		
	}
}

#pragma mark -

- (IBAction) segmentedControlChange:(id)sender
{
    UISegmentedControl *sg_ctrl = (UISegmentedControl *)sender;
    
    if (0 == sg_ctrl.selectedSegmentIndex)
    {
        return;
    }
    
    TSSysNoticeController *ctrl = [[TSSysNoticeController alloc] initWithStyle:UITableViewStylePlain];
    [self.navigationController pushViewController:ctrl animated:NO];
    [ctrl release];
}

- (void) loadData
{
    if (!model)
    {
        model = [[TSTradeRemindModel alloc] initWithDelegate:self];
    }
    
    [model fetchNewData];
}

@end
