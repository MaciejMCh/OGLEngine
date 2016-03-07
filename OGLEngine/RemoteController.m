//
//  RemoteController.m
//  OGLEngine
//
//  Created by Maciej Chmielewski on 08.03.2016.
//  Copyright © 2016 MaciejCh. All rights reserved.
//

#import "RemoteController.h"
#import <SocketRocket/SRWebSocket.h>

@interface RemoteController () <SRWebSocketDelegate>

@property (nonatomic, strong) SRWebSocket *webSocketClient;

@end

@implementation RemoteController

+ (instancetype)controller {
    static RemoteController *controller = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        controller = [[self alloc] init];
    });
    return controller;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.webSocketClient = [[SRWebSocket alloc] initWithURL:[NSURL URLWithString:@"ws://localhost:6001"]];
        [self.webSocketClient open];
        self.webSocketClient.delegate = self;
    }
    return self;
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    
}

@end
