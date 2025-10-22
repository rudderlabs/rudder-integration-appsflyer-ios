//
//  RudderAdjustIntegration.m
//  FBSnapshotTestCase
//
//  Created by Arnab Pal on 29/10/19.
//

#import "RudderAppsflyerIntegration.h"
#import <AppsFlyerLib/AppsFlyerLib.h>

@implementation RudderAppsflyerIntegration

NSString *const FIRSTPURCHASE = @"first_purchase";
NSString *const CREATIVE = @"creative";
NSArray<NSString*>* TRACK_RESERVED_KEYWORDS;


#pragma mark - Initialization

- (instancetype)initWithConfig:(NSDictionary *)config withAnalytics:(nonnull RSClient *)client  withRudderConfig:(nonnull RSConfig *)rudderConfig {
    self = [super init];
    if (self) {
        isNewScreenEnabled = [[config objectForKey:@"useRichEventName"] boolValue];
        TRACK_RESERVED_KEYWORDS = [[NSArray alloc] initWithObjects:KeyQuery,
                                   KeyPrice,
                                   KeyProductId,
                                   KeyCategory,
                                   KeyCurrency,
                                   KeyProducts,
                                   KeyQuantity,
                                   KeyTotal,
                                   KeyRevenue,
                                   KeyOrderId,
                                   KeyShareMessage,
                                   CREATIVE,
                                   KeyRating, nil];
    }
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
        [[AppsFlyerLib shared] setCustomerUserID:message.userId];
        
        if ([message.context.traits[@"currencyCode"] isKindOfClass:[NSString class]]) {
            [AppsFlyerLib shared].currencyCode = [[NSString alloc] initWithFormat:@"%@", message.context.traits[@"currencyCode"]];
        }
        
        NSMutableDictionary *afTraits = [[NSMutableDictionary alloc] init];
        if ([message.context.traits[@"email"] isKindOfClass:[NSString class]]) {
            NSString *emailValue = (NSString *)message.context.traits[@"email"];
            [[AppsFlyerLib shared] setUserEmails:@[emailValue] withCryptType:EmailCryptTypeNone];
        }
        
        [[AppsFlyerLib shared] setAdditionalData:afTraits];
    } else if ([type isEqualToString:@"track"]) {
        NSString *eventName = message.event;
        if (eventName != nil) {
            NSString *afEventName = [eventName lowercaseString];
            NSDictionary *properties = message.properties;
            NSMutableDictionary *afProperties = [[NSMutableDictionary alloc] init];
            if ([eventName isEqualToString:ECommProductsSearched]) {
                afEventName = AFEventSearch;
                NSString *query = properties[KeyQuery];
                if (query != nil) {
                    [afProperties setValue:query forKey:AFEventParamSearchString];
                }
            } else if ([eventName isEqualToString:ECommProductViewed]) {
                afEventName = AFEventContentView;
                [self addProductProperties:properties params:afProperties];
            } else if ([eventName isEqualToString:ECommProductListViewed]) {
                afEventName = AFEventListView;
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
            } else if ([eventName isEqualToString:FIRSTPURCHASE]) {
                afEventName = FIRSTPURCHASE;
                [self addCheckoutProperties:properties params:afProperties];
            }
            else if ([eventName isEqualToString:ECommPromotionViewed]){
                afEventName = AFEventAdView;
                if(properties[CREATIVE]) {
                    [afProperties setValue:properties[CREATIVE] forKey:@"af_adrev_ad_type"];
                    [afProperties setValue:properties[CREATIVE] forKey:kAppsFlyerAdRevenueAdType];
                }
                if(properties[KeyCurrency]) {
                    [afProperties setValue:properties[KeyCurrency] forKey:AFEventParamCurrency];
                }
            }
            else if ([eventName isEqualToString:ECommPromotionClicked]){
                afEventName = AFEventAdClick;
                if(properties[CREATIVE]) {
                    [afProperties setValue:properties[CREATIVE] forKey:@"af_adrev_ad_type"];
                    [afProperties setValue:properties[CREATIVE] forKey:kAppsFlyerAdRevenueAdType];
                }
                if(properties[KeyCurrency]) {
                    [afProperties setValue:properties[KeyCurrency] forKey:AFEventParamCurrency];
                }
            }
            else if ([eventName isEqualToString:ECommPaymentInfoEntered]) {
                afEventName = AFEventAddPaymentInfo;
            }
            else if ([eventName isEqualToString:ECommProductShared] || [eventName isEqualToString:ECommCartShared]) {
                afEventName = AFEventShare;
                if(properties[KeyShareMessage]) {
                    [afProperties setValue:properties[KeyShareMessage] forKey:AFEventParamDescription];
                }
            }
            else if([eventName isEqualToString:ECommProductReviewed]) {
                afEventName = AFEventRate;
                if(properties[KeyProductId]) {
                    [afProperties setValue:properties[KeyProductId] forKey:AFEventParamContentId];
                }
                if(properties[KeyRating]) {
                    [afProperties setValue:properties[KeyRating] forKey:AFEventParamRatingValue];
                }
            }
            else if ([eventName isEqualToString:ECommProductRemoved]) {
                afEventName = @"remove_from_cart";
                if (properties != nil) {
                    NSString *productId = properties[KeyProductId];
                    if (productId != nil) {
                        [afProperties setValue:productId forKey:AFEventParamContentId];
                    }
                    NSString *category = properties[KeyCategory];
                    if (category != nil) {
                        [afProperties setValue:category forKey:AFEventParamContentType];
                    }
                }
            }
            else {
                afEventName = [afEventName stringByReplacingOccurrencesOfString:@" " withString:@"_"];
            }
            [self attachAllCustomProperties:afProperties properties:properties];
            [[AppsFlyerLib shared] logEvent:afEventName withValues:afProperties];
        }
    } else if ([type isEqualToString:@"screen"]) {
        NSString *screenName;
        NSDictionary *properties = message.properties;
        if (self->isNewScreenEnabled) {
            if ([message.event length]) {
                screenName = [[NSString alloc] initWithFormat:@"Viewed %@ Screen", message.event];
            } else if (properties != NULL && [[properties objectForKey:@"name"] length]) {
                screenName = [[NSString alloc] initWithFormat:@"Viewed %@ Screen", [properties objectForKey:@"name"]];
            }
            else {
                screenName = @"Viewed Screen";
            }
        }
        else {
            screenName = @"screen";
        }
        [[AppsFlyerLib shared] logEvent:screenName withValues:properties];
    }
}

