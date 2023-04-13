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
    // Do any additional setup after loading the view, typically from a nib
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) track {
    [[RSClient sharedInstance] track:@"New Track event" properties:@{
        @"key_1" : @"value_1",
        @"key_2" : @"value_2"
    }];
    [[RSClient sharedInstance] track:@"Products Searched"
                          properties:@{@"query": @"HDMI cable"}];
    
    NSDictionary *product1 = @{@"product_id": @"223344ffdds3ff3",
                               @"sku": @"12345",
                               @"name": @"Just Another Game",
                               @"price": @22,
                               @"position": @2,
                               @"category": @"Games and Entertainment",
                               @"url": @"https://www.myecommercewebsite.com/product",
                               @"image_url": @"https://www.myecommercewebsite.com/product/path.jpg"};
    
    NSDictionary *product2 = @{@"product_id": @"343344ff5567ff3",
                               @"sku": @"12346",
                               @"name": @"Wrestling Trump Cards",
                               @"price": @4,
                               @"position": @21,
                               @"category": @"Card Games"};
    
    NSArray *products = @[product1, product2];
    
    NSDictionary *properties = @{@"list_id": @"list1",
                                 @"category": @"What's New",
                                 @"products": products};
    
    [[RSClient sharedInstance] track:@"Product List Viewed" properties:properties];
    
    properties = @{@"product_id": @"123",
                   @"sku": @"F15",
                   @"category": @"Games",
                   @"name": @"Game",
                   @"brand": @"Gamepro",
                   @"variant": @"111",
                   @"price": @13.49,
                   @"quantity": @11,
                   @"coupon": @"DISC21",
                   @"currency": @"USD",
                   @"position": @1,
                   @"url": @"https://www.website.com/product/path",
                   @"image_url": @"https://www.website.com/product/path.png"};
    
    [[RSClient sharedInstance] track:@"Product Viewed" properties:properties];
    
    properties = @{@"wishlist_id": @"12345",
                   @"wishlist_name": @"Games",
                   @"product_id": @"235564423234",
                   @"sku": @"F-17",
                   @"category": @"Games",
                   @"name": @"Cards",
                   @"brand": @"Imagepro",
                   @"variant": @"123",
                   @"price": @8.99,
                   @"quantity": @1,
                   @"coupon": @"COUPON",
                   @"position": @1,
                   @"url": @"https://www.site.com/product/path",
                   @"image_url": @"https://www.site.com/product/path.jpg"};
    
    [[RSClient sharedInstance] track:@"Product Added to Wishlist" properties:properties];
    
    properties = @{@"product_id": @"123",
                   @"sku": @"F15",
                   @"category": @"Games",
                   @"name": @"Game",
                   @"brand": @"Gamepro",
                   @"variant": @"111",
                   @"price": @13.49,
                   @"quantity": @11,
                   @"coupon": @"DISC21",
                   @"position": @1,
                   @"url": @"https://www.website.com/product/path",
                   @"image_url": @"https://www.website.com/product/path.png"};
    
    [[RSClient sharedInstance] track:@"Product Added" properties:properties];
    
    
    product1 = @{@"product_id": @"123",
                               @"sku": @"G-32",
                               @"name": @"Monopoly",
                               @"price": @14,
                               @"quantity": @1,
                               @"category": @"Games",
                               @"url": @"https://www.website.com/product/path",
                               @"image_url": @"https://www.website.com/product/path.jpg"};
    
    product2 = @{@"product_id": @"345",
                               @"sku": @"F-32",
                               @"name": @"UNO",
                               @"price": @3.45,
                               @"quantity": @2,
                               @"category": @"Games"};
    
    products = @[product1, product2];
    
    properties = @{@"order_id": @"1234",
                                 @"affiliation": @"Apple Store",
                                 @"value": @20,
                                 @"revenue": @15.0,
                                 @"shipping": @4,
                                 @"tax": @1,
                                 @"discount": @1.5,
                                 @"coupon": @"ImagePro",
                                 @"currency": @"USD",
                                 @"products": products};
    
    [[RSClient sharedInstance] track:@"Checkout Started" properties:properties];
    
    [[RSClient sharedInstance] track:@"Order Completed" properties:@{@"checkout_id": @"12345",
                                                                     @"order_id": @"1234",
                                                                     @"affiliation": @"Apple Store",
                                                                     @"total": @20,
                                                                     @"revenue": @15.0,
                                                                     @"shipping": @4,
                                                                     @"tax": @1,
                                                                     @"discount": @1.5,
                                                                     @"coupon": @"ImagePro",
                                                                     @"currency": @"USD",
                                                                     @"products": @[
                                                                                @{@"product_id": @"123",
                                                                                  @"sku": @"G-32",
                                                                                  @"name": @"Monopoly",
                                                                                  @"price": @14,
                                                                                  @"quantity": @1,
                                                                                  @"category": @"Games",
                                                                                  @"url": @"https://www.website.com/product/path",
                                                                                  @"image_url": @"https://www.website.com/product/path.jpg"
                                                                                },
                                                                                @{@"product_id": @"345",
                                                                                  @"sku": @"F-32",
                                                                                  @"name": @"UNO",
                                                                                  @"price": @3.45,
                                                                                  @"quantity": @2,
                                                                                  @"category": @"Games",
                                                                                }]
                                                                   }];
    
    [[RSClient sharedInstance] track:@"Promotion Viewed" properties:@{
    @"promotion_id": @"promo1",
    @"creative": @"banner1",
    @"name": @"sale",
    @"position": @"home_top"
    }];

    [[RSClient sharedInstance] track:@"Promotion Clicked" properties:@{
    @"promotion_id": @"promo1",
    @"creative": @"banner1",
    @"name": @"sale",
    @"position": @"home_top"
    }];

    [[RSClient sharedInstance] track:@"Payment Info Entered" properties:@{
    @"checkout_id": @"12344",
    @"order_id": @"123"
    }];

    [[RSClient sharedInstance] track:@"Product Shared" properties:@{
    @"share_via": @"SMS",
    @"share_message": @"Check this",
    @"recipient": @"name@friendsemail.com",
    @"product_id": @"12345872254426",
    @"sku": @"F-13",
    @"category": @"Games",
    @"name": @"Cards",
    @"brand": @"Maples",
    @"variant": @"150s",
    @"price": @15.99,
    @"url": @"https://www.myecommercewebsite.com/product/prod",
    @"image_url": @"https://www.myecommercewebsite.com/product/prod.jpg",
    }];

    [[RSClient sharedInstance] track:@"Cart Shared" properties:@{
    @"share_via": @"SMS",
    @"share_message": @"Check this",
    @"recipient": @"friend@friendsemail.com",
    @"cart_id": @"1234df2ddss",
    @"products": @[@{@"product_id": @"125"}, @{@"product_id": @"297"}],
    }];

    [[RSClient sharedInstance] track:@"Product Reviewed" properties:@{
    @"product_id": @"12345",
    @"review_id": @"review12",
    @"review_body": @"Good product, delivered in excellent condition",
    @"rating": @"5",
    }];

    [[RSClient sharedInstance] track:@"Product Removed" properties:@{
    @"product_id": @"123",
    @"sku": @"F15",
    @"category": @"Games",
    @"name": @"Game",
    @"brand": @"Gamepro",
    @"variant": @"111",
    @"price": @13.49,
    @"quantity": @11,
    @"coupon": @"DISC21",
    @"position": @1,
    @"url": @"https://www.website.com/product/path",
    @"image_url": @"https://www.website.com/product/path.png",
    }];
    }

- (IBAction)onButtonTap:(UIButton *)sender {
    switch (sender.tag) {
        case 0: {
            [[RSClient sharedInstance] identify:@"test_userid_ios"];
            break;
        case 1: {
            NSDate *birthday = [[NSDate alloc] init];
            [[RSClient sharedInstance] identify:@"test_userid_ios" traits: @{
                @"birthday": birthday,
                @"address": @{
                    @"city": @"Kolkata",
                    @"country": @"India"
                },
                @"firstname": @"First Name",
                @"lastname": @"Last Name",
                @"name": @"Rudder-Bugsnag iOS",
                @"gender": @"Male",
                @"phone": @"0123456789",
                @"email": @"test@gmail.com",
                @"key-1": @"value-1",
                @"key-2": @1234
            }];
            
            
        }
            break;
        case 2:
            [self track];
            
            break;
        case 3:
            [[RSClient sharedInstance] alias:@"test_userid_ios_2"];
            break;
        }
    }
}

@end
