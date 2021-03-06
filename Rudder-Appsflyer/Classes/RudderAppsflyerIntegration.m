//
//  RudderAdjustIntegration.m
//  FBSnapshotTestCase
//
//  Created by Arnab Pal on 29/10/19.
//

#import "RudderAppsflyerIntegration.h"

@implementation RudderAppsflyerIntegration

#pragma mark - Initialization

- (instancetype)initWithConfig:(NSDictionary *)config withAnalytics:(nonnull RSClient *)client  withRudderConfig:(nonnull RSConfig *)rudderConfig {
    self = [super init];
    if (self) {
        NSString *devKey = [config objectForKey:@"devKey"];
        NSString *appleAppId = [config objectForKey:@"appleAppId"];
        
        if (devKey != nil) {
            _afLib = [AppsFlyerLib shared];
            
            [_afLib setAppsFlyerDevKey:devKey];
            [_afLib setAppleAppID:appleAppId];
            
            if (rudderConfig.logLevel >= RSLogLevelDebug) {
                _afLib.isDebug = YES;
            } else {
                _afLib.isDebug = NO;
            }
        }
        
        [_afLib start];
    }
    [RSLogger logDebug:@"Initializing Appsflyer SDK"];
    return self;
}

- (void)dump:(RSMessage *)message {
    if (message != nil) {
        [self processRudderEvent:message];
    }
}

- (void) processRudderEvent: (nonnull RSMessage *) message {
    NSString *type = message.type;
    if ([type isEqualToString:@"identify"]) {
        if ([NSThread isMainThread]) {
            [_afLib setCustomerUserID:message.userId];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.afLib setCustomerUserID:message.userId];
            });
        }
        if ([message.context.traits[@"currencyCode"] isKindOfClass:[NSString class]]) {
            _afLib.currencyCode = [[NSString alloc] initWithFormat:@"%@", message.context.traits[@"currencyCode"]];
        }
        
        NSMutableDictionary *afTraits = [[NSMutableDictionary alloc] init];
        if ([message.context.traits[@"email"] isKindOfClass:[NSString class]]) {
            [afTraits setObject:message.context.traits[@"email"] forKey:@"email"];
        }
        
        if ([message.context.traits[@"firstName"] isKindOfClass:[NSString class]]) {
            [afTraits setObject:message.context.traits[@"firstName"] forKey:@"firstName"];
        }
        
        if ([message.context.traits[@"lastName"] isKindOfClass:[NSString class]]) {
            [afTraits setObject:message.context.traits[@"lastName"] forKey:@"lastName"];
        }
        
        if ([message.context.traits[@"username"] isKindOfClass:[NSString class]]) {
            [afTraits setObject:message.context.traits[@"username"] forKey:@"username"];
        }
        
        [_afLib setAdditionalData:afTraits];
    } else if ([type isEqualToString:@"track"]) {
        NSString *eventName = message.event;
        if (eventName != nil) {
            NSString *afEventName = [eventName lowercaseString];
            NSDictionary *properties = message.properties;
            NSMutableDictionary *afProperties = [[NSMutableDictionary alloc] init];
            if ([eventName isEqualToString:ECommProductsSearched]) {
                afEventName = AFEventSearch;
                NSString *query = properties[@"query"];
                if (query != nil) {
                    [afProperties setValue:query forKey:AFEventParamSearchString];
                }
            } else if ([eventName isEqualToString:ECommProductViewed]) {
                afEventName = AFEventContentView;
                [self addProductProperties:properties params:afProperties];
            } else if ([eventName isEqualToString:ECommProductListViewed]) {
                afEventName = @"af_list_view";
                [self addProductListViewedProperties:properties params:afProperties];
            } else if ([eventName isEqualToString:ECommProductAddedToWishList]) {
                afEventName = AFEventAddToWishlist;
                [self addProductProperties:properties params:afProperties];
            } else if ([eventName isEqualToString:ECommProductAdded]){
                afEventName = AFEventAddToCart;
                [self addProductProperties:properties params:afProperties];
            } else if ([eventName isEqualToString:ECommCheckoutStarted]){
                afEventName = AFEventInitiatedCheckout;
                [self addCheckoutProperties:properties params:afProperties];
            } else if ([eventName isEqualToString:ECommOrderCompleted]) {
                afEventName = AFEventPurchase;
                [self addCheckoutProperties:properties params:afProperties];
            } else if ([eventName isEqualToString:ECommProductRemoved]) {
                afEventName = @"remove_from_cart";
                if (properties != nil) {
                    NSString *productId = properties[@"product_id"];
                    if (productId != nil) {
                        [afProperties setValue:productId forKey:AFEventParamContentId];
                    }
                    NSString *category = properties[@"category"];
                    if (category != nil) {
                        [afProperties setValue:category forKey:AFEventParamContentType];
                    }
                }
            }
            [_afLib logEvent:afEventName withValues:afProperties];
        }
    } else if ([type isEqualToString:@"screen"]) {
        [_afLib logEvent:@"screen" withValues:message.properties];
    }
}

