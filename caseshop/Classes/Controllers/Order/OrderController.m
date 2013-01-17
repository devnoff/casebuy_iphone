//
//  OrderController.m
//  scomdcom
//
//  Created by Yongnam Park on 12. 9. 28..
//  Copyright (c) 2012년 Yongnam Park. All rights reserved.
//

#import "OrderController.h"
#import "AppDelegate.h"






@implementation OrderController


// 주문 번호
+ (NSInteger)orderId{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    return [def integerForKey:kORDERS_ID];
}

+ (void)setOrderId:(NSInteger)orderId{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setInteger:orderId forKey:kORDERS_ID];
    [def synchronize];
}

+ (void)clearOrderId{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def removeObjectForKey:kORDERS_ID];
    [def synchronize];
}


// 상품금액 합계
+ (NSInteger)totalAmountForOrderProducts{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    return [def integerForKey:kTOTAL_AMOUNT_FOR_ORDER_PRODUCTS];
}

+ (NSString*)totalAmountForOrderProductsFormatted{
    NSInteger amt = [OrderController totalAmountForOrderProducts];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSString *amtStr = [formatter stringFromNumber:[NSNumber numberWithInteger:amt]];
    return amtStr;
}

+ (void)setTotalAmountForOrderProducts:(NSInteger)totalAmount{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setInteger:totalAmount forKey:kTOTAL_AMOUNT_FOR_ORDER_PRODUCTS];
    [def synchronize];
}


// 배송비
+ (NSInteger)deliveryFeeForOrder{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    return [def integerForKey:kDELIVERY_FEE_FOR_ORDER];
}

+ (NSString*)deliveryFeeForOrderFormatted{
    NSInteger amt = [OrderController deliveryFeeForOrder];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSString *amtStr = [formatter stringFromNumber:[NSNumber numberWithInteger:amt]];
    return amtStr;
}

+ (void)setDeliveryFeeForOrder:(NSInteger)deliveryFee{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setInteger:deliveryFee forKey:kDELIVERY_FEE_FOR_ORDER];
    [def synchronize];
}

// 주문내역
+ (NSArray*)orderProducts{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    return [def arrayForKey:kORDER_PRODUCTS];
}

+ (void)setOrderProducts:(NSArray*)orderProducts{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:orderProducts forKey:kORDER_PRODUCTS];
    [def synchronize];
}

//// 주문 상품 수량
//+ (NSArray*)orderQtys{
//    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
//    return [def arrayForKey:kORDER_QTYS];
//}
//
//+ (void)setOrderQtys:(NSArray*)orderQtys{
//    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
//    [def setObject:orderQtys forKey:kORDER_QTYS];
//    [def synchronize];
//}

// 사용포인트
+ (NSInteger)usingPoint{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    return [def integerForKey:kUSING_POINT];
}

+ (void)setUsingPoint:(NSInteger)point{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setInteger:point forKey:kUSING_POINT];
    [def synchronize];
}

+ (void)clearUsingPoint{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def removeObjectForKey:kUSING_POINT];
    [def synchronize];
}


// 주문자 정보
+ (NSDictionary*)ordererInfo{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    return [def dictionaryForKey:kORDERER_INFO];
}

+ (void)setOrdererInfo:(NSDictionary*)orderer{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:orderer forKey:kORDERER_INFO];
    [def synchronize];
}


// 배송지 정보
+ (NSDictionary*)recipientInfo{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    return [def dictionaryForKey:kRECIPIENT_INFO];
}

+ (void)setRecipientInfo:(NSDictionary*)recipient{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:recipient forKey:kRECIPIENT_INFO];
    [def synchronize];
}


+ (NSString*)shippingCountry{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    return [def stringForKey:kSHIPTOCOUNTRYCODE];
}

+ (void)setShippingCountry:(NSString*)country{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:country forKey:kSHIPTOCOUNTRYCODE];
    [def synchronize];
}


+ (NSDictionary*)shippingOption{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    return [def dictionaryForKey:kSHIPPINGOPTION];
}

+ (void)setShippingOption:(NSDictionary*)option{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:option forKey:kSHIPPINGOPTION];
    [def synchronize];
}


// 내역 삭제
+ (void)clearOrders{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def removeObjectForKey:kTOTAL_AMOUNT_FOR_ORDER_PRODUCTS];
    [def removeObjectForKey:kORDER_PRODUCTS];
    [def removeObjectForKey:kORDERER_INFO];
    [def removeObjectForKey:kRECIPIENT_INFO];
    [def removeObjectForKey:kUSING_POINT];
    [def removeObjectForKey:kORDERS_ID];
    [def synchronize];
}


// 최종 주문 정보
+ (NSDictionary*)serializedData{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    
    // 앱 식별 번호
    [data setObject:[[AppDelegate sharedAppdelegate] uuid] forKey:kUUID];
    
    
    // 주문 상품 / 주문 수량
    NSMutableArray *products = [NSMutableArray array];
    NSMutableArray *qtys = [NSMutableArray array];
    NSMutableArray *options = [NSMutableArray array];
    NSArray *orderProducts = [def arrayForKey:kORDER_PRODUCTS];
    
    for (NSDictionary *product in orderProducts){
        [products addObject:[product objectForKey:@"products_id"]];
        [qtys addObject:[product objectForKey:@"qty"]];
        
        NSString *option = [product objectForKey:@"option_name"];
        [options addObject:option?option:@" "];

    }
    
    [data setObject:products forKey:kPRODUCT_IDS];
    [data setObject:qtys forKey:kPRODUCT_QTYS];
    [data setObject:options forKey:kPRODUCT_OPTIONS];
    
    // 주문자 정보
    NSDictionary *orderer = [def dictionaryForKey:kORDERER_INFO];
    [data addEntriesFromDictionary:orderer];
    
    // 배송지 정보
    NSDictionary *recipient = [def dictionaryForKey:kRECIPIENT_INFO];
    [data addEntriesFromDictionary:recipient];
    
    NSLog(@"serialized : %@", data);
    
    return data;
}

@end
