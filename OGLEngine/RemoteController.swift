//
//  RemoteController.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 27.03.2016.
//  Copyright © 2016 MaciejCh. All rights reserved.
//

import Foundation
import SwiftWebSocket

class RemoteController : NSObject {
    static let controller = RemoteController()
    
    var webSocketClient: WebSocket!
    var eventHandlers: [EventHandler] = []
    private var remotePropertiesCache: RemoteProperties!
    
    override init() {
        super.init()
        do {
            let ipAddress: String = try String(contentsOfFile:NSBundle.mainBundle().pathForResource("IPAddress", ofType: "")!)
            self.webSocketClient =  WebSocket("ws://\(ipAddress):6001")
            self.webSocketClient.event.message = {message in
                if let message = message as? String {
                    var eventSubject: Any? = nil
                    if message.hasPrefix("m") {
                        eventSubject = RemoteMouse.mouseWithMessage(message)
                    }
                    else if message.hasPrefix("d") {
                        eventSubject = RemoteKey.keyWithMessage(message)
                    }
                    else if message.hasPrefix("u") {
                        eventSubject = RemoteKey.keyWithMessage(message)
                    }
                    else if message.hasPrefix("p") {
                        let remoteProperty = RemoteProperties(jsonString: message.substringFromIndex(message.startIndex.advancedBy(2)))
                        self.remotePropertiesCache = remoteProperty
                        eventSubject = remoteProperty
                    }
                    
                    if let eventSubject = eventSubject {
                        for handler: EventHandler in self.eventHandlers {
                            handler(eventSubject: eventSubject)
                        }
                    }

                }
            }
        } catch _ {
        }
    }
    
    func integerNamed(name: String) -> Int {
        if remotePropertiesCache == nil {return 0}
        for property in remotePropertiesCache.properties {
            if property.name == name {
                if property.type == .Number {
                    return Int(property.value as! NSNumber)
                }
            }
        }
        return 0
    }
    
    func floatNamed(name: String) -> Float {
        if remotePropertiesCache == nil {return 0}
        for property in remotePropertiesCache.properties {
            if property.name == name {
                if property.type == .Number {
                    return Float(property.value as! NSNumber)
                }
            }
        }
        return 0
    }
    
    func addEventHandler(eventHandler: EventHandler) {
        self.eventHandlers.append(eventHandler)
    }
    
    func removeEventHandler(eventHandler: EventHandler) {
//        self.eventHandlers = self.eventHandlers.filter{$0 == eventHandler}
    }
}
