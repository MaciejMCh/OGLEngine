//
//  GPUFunctions.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 11.07.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation

struct DefaultGPUFunction {
    static func rayBoxTexelWithNormal() -> GPUFunction<GLSLVec2> {
        let scope = GPUScope()
        let normal = GPUVariable<GLSLVec3>(name: "normal")
        
        scope ✍ FixedGPUInstruction(
            code: stringFromLines([
                "lowp float a,b,c;",
                "a = abs(normal.x);",
                "b = abs(normal.y);",
                "c = abs(normal.z);",
                
                "if (a>b) {",
                "   if (a>c) {",//a
                "       if (normal.x > 0.0) {",
                "           return vec2(0.4999, 0.5);",//+x
                "       } else {",
                "           return vec2(0.4999, 0.8);",//-x
                "       }",
                "   } else {",//c
                "       if (normal.z > 0.0) {",
                "           return vec2(0.4999, 0.1);",//+z
                "       } else {",
                "           return vec2(0.5001, 0.1);",//-z
                "       }",
                "   }",
                "} else {",
                "   if (b>c) {",//b
                "       if (normal.y > 0.0) {",
                "           return vec2(0.5001, 0.8);",//+y
                "       } else {",
                "           return vec2(0.5001, 0.5);",//-y
                "       }",
                "   } else {",//c
                "       if (normal.z > 0.0) {",
                "           return vec2(0.4999, 0.1);",//+z
                "       } else {",
                "           return vec2(0.5001, 0.1);",//-z
                "       }",
                "   }",
                "}",
                
                
                
                "return vec2(0.0, 0.0);"
                ]))
        
        return GPUFunction<GLSLVec2>(signature: "rayBoxTexelWithNormal", input: [normal], scope: scope)
    }
}