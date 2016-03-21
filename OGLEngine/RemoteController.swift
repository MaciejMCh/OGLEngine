//
//  RemoteController.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 21.03.2016.
//  Copyright © 2016 MaciejCh. All rights reserved.
//

import Foundation

typealias EventHandler = (eventSubject: AnyObject) -> ()

protocol listener {
    func listen(object: AnyObject)
}

class RemoteController : NSObject, SRWebSocketDelegate {
    
    static let sharedInstance = RemoteController()
    
    var webSocketClient: SRWebSocket!
    var eventHandlers: [EventHandler] = []
    
    var listeners: [listener] = []
    
    override init() {
        super.init()
        
        var ipAddress: String = "localhost"
        do {
            try ipAddress = String(contentsOfFile: NSBundle.mainBundle().pathForResource("IPAddress", ofType: "")!)
        } catch _ {
        }
        self.webSocketClient = SRWebSocket(URL: NSURL(string: "ws://\(ipAddress):6001")!)
        self.webSocketClient.open()
        self.webSocketClient.delegate = self
    }
    
    func webSocket(webSocket: SRWebSocket!, didReceiveMessage message: AnyObject!) {
        guard let message = message as? String else {
            return
        }
        
        var eventSubject: AnyObject? = nil
        if message.hasPrefix("m") {
            eventSubject = RemoteMouse(message: message)
        }
        else if message.hasPrefix("d") {
            eventSubject = RemoteKey(message: message)
        }
        else if message.hasPrefix("u") {
            eventSubject = RemoteKey(message: message)
        }
        
        if let eventSubject = eventSubject {
            for handler: EventHandler in self.eventHandlers {
                handler(eventSubject: eventSubject)
            }
            
            for listener in self.listeners {
                listener.listen(eventSubject)
            }
        }
    }
    
}