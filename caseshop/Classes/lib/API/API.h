//
//  API.h
//  travelog
//
//  Created by Cho, Young-Un on 11. 8. 29..
//  Copyright 2011 cultstory.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "API_CONST.h"


typedef void(^APISuccessBlock)(NSDictionary*);
typedef void(^APIFailureBlock)(NSError*);

@protocol APIDelegate;

@interface API : NSObject {
@private
    id <APIDelegate> _delegate;
    
    NSURLConnection *_connection;
    
    NSInteger _statusCode;
    NSMutableData *_bodyData;
    NSMutableData *_receivedData;
    
    APISuccessBlock _successBlock;
    APIFailureBlock _failureBlock;
}

@property (nonatomic, assign) id <APIDelegate> delegate;


- (void)appendBody:(NSString *)data fieldName:(NSString *)fieldName;
- (void)appendFile:(NSData *)data fieldName:(NSString *)fieldName fileName:(NSString *)fileName mimeType:(NSString *)mimeType;

- (void)get:(NSString *)uri;
- (void)post:(NSString *)uri;
- (void)delete:(NSString *)uri;

- (void)post:(NSString*)uri successBlock:(APISuccessBlock)successBlock failureBock:(APIFailureBlock)failureBlock;
- (void)get:(NSString*)uri successBlock:(APISuccessBlock)successBlock failureBock:(APIFailureBlock)failureBlock;

- (void)jsonPost:(NSString*)uri jsonString:(NSString*)json successBlock:(APISuccessBlock)successBlock failureBock:(APIFailureBlock)failureBlock;

@end



@protocol APIDelegate <NSObject>

@required
- (void)api:(API *)api didFinish:(id)result;
- (void)api:(API *)api didFailWithError:(NSError *)error;

@end

// http://en.wikipedia.org/wiki/List_of_HTTP_status_codes
typedef enum {
    HTTP_STATUS_CODE_BAD_REQUEST = 400,
    HTTP_STATUS_CODE_NOT_FOUND = 404,
    
    HTTP_STATUS_CODE_SERVICE_UNAVAILABLE = 503,
    HTTP_STATUS_CODE_NERWORK_CONNECTION_TIMEOUT = 599
} HTTP_STATUS_CODE;