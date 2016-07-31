//
//  Lighting.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 02.07.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation
import GLKit

class Elucidation {
    var lightVector: GLKVector3 = GLKVector3Make(0, 1, 1)
    var lighColor = (r: 1.0, g: 1.0, b: 1.0, a: 1.0)
    var specularPower: Float = 1
    var specularWidth: Float = 1
    var ambiencePower: Float = 1
    var fresnelMin: Float = 0
    var fresnelMax: Float = 1
    
    init() {
        RemotePropertiesCenter.sharedInstance.listenToPropertyChange("power") { (property) in
            self.specularPower = property as! Float
        }
        RemotePropertiesCenter.sharedInstance.listenToPropertyChange("width") { (property) in
            self.specularWidth = property as! Float
        }
        RemotePropertiesCenter.sharedInstance.listenToPropertyChange("ambient") { (property) in
            self.ambiencePower = property as! Float
        }
        RemotePropertiesCenter.sharedInstance.listenToPropertyChange("fresnelMin") { (property) in
            self.fresnelMin = property as! Float
        }
        RemotePropertiesCenter.sharedInstance.listenToPropertyChange("fresnelMax") { (property) in
            self.fresnelMax = property as! Float
        }
        
    }
}