- (void) addCheckoutProperties: (NSDictionary *) properties params: (NSMutableDictionary *) params {
    if (properties != nil && params != nil) {
        NSNumber *total = properties[@"total"];
        if (total != nil) {
            [params setValue:total forKey:AFEventParamPrice];
        }
        
        NSArray<NSDictionary*>* products = properties[@"products"];
        NSMutableArray *productIds = [[NSMutableArray alloc] init];
        NSMutableArray *productCategories = [[NSMutableArray alloc] init];
        NSMutableArray *productQuants = [[NSMutableArray alloc] init];
        if (products != nil) {
            for (NSDictionary* product in products) {
                if (product != nil) {
                    NSString *productId = product[@"product_id"];
                    NSString *productCategory = product[@"category"];
                    NSString *productQuan = product[@"quantity"];
                    if (productId != nil && productCategory != nil && productQuan != nil)  {
                        [productIds addObject:productId];
                        [productCategories addObject:productCategory];
                        [productQuants addObject:productQuan];
                    }
                }
            }
        }
        [params setValue:productIds forKey:AFEventParamContentId];
        [params setValue:productCategories forKey:AFEventParamContentType];
        [params setValue:productQuants forKey:AFEventParamQuantity];
        
        NSString *currency = properties[@"currency"];
        if (currency != nil) {
            [params setValue:currency forKey:AFEventParamCurrency];
        }
        
        NSString *orderId = properties[@"order_id"];
        if (orderId != nil) {
            [params setValue:orderId forKey:AFEventParamReceiptId];
            [params setValue:orderId forKey:@"af_order_id"];
        }
        
        NSString *revenue = properties[@"revenue"];
        if (revenue != nil) {
            [params setValue:revenue forKey:AFEventParamRevenue];
        }
    }
}
 
- (void) addProductListViewedProperties: (NSDictionary *) properties params: (NSMutableDictionary *) params {
    if (properties != nil && params != nil) {
        NSString *category = properties[@"category"];
        if (category != nil) {
            [params setValue:category forKey:AFEventParamContentType];
        }
        
        NSArray<NSDictionary*>* products = properties[@"products"];
        NSMutableArray *productParams = [[NSMutableArray alloc] init];
        if (products != nil) {
            for (NSDictionary* product in products) {
                if (product != nil) {
                    NSString *productId = product[@"product_id"];
                    if (productId != nil) {
                        [productParams addObject:productId];
                    }
                }
            }
        }
        [params setValue:productParams forKey:AFEventParamContentList];
    }
}

- (void) addProductProperties: (NSDictionary *) properties params: (NSMutableDictionary *) params {
    if (properties != nil && params != nil) {
        NSString *price = properties[@"price"];
        if (price != nil) {
            [params setValue:price forKey:AFEventParamPrice];
        }
        
        NSString *productId = properties[@"product_id"];
        if (productId != nil) {
            [params setValue:productId forKey:AFEventParamContentId];
        }
        
        NSString *category = properties[@"category"];
        if (category != nil) {
            [params setValue:category forKey:AFEventParamContentType];
        }
        
        NSString *currency = properties[@"currency"];
        if (currency != nil) {
            [params setValue:currency forKey:AFEventParamCurrency];
        }
        
        NSNumber *quantity = properties[@"quantity"];
        if (quantity != nil) {
            [params setValue:quantity forKey:AFEventParamQuantity];
        }
    }
}

- (void)reset {
    // Appsflyer doesn't support reset functionality
}

@end

