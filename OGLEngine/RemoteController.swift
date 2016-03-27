//
//  RemoteController.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 27.03.2016.
//  Copyright © 2016 MaciejCh. All rights reserved.
//

import Foundation
import SocketRocket

class RemoteController2 : NSObject, SRWebSocketDelegate {
    static let controller = RemoteController2()
    
    var webSocketClient: SRWebSocket!
        
    
    override init() {
        super.init()
        do {
            let ipAddress: String = try NSBundle.mainBundle().pathForResource("IPAddress", ofType: "")!
            self.webSocketClient = SRWebSocket(URL: NSURL(string: "ws://\(ipAddress):6001")!)
            self.webSocketClient.open()
            self.webSocketClient.delegate = self
        } catch _ {
        }
    }
    
//    func eventHandlers() -> EventHandler {
//        if !eventHandlers {
//            self.eventHandlers = NSMutableArray()
//        }
//        return eventHandlers
//    }
    
    func webSocketDidOpen(webSocket: SRWebSocket!) {
        NSLog("open")
    }
    
    func webSocket(webSocket: SRWebSocket!, didCloseWithCode code: Int, reason: String!, wasClean: Bool) {
        NSLog("close")
    }
    
    func webSocket(webSocket: SRWebSocket!, didFailWithError error: NSError!) {
        NSLog("error")
    }
    
    func webSocket(webSocket: SRWebSocket!, didReceiveMessage message: AnyObject!) {
        NSLog("asd")
    }
    
//    func webSocket(webSocket: SRWebSocket, didReceiveMessage message: String) {
//        if !(message is NSString.self) {
//            return
//        }
//        var eventSubject: AnyObject? = nil
//        if message.hasPrefix("m") {
//            eventSubject = RemoteMouse.mouseWithMessage(message)
//        }
//        else if message.hasPrefix("d") {
//            eventSubject = RemoteKey.keyWithMessage(message)
//        }
//        else if message.hasPrefix("u") {
//            eventSubject = RemoteKey.keyWithMessage(message)
//        }
//        
//        if eventSubject! {
//            for handler: EventHandler in self.eventHandlers {
//                handler(eventSubject)
//            }
//        }
//    }
//    
//    func addEventHandler(eventHandler: EventHandler) {
//        self.eventHandlers.append(eventHandler)
//    }
//    
//    func removeEventHandler(eventHandler: EventHandler) {
//        self.eventHandlers.removeObject(eventHandler)
//    }
}