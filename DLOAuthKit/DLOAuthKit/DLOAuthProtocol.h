//
//  DLOAuthProtocol.h
//  Niupu_SNS
//
//  Created by famulei on 8/30/16.
//  Copyright © 2016 WE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DLOAuthKit.h"



@protocol DLOAuthProtocol <NSObject>

- (BOOL)registerSDKWithConfigure:(NSDictionary *)configure;

- (void)authorize;

- (BOOL)handleOpenURL:(NSURL *)url;


@end
