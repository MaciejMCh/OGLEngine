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
@property (nonatomic, strong) NSMutableArray<EventHandler> *eventHandlers;

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
        NSString *ipAddress = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"IPAddress" ofType:@""]];
        self.webSocketClient = [[SRWebSocket alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"ws://%@:6001", ipAddress]]];
        [self.webSocketClient open];
        self.webSocketClient.delegate = self;
    }
    return self;
}

- (NSMutableArray<EventHandler> *)eventHandlers {
    if (!_eventHandlers) {
        _eventHandlers = [NSMutableArray new];
    }
    return _eventHandlers;
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(NSString *)message {
    if (![message isKindOfClass:[NSString class]]) {
        return;
    }
    
    id eventSubject = nil;
    
    if ([message hasPrefix:@"m"]) {
        eventSubject = [RemoteMouse mouseWithMessage:message];
    } else if ([message hasPrefix:@"d"]) {
        eventSubject = [RemoteKey keyWithMessage:message];
    } else if ([message hasPrefix:@"u"]) {
        eventSubject = [RemoteKey keyWithMessage:message];
    }
    
    if (eventSubject) {
        for (EventHandler handler in self.eventHandlers) {
            handler(eventSubject);
        }
    }
    
}

- (void)addEventHandler:(EventHandler)eventHandler {
    [self.eventHandlers addObject:eventHandler];
}

- (void)removeEventHandler:(EventHandler)eventHandler {
    [self.eventHandlers removeObject:eventHandler];
}

@end
