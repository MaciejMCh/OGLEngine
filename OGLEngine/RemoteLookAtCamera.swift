//
//  LookAtCamera.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 10.06.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation
import GLKit

class RemoteLookAtCamera: SphericalLookAtCamera {
    private let integrator = RemoteVectorIntegrator()
    private var eventHandler: EventHandler!
    private var xMouse: Float = 0
    private var yMouse: Float = 0
    
    override var eyePosition: GLKVector3 {
        get {
            let position = integrator.currentValue
            return GLKVector3Make(position.x, position.y, position.z)
        }
        set {
            
        }
    }
    
    override var azimutalAngle: Float {
        get {
            return xMouse
        }
        set {
            
        }
    }
    
    override var polarAngle: Float {
        get {
            return yMouse
        }
        set {
            
        }
    }
    
    override init() {
        super.init()
        self.eventHandler = {(eventSubject: Any!) -> () in
            if (eventSubject is RemoteMouse) {
                self.mouseMoved(eventSubject as! RemoteMouse)
            }
        }
        RemoteController.controller.addEventHandler(self.eventHandler)
    }
    
    func mouseMoved(mouse: RemoteMouse) {
        self.xMouse = mouse.xPosition / 100
        self.yMouse = mouse.yPosition / 100
    }
    
}
