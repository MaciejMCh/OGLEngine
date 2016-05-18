//
//  RemoteProperties.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 17.05.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation

typealias PropertyChangeHandler = (property: AnyObject) -> ()

class RemotePropertiesCenter {
    static let sharedInstance = RemotePropertiesCenter()
    
    var handlersByPropertyName: [String: [PropertyChangeHandler]] = [:]
    
    init() {
        RemoteController.controller.addEventHandler { (eventSubject) in
            guard let remoteProperties = eventSubject as? RemoteProperties else {return}
            for remoteProperty in remoteProperties.properties {
                if let handlers = self.handlersByPropertyName[remoteProperty.name] {
                    for handler in handlers {
                        handler(property: remoteProperty.value)
                    }
                }
            }
        }
    }
    
    func listenToPropertyChange(name: String, handler: PropertyChangeHandler) {
        if var existingArray = handlersByPropertyName[name] {
            existingArray.append(handler)
        } else {
            handlersByPropertyName[name] = [handler]
        }
    }
}