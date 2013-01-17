//
//  OrderController.h
//  scomdcom
//
//  Created by Yongnam Park on 12. 9. 28..
//  Copyright (c) 2012년 Yongnam Park. All rights reserved.
//

#import <Foundation/Foundation.h>


#define kTOTAL_AMOUNT_FOR_ORDER_PRODUCTS @"total_amount_for_order_product"
#define kDELIVERY_FEE_FOR_ORDER @"delivery_fee_for_order"
#define kORDER_PRODUCTS @"order_products"
#define kORDERER_INFO @"orderer_info"
#define kRECIPIENT_INFO @"recipient_info"
#define kUSING_POINT @"using_point"
#define kMEMBERS_ID @"members_id"
#define kPRODUCT_IDS @"products_id"
#define kPRODUCT_QTYS @"quantity"
#define kPRODUCT_OPTIONS @"option_name"

#define kORDERER_NAME @"orderer_name"
#define kORDERER_POSTCODE @"orderer_postcode"
#define kORDERER_ADDRESS @"orderer_address"
#define kORDERER_ADDRESS1 @"orderer_address1"
#define kORDERER_CITY @"orderer_city"
#define kORDERER_STATE @"orderer_state"
#define kORDERER_COUNTRY @"orderer_country"
#define kORDERER_MOBILE @"orderer_mobile"
#define kORDERER_CARRIER @"orderer_carrier"
#define kORDERER_EMAIL @"orderer_email"
#define kRECIPIENT_NAME @"recipient_name"
#define kRECIPIENT_POSTCODE @"recipient_postcode"
#define kRECIPIENT_ADDRESS @"recipient_address"
#define kRECIPIENT_MOBILE @"recipient_mobile"
#define kRECIPIENT_MSG @"recipient_msg"

#define kORDERS_ID @"orders_id"


#define kSHIPTONAME @"shiptoname"
#define kSHIPTOPHOMENUM @"shiptophonenum"
#define kSHIPTOSTREET @"shiptostreet"
#define kSHIPTOSTREET2 @"shiptostreet2"
#define kSHIPTOCITY @"shiptocity"
#define kSHIPTOSTATE @"shiptostate"
#define kSHIPTOZIP @"shiptozip"
#define kSHIPTOCOUNTRYCODE @"shiptocountrycode"

#define kSHIPPINGOPTION @"shippingoption"
#define kSHIPPINGOPTION_FEE @"shippingoption_fee"
#define kSHIPPINGOPTION_COUNTRY_CODE @"shippingoption_country_code"
#define kSHIPPINGOPTION_TYPE @"shippingoption_type"
#define kSHIPPINGOPTION_COUNTRY_NAME @"shippingoption_country_name"


@interface OrderController : NSObject

// 주문 번호
+ (NSInteger)orderId;
+ (void)setOrderId:(NSInteger)orderId;
+ (void)clearOrderId;

// 상품금액 합계
+ (NSInteger)totalAmountForOrderProducts;
+ (NSString*)totalAmountForOrderProductsFormatted;
+ (void)setTotalAmountForOrderProducts:(NSInteger)totalAmount;


// 배송비
+ (NSInteger)deliveryFeeForOrder;
+ (NSString*)deliveryFeeForOrderFormatted;
+ (void)setDeliveryFeeForOrder:(NSInteger)deliveryFee;

// 주문상품
+ (NSArray*)orderProducts;
+ (void)setOrderProducts:(NSArray*)orderProducts;

// 사용포인트
+ (NSInteger)usingPoint;
+ (void)setUsingPoint:(NSInteger)point;
+ (void)clearUsingPoint;


// 주문자 정보
+ (NSDictionary*)ordererInfo;
+ (void)setOrdererInfo:(NSDictionary*)orderer;


// 배송지 정보
+ (NSDictionary*)recipientInfo;
+ (void)setRecipientInfo:(NSDictionary*)recipient;


// 배송 국가
+ (NSString*)shippingCountry;
+ (void)setShippingCountry:(NSString*)country;


// 배송 옵션
+ (NSDictionary*)shippingOption;
+ (void)setShippingOption:(NSDictionary*)option;


// 내역 삭제
+ (void)clearOrders;






// 시리얼라이즈
+ (NSDictionary*)serializedData;



@end
