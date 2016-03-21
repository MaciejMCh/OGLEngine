////
////  RemoteControlledCamera.m
////  OGLEngine
////
////  Created by Maciej Chmielewski on 09.03.2016.
////  Copyright © 2016 MaciejCh. All rights reserved.
////
//
//#import "RemoteControlledCamera.h"
//
//@interface RemoteControlledCamera ()
//
//@property (nonatomic, copy) EventHandler eventHandler;
//@property (nonatomic, strong) NSMutableArray<KeyToggle *> *toggles;
//
//@end
//
//@implementation RemoteControlledCamera
//
//#pragma mark - 
//#pragma mark - Inits
//
//- (instancetype)init {
//    self = [super init];
//    if (self) {
//        [[RemoteController controller] addEventHandler:self.eventHandler];
//    }
//    return self;
//}
//
//#pragma mark - 
//#pragma mark - Accessors
//
//- (GLKVector3)orientation {
//    return GLKVector3Make(self.yMouse / 100,
//                          0,
//                          self.xMouse / 100);
//}
//
//- (GLKVector3)position {
//    float xFix = 0;
//    float yFix = 0;
//    float zFix = 0;
//    
//    for (KeyToggle *toggle in self.toggles) {
//        switch (toggle.key.key) {
//            case 1: // s
//                yFix = -(CACurrentMediaTime() - toggle.beginInterval);
//                break;
//            case 13: // w
//                yFix = CACurrentMediaTime() - toggle.beginInterval;
//                break;
//            case 0: // a
//                xFix = -(CACurrentMediaTime() - toggle.beginInterval);
//                break;
//            case 2: // d
//                xFix = CACurrentMediaTime() - toggle.beginInterval;
//                break;
//            case 49: // space
//                zFix = CACurrentMediaTime() - toggle.beginInterval;
//                break;
//            case 48: // tab
//                zFix = -(CACurrentMediaTime() - toggle.beginInterval);
//                break;
//            default:
//                break;
//        }
//    }
//    
//    return GLKVector3Make(self.xOffset + xFix,
//                          self.yOffset + yFix,
//                          self.zOffset + zFix);
//}
//
//- (NSMutableArray<KeyToggle *> *)toggles {
//    if (!_toggles) {
//        _toggles = [NSMutableArray new];
//    }
//    return _toggles;
//}
//
//- (EventHandler)eventHandler {
//    if (!_eventHandler) {
//        __weak typeof(self) wSelf = self;
//        _eventHandler = ^void(id eventSubject) {
//            if ([eventSubject isKindOfClass:[RemoteKey class]]) {
//                [wSelf toggleKey:eventSubject];
//            } else if ([eventSubject isKindOfClass:[RemoteMouse class]]) {
//                [wSelf mouseMoved:eventSubject];
//            }
//        };
//    }
//    return _eventHandler;
//}
//
//#pragma mark -
//#pragma mark - Internal
//
//- (void)mouseMoved:(RemoteMouse *)mouse {
//    self.xMouse = mouse.xPosition;
//    self.yMouse = mouse.yPosition;
//}
//
//- (void)toggleKey:(RemoteKey *)key {
//    if (key.keyState == KeyStateDown) {
//        [self.toggles addObject:[KeyToggle keyToggleWithKey:key beginInterval:CACurrentMediaTime()]];
//    } else if (key.keyState == KeyStateUp) {
//        KeyToggle *toggleToDelete = nil;
//        for (KeyToggle *toggle in self.toggles) {
//            if (toggle.key.key == key.key) {
//                toggleToDelete = toggle;
//            }
//        }
//        if (toggleToDelete) {
//            [self.toggles removeObject:toggleToDelete];
//            switch (toggleToDelete.key.key) {
//                case 13://w
//                    self.yOffset += CACurrentMediaTime() - toggleToDelete.beginInterval;
//                    break;
//                case 1://s
//                    self.yOffset -= CACurrentMediaTime() - toggleToDelete.beginInterval;
//                    break;
//                case 2://d
//                    self.xOffset += CACurrentMediaTime() - toggleToDelete.beginInterval;
//                    break;
//                case 0://a
//                    self.xOffset -= CACurrentMediaTime() - toggleToDelete.beginInterval;
//                    break;
//                case 49://space
//                    self.zOffset += CACurrentMediaTime() - toggleToDelete.beginInterval;
//                    break;
//                case 48://tab
//                    self.zOffset -= CACurrentMediaTime() - toggleToDelete.beginInterval;
//                    break;
//                default:
//                    break;
//            }
//        }
//    }
//}
//
//@end
//
//
//@implementation KeyToggle
//
//+ (KeyToggle *)keyToggleWithKey:(RemoteKey *)key beginInterval:(CFTimeInterval)beginInterval {
//    KeyToggle *keyToggle = [KeyToggle new];
//    keyToggle.key = key;
//    keyToggle.beginInterval = beginInterval;
//    return keyToggle;
//}
//
//- (BOOL)isEqual:(id)object {
//    if (self == object) {
//        return YES;
//    }
//    if (![object isKindOfClass:[KeyToggle class]]) {
//        return NO;
//    }
//    return self.key.key == ((KeyToggle *)object).key.key;
//}
//
//@end