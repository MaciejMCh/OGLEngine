//
//  RemoteControlledCamera.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 27.03.2016.
//  Copyright © 2016 MaciejCh. All rights reserved.
//

import Foundation
import GLKit

class RemoteControlledCamera : BasicCamera {
    override init() {
        super.init()
        
        self.eventHandler = {(eventSubject: NSObject!) -> () in
            if (eventSubject is RemoteKey) {
                self.toggleKey(eventSubject as! RemoteKey)
            }
            else if (eventSubject is RemoteMouse) {
                self.mouseMoved(eventSubject as! RemoteMouse)
            }
        }
        
        RemoteController.controller.addEventHandler(self.eventHandler)
    }
    
    var toggles: [KeyToggle] = []
    
    var yMouse: Float = 0
    var xMouse: Float = 0
    var xOffset: Float = 0
    var yOffset: Float = 0
    var zOffset: Float = 0
    
    override var orientation: GLKVector3! {
        get {
            return GLKVector3Make(self.yMouse / 100, 0, self.xMouse / 100)
        }
        set {
            
        }
    }
    
    override func cameraPosition() -> GLKVector3 {
        var xFix: Float = 0
        var yFix: Float = 0
        var zFix: Float = 0
        for toggle: KeyToggle in self.toggles {
            switch toggle.key.key {
            case 1:
                // s
                yFix = -Float(CACurrentMediaTime() - toggle.beginInterval)
            case 13:
                // w
                yFix = Float(CACurrentMediaTime() - toggle.beginInterval)
            case 0:
                // a
                xFix = -Float(CACurrentMediaTime() - toggle.beginInterval)
            case 2:
                // d
                xFix = Float(CACurrentMediaTime() - toggle.beginInterval)
            case 49:
                // space
                zFix = Float(CACurrentMediaTime() - toggle.beginInterval)
            case 48:
                // tab
                zFix = -Float(CACurrentMediaTime() - toggle.beginInterval)
            default:
                break
            }
        }
        return GLKVector3Make(self.xOffset + xFix, self.yOffset + yFix, self.zOffset + zFix)
    }
    
    var eventHandler: EventHandler! = nil
    
    func mouseMoved(mouse: RemoteMouse) {
        self.xMouse = mouse.xPosition
        self.yMouse = mouse.yPosition
    }
    
    func toggleKey(key: RemoteKey) {
        if key.keyState == KeyState.Down {
            self.toggles.append(KeyToggle.keyToggleWithKey(key, beginInterval: CACurrentMediaTime()))
        }
        else if key.keyState == KeyState.Up {
            var toggleToDelete: KeyToggle? = nil
            for toggle: KeyToggle in self.toggles {
                if toggle.key.key == key.key {
                    toggleToDelete = toggle
                }
            }
            if let toggleToDelete = toggleToDelete {
                self.toggles.removeAtIndex(self.toggles.indexOf(toggleToDelete)!)
                switch toggleToDelete.key.key {
                case 13:
                    //w
                    self.yOffset += Float(CACurrentMediaTime() - toggleToDelete.beginInterval)
                case 1:
                    //s
                    self.yOffset -= Float(CACurrentMediaTime() - toggleToDelete.beginInterval)
                case 2:
                    //d
                    self.xOffset += Float(CACurrentMediaTime() - toggleToDelete.beginInterval)
                case 0:
                    //a
                    self.xOffset -= Float(CACurrentMediaTime() - toggleToDelete.beginInterval)
                case 49:
                    //space
                    self.zOffset += Float(CACurrentMediaTime() - toggleToDelete.beginInterval)
                case 48:
                    //tab
                    self.zOffset -= Float(CACurrentMediaTime() - toggleToDelete.beginInterval)
                default:
                    break
                }
            }
        }
        
    }
}
class KeyToggle : NSObject {
    var key: RemoteKey!
    var beginInterval: CFTimeInterval!
    
    class func keyToggleWithKey(key: RemoteKey, beginInterval: CFTimeInterval) -> KeyToggle {
        let keyToggle: KeyToggle = KeyToggle()
        keyToggle.key = key
        keyToggle.beginInterval = beginInterval
        return keyToggle
    }
}