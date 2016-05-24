//
//  PipelineProgram.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 23.05.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation
import GLKit

protocol PipelineProgram {
    var interface: GPUInterface {get}
    var implementation: GPUImplementation {get set}
    var pipeline: GPUPipeline {get}
}

class TestPipelineProgram: PipelineProgram {
    var interface = DefaultInterfaces.mediumShotInterface()
    var implementation = GPUImplementation(instances: [])
    var pipeline: GPUPipeline
    
    init() {
        
        let vTexel = TypedGPUVariable<GLKVector2>(name: "vTexel")
        let vNormal = TypedGPUVariable<GLKVector3>(name: "vNormal")
        let vLightDirection = TypedGPUVariable<GLKVector3>(name: "vLightDirection")
        let vLightHalfVector = TypedGPUVariable<GLKVector3>(name: "vLightHalfVector")
        
        let vertexScope = GPUScope()
//        vertexScope ✍ vTexel ⬅ uTexel
        
        vertexScope
//        let vertexShader = VertexShader(
//            name: "Medium Shot",
//            attributes: self.interface.attributes,
//            uniforms: [],
//            varyings: [],
//            function: <#T##TypedGPUFunction<Void>#>)
//        pipeline = GPUPipeline(vertexShader: <#T##VertexShader#>, fragmentShader: <#T##FragmentShader#>)
    }
}