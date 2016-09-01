//
//  DLOAuthKit.m
//  Niupu_SNS
//
//  Created by famulei on 8/30/16.
//  Copyright © 2016 WE. All rights reserved.
//

#import "DLOAuthKit.h"



@implementation DLOAuthUser



@end



@interface DLOAuthKit ()
@property (nonatomic, strong) NSMutableDictionary *services;
@property (nonatomic, weak) id<DLOAuthProtocol> curentOAuth;
@property (nonatomic, copy) DLOAuthCompletedBlock completedBlock;
@end

@implementation DLOAuthKit


+ (DLOAuthKit *)sharedInstance
{
    static DLOAuthKit *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [DLOAuthKit new];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.services = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)authorizeWithServiceName:(NSString *)serviceName completedBlock:(DLOAuthCompletedBlock)block
{
    id<DLOAuthProtocol> service = self.services[serviceName];
    if (service == nil) {
        service = [NSClassFromString(serviceName) new];
        self.services[serviceName] = service;
        [service registerSDKWithConfigure:nil];
    }
    self.curentOAuth = service;
    self.completedBlock = block;
    [service authorize];
}

- (void)authorizeCompletedWithUser:(DLOAuthUser *)user statusCode:(NSInteger)statusCode errorMessage:(NSString *)errorMessage
{
    if (self.completedBlock) {
        self.completedBlock(user, statusCode, errorMessage);
    }
    self.completedBlock = nil;
    self.curentOAuth = nil;
}

- (BOOL)handleOpenURL:(NSURL *)URL
{
    if (self.curentOAuth) {
        return [self.curentOAuth handleOpenURL:URL];
    }
    return NO;
}



@end


@implementation DLOAuthKit (Services)

+ (NSString *)serviceOfWeibo
{
    return @"DLOAuthWeibo";
}

+ (NSString *)serviceOfWeChat
{
    return @"DLOAuthWeChat";
}

+ (NSString *)serviceOfQQ
{
    return @"DLOAuthQQ";
}

@end





