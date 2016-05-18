//
//  RemoteControllerModels.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 28.03.2016.
//  Copyright © 2016 MaciejCh. All rights reserved.
//

import Foundation

typealias EventHandler = (eventSubject: Any!) -> ()

class RemoteMouse : NSObject {
    
    var xPosition: Float = 0
    var yPosition: Float = 0
    
    class func mouseWithMessage(message: String) -> RemoteMouse {
        var components: [String] = message.componentsSeparatedByString(" ")
        assert(components.count == 3, "format is: m f f")
        let mouse: RemoteMouse = RemoteMouse()
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
        let key: RemoteKey = RemoteKey()
        key.keyState = (components[0] == "d") ? .Down : .Up
        key.key = Int(components[1])!
        return key
    }
}


enum PropertyType: String {
    case String
    case Bool
    case Number
}

struct RemoteProperty {
    var name: String
    var type: PropertyType
    var value: AnyObject
    
    static func fromJson(json: [String: AnyObject]) -> RemoteProperty {
        return RemoteProperty(name: json["name"] as! String, type: PropertyType(rawValue: json["type"] as! String)!, value: json["value"]!)
    }
}

struct RemoteProperties {
    let properties: [RemoteProperty]
    
    init(jsonString: String) {
        guard let json = jsonString.parseJSONString as? [String: AnyObject] else {
            self.properties = []
            return
        }
        let propertiesJsonArray = json["properties"] as! Array<AnyObject>
        
        var properties: [RemoteProperty] = []
        for property in propertiesJsonArray {
            if let propertyJson = property as? [String: AnyObject] {
                properties.append(RemoteProperty.fromJson(propertyJson))
            }
        }
        self.properties = properties
    }
}

extension String {
    var parseJSONString: AnyObject? {
        guard let jsonData = self.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) else {
            return nil
        }
        do {
            let message = try NSJSONSerialization.JSONObjectWithData(jsonData, options:.MutableContainers)
            return message
        }
        catch {
            return nil
        }
    }
}