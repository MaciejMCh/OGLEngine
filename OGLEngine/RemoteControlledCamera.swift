//
//  RemoteControlledCamera.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 21.03.2016.
//  Copyright © 2016 MaciejCh. All rights reserved.
//

import Foundation
import GLKit

//typealias EventHandler = (eventSubject: AnyObject) -> ()

class RemoteControlledCamera : BasicCamera, listener {
    
    var xOffset: Float = 0
    var yOffset: Float = 0
    var zOffset: Float = 0
    
    var xMouse: Float = 0
    var yMouse: Float = 0
    
    var toggles: [KeyToggle] = []
    
    override var orientation: GLKVector3! {
        get {
            return GLKVector3Make(self.yMouse / 100, 0, self.xMouse / 100)
        }
        set {
            
        }
    }
    
    override var position: GLKVector3! {
        get {
            var xFix: Float = 0
            var yFix: Float = 0
            var zFix: Float = 0
            
            for toggle in self.toggles {
                switch toggle.key.key {
                case 1:
                    // s
                    yFix = -(Float(CACurrentMediaTime()) - Float(toggle.beginInterval))
                case 13:
                    // w
                    yFix = Float(CACurrentMediaTime()) - Float(toggle.beginInterval)
                case 0:
                    // a
                    xFix = -(Float(CACurrentMediaTime()) - Float(toggle.beginInterval))
                case 2:
                    // d
                    xFix = Float(CACurrentMediaTime()) - Float(toggle.beginInterval)
                case 49:
                    // space
                    zFix = Float(CACurrentMediaTime()) - Float(toggle.beginInterval)
                case 48:
                    // tab
                    zFix = -(Float(CACurrentMediaTime()) - Float(toggle.beginInterval))
                default:
                    break
                }
            }
            
            return GLKVector3Make(self.xOffset + xFix, self.yOffset + yFix, self.zOffset + zFix);
        }
        set {
            
        }
    }
    
    var eventHandler: EventHandler!
    
    override init() {
        super.init()
        
        self.eventHandler = { (eventSubject: AnyObject) -> Void in
            if eventSubject is RemoteKey {
                self.toggleKey(eventSubject as! RemoteKey)
            } else if eventSubject is RemoteMouse {
                self.mouseMoved(eventSubject as! RemoteMouse)
            }
        }

        
        RemoteController.sharedInstance.eventHandlers.append(self.eventHandler)
        RemoteController.sharedInstance.listeners.append(self)
    }
    
    func listen(object: AnyObject) {
        self.eventHandler(eventSubject: object)
    }
    
    func mouseMoved(mouse: RemoteMouse) {
        self.xMouse = mouse.xPosition
        self.yMouse = mouse.yPosition
    }
    
    func toggleKey(key: RemoteKey) {
        if key.keyState == .Down {
            self.toggles.append(KeyToggle(beginInterval: CACurrentMediaTime(), key: key))
        }
        else if key.keyState == .Up {
            var toggleToDelete: KeyToggle? = nil
            for toggle: KeyToggle in self.toggles {
                if toggle.key.key == key.key {
                    toggleToDelete = toggle
                }
            }
            if (toggleToDelete != nil) {
                self.toggles = self.toggles.filter{$0.key.key != toggleToDelete?.key.key}
//                self.toggles.removeObject(toggleToDelete!)
                switch toggleToDelete!.key.key {
                case 13:
                    //w
                    self.yOffset += Float(CACurrentMediaTime() - toggleToDelete!.beginInterval)
                case 1:
                    //s
                    self.yOffset -= Float(CACurrentMediaTime() - toggleToDelete!.beginInterval)
                case 2:
                    //d
                    self.xOffset += Float(CACurrentMediaTime() - toggleToDelete!.beginInterval)
                case 0:
                    //a
                    self.xOffset -= Float(CACurrentMediaTime() - toggleToDelete!.beginInterval)
                case 49:
                    //space
                    self.zOffset += Float(CACurrentMediaTime() - toggleToDelete!.beginInterval)
                case 48:
                    //tab
                    self.zOffset -= Float(CACurrentMediaTime() - toggleToDelete!.beginInterval)
                default:
                    break
                }
            }
        }
        
    }
    
}


struct KeyToggle {
    let beginInterval: CFTimeInterval
    let key: RemoteKey
}