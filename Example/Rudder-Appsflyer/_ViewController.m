//
//  _ViewController.m
//  Rudder-Appsflyer
//
//  Created by arnabp92 on 02/21/2020.
//  Copyright (c) 2020 arnabp92. All rights reserved.
//

#import "_ViewController.h"
#import <Rudder/Rudder.h>
#import <AppsFlyerLib/AppsFlyerLib.h>

@interface _ViewController ()

@end

@implementation _ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [[RSClient sharedInstance] track:@"account: created"];
    [[RSClient sharedInstance] track:@"account: authenticated"];
    [[RSClient sharedInstance] track:@"account: signed in"];
    [[RSClient sharedInstance] identify:@"developer_user_id" traits:@{@"foo": @"bar", @"foo1": @"bar1", @"email": @"example@gmail.com"}];
    [[RSClient sharedInstance] track:@"challenge: applied points" properties:@{@"key":@"value", @"foo": @"bar", @"c_prop": @{@"c_key_1": @"c_val_1"}}];
    [[RSClient sharedInstance] track:@"congratulated" properties:@{@"total":@2.99, @"currency": @"USD"}];
    
    NSString *appsFlyerId = [[AppsFlyerLib shared] getAppsFlyerUID];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