- (void) addCheckoutProperties: (NSDictionary *) properties params: (NSMutableDictionary *) params {
    if (properties != nil && params != nil) {
        NSNumber *total = properties[KeyTotal];
        if (total != nil) {
            [params setValue:total forKey:AFEventParamPrice];
        }
        
        NSArray<NSDictionary*>* products = properties[KeyProducts];
        NSMutableArray *productIds = [[NSMutableArray alloc] init];
        NSMutableArray *productCategories = [[NSMutableArray alloc] init];
        NSMutableArray *productQuants = [[NSMutableArray alloc] init];
        if (products != nil) {
            for (NSDictionary* product in products) {
                if (product != nil) {
                    NSString *productId = product[KeyProductId];
                    NSString *productCategory = product[KeyCategory];
                    NSString *productQuan = product[KeyQuantity];
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
        
        NSString *currency = properties[KeyCurrency];
        if (currency != nil) {
            [params setValue:currency forKey:AFEventParamCurrency];
        }
        
        NSString *orderId = properties[KeyOrderId];
        if (orderId != nil) {
            [params setValue:orderId forKey:AFEventParamReceiptId];
            [params setValue:orderId forKey:AFEventParamOrderId];
        }
        
        NSString *revenue = properties[KeyRevenue];
        if (revenue != nil) {
            [params setValue:revenue forKey:AFEventParamRevenue];
        }
    }
}

- (void) addProductListViewedProperties: (NSDictionary *) properties params: (NSMutableDictionary *) params {
    if (properties != nil && params != nil) {
        NSString *category = properties[KeyCategory];
        if (category != nil) {
            [params setValue:category forKey:AFEventParamContentType];
        }
        
        NSArray<NSDictionary*>* products = properties[KeyProducts];
        NSMutableArray *productParams = [[NSMutableArray alloc] init];
        if (products != nil) {
            for (NSDictionary* product in products) {
                if (product != nil) {
                    NSString *productId = product[KeyProductId];
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
        NSString *price = properties[KeyPrice];
        if (price != nil) {
            [params setValue:price forKey:AFEventParamPrice];
        }
        
        NSString *productId = properties[KeyProductId];
        if (productId != nil) {
            [params setValue:productId forKey:AFEventParamContentId];
        }
        
        NSString *category = properties[KeyCategory];
        if (category != nil) {
            [params setValue:category forKey:AFEventParamContentType];
        }
        
        NSString *currency = properties[KeyCurrency];
        if (currency != nil) {
            [params setValue:currency forKey:AFEventParamCurrency];
        }
        
        NSNumber *quantity = properties[KeyQuantity];
        if (quantity != nil) {
            [params setValue:quantity forKey:AFEventParamQuantity];
        }
    }
}

- (void)reset {
    // Appsflyer doesn't support reset functionality
}

- (void)flush {
    // Appsflyer doesn't support flush functionality
}

- (void)attachAllCustomProperties:(NSMutableDictionary<NSString *, id> *)afEventProps properties:(NSDictionary<NSString *, id> *)properties {
    if (properties == nil || properties.count == 0) {
        return;
    }
    for (NSString *key in properties) {
        id value = properties[key];
        if ([TRACK_RESERVED_KEYWORDS containsObject:key] || key.length == 0) {
            continue;
        }
        afEventProps[key] = value;
    }
}


@end

