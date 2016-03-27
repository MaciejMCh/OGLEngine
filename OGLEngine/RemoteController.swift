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
    
    override init() {
        super.init()
        do {
//            let ipAddress: String = try String(contentsOfFile:NSBundle.mainBundle().pathForResource("IPAddress", ofType: "")!)
            let ipAddress = "localhost"
            self.webSocketClient =  WebSocket("ws://\(ipAddress):6001")
            self.webSocketClient.event.message = {message in
                if let message = message as? String {
                    var eventSubject: NSObject? = nil
                    if message.hasPrefix("m") {
                        eventSubject = RemoteMouse.mouseWithMessage(message)
                    }
                    else if message.hasPrefix("d") {
                        eventSubject = RemoteKey.keyWithMessage(message)
                    }
                    else if message.hasPrefix("u") {
                        eventSubject = RemoteKey.keyWithMessage(message)
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
    
    func addEventHandler(eventHandler: EventHandler) {
        self.eventHandlers.append(eventHandler)
    }
    
    func removeEventHandler(eventHandler: EventHandler) {
//        self.eventHandlers = self.eventHandlers.filter{$0 == eventHandler}
    }
}