//
//  3DIntegrator.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 10.06.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation
import UIKit

struct RemoteVector {
    var x: Float = 0
    var y: Float = 0
    var z: Float = 0
}

class RemoteVectorIntegrator {
    var offset = RemoteVector()
    private var eventHandler: EventHandler!
    private var toggles: [KeyToggle] = []
    
    var currentValue: RemoteVector {
        get {
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
            var vector = RemoteVector()
            vector.x = self.offset.x + xFix
            vector.y = self.offset.y + yFix
            vector.z = self.offset.z + zFix
            return vector
        }
    }
    
    init() {
        self.eventHandler = {[weak self] (eventSubject: Any) in
            guard let wSelf = self where eventSubject is RemoteKey else {
                return
            }
            wSelf.toggleKey(eventSubject as! RemoteKey)
        }
        RemoteController.controller.addEventHandler(self.eventHandler)
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
                    self.offset.y += Float(CACurrentMediaTime() - toggleToDelete.beginInterval)
                case 1:
                    //s
                    self.offset.y -= Float(CACurrentMediaTime() - toggleToDelete.beginInterval)
                case 2:
                    //d
                    self.offset.x += Float(CACurrentMediaTime() - toggleToDelete.beginInterval)
                case 0:
                    //a
                    self.offset.x -= Float(CACurrentMediaTime() - toggleToDelete.beginInterval)
                case 49:
                    //space
                    self.offset.z += Float(CACurrentMediaTime() - toggleToDelete.beginInterval)
                case 48:
                    //tab
                    self.offset.z -= Float(CACurrentMediaTime() - toggleToDelete.beginInterval)
                default:
                    break
                }
            }
        }
        
    }
}