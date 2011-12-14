//
//  TSAppsListViewController.m
//  TTShop
//
//  Created by Steven Li on 12/3/11.
//  Copyright (c) 2011 PlayStation. All rights reserved.
//

#import "TSAppsListViewController.h"
#import "TSAppsGridViewController.h"
#import "TSMobileChargeController.h"


@implementation TSAppsListViewController

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
    
    self.title = @"生活应用";
    
    UISegmentedControl *sg_ctrl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"x", @"a", nil]];
	sg_ctrl.segmentedControlStyle = UISegmentedControlStyleBar;
	[sg_ctrl addTarget:self action:@selector(segmentedControlChange:) forControlEvents:UIControlEventValueChanged];
	sg_ctrl.frame = CGRectMake(0, 0, 70, 30);
	sg_ctrl.selectedSegmentIndex = 0;
    self.sg_switch = sg_ctrl;
    [sg_ctrl release];
    
    UIBarButtonItem *btn_view_switch = [[UIBarButtonItem alloc] initWithCustomView:sg_ctrl];
    self.navigationItem.leftBarButtonItem = btn_view_switch;

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.imageView.image = [UIImage imageNamed:@"icon140"];
    
    switch (indexPath.section)
    {
        case 0:
            cell.textLabel.text = @"游戏点卡";
            break;
            
        case 1:
            cell.textLabel.text = @"手机冲值";
            break;
        
        case 2:
            cell.textLabel.text = @"转账汇款";
            break;
    }
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (1 == indexPath.section)
    {
        TSMobileChargeController *ctrl = [[TSMobileChargeController alloc] initWithStyle:UITableViewStyleGrouped];
        ctrl.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:ctrl animated:YES];
        [ctrl release];
    }
}

- (CGFloat)tableView: (UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 70.0f;
}

#pragma mark -

- (IBAction) segmentedControlChange:(id)sender
{
    UISegmentedControl *sg_ctrl = (UISegmentedControl *)sender;
    
    if (1 == sg_ctrl.selectedSegmentIndex)
    {
        TSAppsGridViewController *ctrl = [[TSAppsGridViewController alloc] initWithNibName:nil bundle:nil];
        [self.navigationController pushViewController:ctrl animated:NO];
        [ctrl release];
    }
}

@end