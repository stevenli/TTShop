//
//  TSMobileChargeController.m
//  TTShop
//
//  Created by Steven Li on 12/12/11.
//  Copyright (c) 2011 PlayStation. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "TSMobileChargeController.h"
#import "TSHistoryPhoneController.h"
#import "TSMobileChargeConfirmController.h"

static NSString *contact_name = nil;
static NSString *contact_phone = nil;

@implementation TSMobileChargeController

@synthesize tab_ctrl_inner;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void) dealloc
{
    [tab_ctrl_inner release];
    
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
    
    self.title = @"手机充值";
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollEnabled = NO;
    
    UIBarButtonItem *btn_next_step = [[UIBarButtonItem alloc] initWithTitle:@"下一步"
                                                                      style:UIBarButtonItemStyleDone
                                                                     target:self
                                                                     action:@selector(btnNextStepClick:)];
    self.navigationItem.rightBarButtonItem = btn_next_step;
    [btn_next_step release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.tab_ctrl_inner = nil;
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (0 == indexPath.section)
    {
        cell.textLabel.text = @"充值号码：";
        
        UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(88.0f, 10.0f, 183.0f, 26.0f)];
        tf.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        tf.font = [UIFont systemFontOfSize:14.0f];
        tf.placeholder = @"请输入手机号码";
        tf.keyboardType = UIKeyboardTypeNumberPad;
        [cell addSubview:tf];
        [tf release];
        
        tf_phone_no = tf;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, 54, 54);
        [btn setImage:[UIImage imageNamed:@"btn_conp"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnContactClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.accessoryView = btn;
    }
    else if (1 == indexPath.section)
    {
        
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (0 == section)
    {
        return nil;
    }
    else if (1 == section)
    {
        return @"历史充值号码";
    }
    
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if (0 == section)
    {
        return @"可以为自己充值,也可为通讯录好友充值";
    }
    
    return nil;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (1 == indexPath.section)
    {
        return 278.0f;
    }
    
    return 44.0f;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath 
{
    if (1 == indexPath.section)
    {
        cell.clipsToBounds = YES;
//        cell.backgroundColor = [UIColor blueColor];
        
        for (id sv in cell.subviews)
        {
//            NSLog(@"%@", sv);
            
            if ([@"UITableViewCellContentView" isEqualToString:NSStringFromClass([sv class])])
            {
                UIView *tmp_v = (UIView *)sv;
                tmp_v.clipsToBounds = YES;
                
                CGRect mask_frm = tmp_v.frame;
                mask_frm.origin.x += 1;
                mask_frm.origin.y += 1;
                mask_frm.size.width -= 1;
                mask_frm.size.height -= 1;
                
                TSHistoryPhoneController *ctrl = [[TSHistoryPhoneController alloc] initWithStyle:UITableViewStylePlain];
                ctrl.tableView.frame = tmp_v.frame;
                ctrl.tableView.layer.cornerRadius = 14.0f;
                ctrl.tableView.layer.masksToBounds = YES;
                [cell addSubview:ctrl.tableView];
                
                ctrl.delegate = self;
                self.tab_ctrl_inner = ctrl;
                [ctrl release];
                
                break;
            }
        }
    }
}

#pragma mark - select contact from AddressBook

- (void) btnContactClick:(id)sender
{
    ABPeoplePickerNavigationController *ctrl = [[ABPeoplePickerNavigationController alloc] init];
    ctrl.peoplePickerDelegate = self;
    [self presentModalViewController:ctrl animated:YES];
    [ctrl release];
}

#pragma mark ABPeoplePickerNavigationControllerDelegate

- (BOOL) peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
    return YES;
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    if (kABPersonPhoneProperty == property)
    {
        ABMutableMultiValueRef phones = ABRecordCopyValue(person, property);
        int idx = ABMultiValueGetIndexForIdentifier(phones, identifier);
        NSString *phone = (NSString *)ABMultiValueCopyValueAtIndex(phones, idx);
        tf_phone_no.text = phone;
        [phone release];
        
        if (contact_name)
        {
            [contact_name release];
            contact_name = nil;
        }
        
        contact_name = (NSString *)ABRecordCopyCompositeName(person);
        [contact_name retain];
        
        if (contact_phone)
        {
            [contact_phone release];
            contact_phone = nil;
        }
        
        contact_phone = [[NSString alloc] initWithString:phone];
    }
    
    [peoplePicker dismissModalViewControllerAnimated:YES];
    
    return NO;
}

- (void) peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    [peoplePicker dismissModalViewControllerAnimated:YES];
}

#pragma mark - TSHistoryPhoneDelegate

- (void) tsHistoryPhoneController:(TSHistoryPhoneController *)controller didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell = [controller.tableView cellForRowAtIndexPath:indexPath];
    
    if (tf_phone_no)
    {
        tf_phone_no.text = cell.detailTextLabel.text;
        [tf_phone_no resignFirstResponder];
    }
}

#pragma mark - btn next step click

- (void) btnNextStepClick:(id)sender
{
    if (0 == tf_phone_no.text.length)
    {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil
                                                     message:@"请填写接受充值的手机号码"
                                                    delegate:nil
                                           cancelButtonTitle:@"取消"
                                           otherButtonTitles:nil, nil];
        [av show];
        [av release];
        
        return;
    }
    
    if (![tf_phone_no.text isEqualToString:contact_phone])
    {
        [tab_ctrl_inner addAPhoneNO:tf_phone_no.text contact:@"未知"];
    }
    else
    {
        [tab_ctrl_inner addAPhoneNO:tf_phone_no.text contact:contact_name];
    }
    
    
    TSMobileChargeConfirmController *ctrl = [[TSMobileChargeConfirmController alloc] initWithStyle:UITableViewStyleGrouped];
    [self.navigationController pushViewController:ctrl animated:YES];
    [ctrl release];
}

@end
