//
//  LookAtCamera.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 10.06.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation
import GLKit

class LookAtCamera: Camera {
    private var azimutalAngle: Float = 0
    private var polarAngle: Float = 0
    private var position: GLKVector3 = GLKVector3Make(0, -1, 0)
    private var staticProjectionMatrix: GLKMatrix4
    private let integrator = RemoteVectorIntegrator()
    private var eventHandler: EventHandler!
    private var xMouse: Float = 0
    private var yMouse: Float = 0
    
    init() {
        let aspect: Float = fabs(Float(UIScreen.mainScreen().bounds.size.width) / Float(UIScreen.mainScreen().bounds.size.height))
        self.staticProjectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0), aspect, 0.1, 100.0)
        
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
    
    func cameraPosition() -> GLKVector3 {
        let remoteVector = integrator.currentValue
        return GLKVector3Make(remoteVector.x, remoteVector.y, remoteVector.z)
    }
    
    func viewProjectionMatrix() -> GLKMatrix4 {
        let position = self.cameraPosition()
        let lookAtVersor = versorFromAngles(xMouse, polarAngle: yMouse)
        let viewMatrix = GLKMatrix4MakeLookAt(
            position.x,
            position.y,
            position.z,
            
            position.x + lookAtVersor.x,
            position.y + lookAtVersor.y,
            position.z + lookAtVersor.z,
            
            0, 0, 1)
        return viewMatrix * self.staticProjectionMatrix
    }
    
}

func versorFromAngles(azimuthalAngle: Float, polarAngle: Float) -> GLKVector3 {
    let x = sin(polarAngle) * cos(azimuthalAngle)
    let y = sin(polarAngle) * sin(azimuthalAngle)
    let z = cos(polarAngle)
    return GLKVector3Make(x, y, z)
}