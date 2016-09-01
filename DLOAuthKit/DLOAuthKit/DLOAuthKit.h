//
//  DLOAuthKit.h
//  Niupu_SNS
//
//  Created by famulei on 8/30/16.
//  Copyright © 2016 WE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DLOAuthProtocol.h"
#import "DLOAuthKitConfig.h"


@class DLOAuthUser;

typedef void(^DLOAuthCompletedBlock)(DLOAuthUser *user, NSInteger statusCode, NSString *errorMessage);

@interface DLOAuthUser : NSObject

@property ( nonatomic, copy) NSString *userID;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString * avatar;
@property (nonatomic, copy) NSString * gender;
@property (nonatomic, copy) NSString * accessToken;
@property (nonatomic, strong) id originObject;
@end


@interface DLOAuthKit : NSObject

+ (DLOAuthKit *)sharedInstance;

- (void)authorizeWithServiceName:(NSString *)serviceName completedBlock:(DLOAuthCompletedBlock)block;

- (void)authorizeCompletedWithUser:(DLOAuthUser *)user statusCode:(NSInteger)statusCode errorMessage:(NSString *)errorMessage;


- (BOOL)handleOpenURL:(NSURL *)URL;


@end


@interface DLOAuthKit (Services)

+ (NSString *)serviceOfWeibo;
+ (NSString *)serviceOfWeChat;
+ (NSString *)serviceOfQQ;

@end










