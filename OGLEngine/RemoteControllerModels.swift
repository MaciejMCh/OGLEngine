//
//  RemoteControllerModels.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 28.03.2016.
//  Copyright © 2016 MaciejCh. All rights reserved.
//

import Foundation

typealias EventHandler = (eventSubject: NSObject!) -> ()

class RemoteMouse : NSObject {
    
    var xPosition: Float = 0
    var yPosition: Float = 0
    
    class func mouseWithMessage(message: String) -> RemoteMouse {
        var components: [String] = message.componentsSeparatedByString(" ")
        assert(components.count == 3, "format is: m f f")
        var mouse: RemoteMouse = RemoteMouse()
        mouse.xPosition = CFloat(components[1])!
        mouse.yPosition = CFloat(components[2])!
        return mouse
    }
}

enum KeyState : Int {
    case Down
    case Up
}


class RemoteKey : NSObject {
    
    var keyState: KeyState!
    var key: Int!
    
    class func keyWithMessage(message: String) -> RemoteKey {
        var components: [String] = message.componentsSeparatedByString(" ")
        assert(components.count == 2, "format is: d/u d")
        var key: RemoteKey = RemoteKey()
        key.keyState = (components[0] == "d") ? .Down : .Up
        key.key = Int(components[1])!
        return key
    }
}