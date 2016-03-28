//
//  CloseShotProgram.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 29.03.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation

class CloseShotProgram: GPUProgram {
    
    static func instantiate() -> GPUProgram {
        return self.init(shaderName: "Shader", interface: DefaultInterfaces.detailInterface())
    }
    
    required init() {
        
    }
    
    func render(renderables: [Renderable]) {
        
    }
}