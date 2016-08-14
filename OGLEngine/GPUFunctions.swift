//
//  GPUFunctions.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 11.07.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation

struct DefaultGPUFunction {
    
    static func cubeMapColorWithTexel() -> GPUFunction<GLSLColor> {
        let scope = GPUScope()
        let texel = Variable<GLSLVec2>(name: "texel")
        let transformationIndex = Variable<GLSLInt>(name: "transformationIndex")
        let projecteeIndex = Variable<GLSLInt>(name: "projecteeIndex")
        
        scope ↳ transformationIndex
        scope ↳ projecteeIndex
        
        scope ✍ FixedGPUInstruction(code: stringFromLines([
            "if (texel.y > 1.0) {",
            "   if(texel.x < 0.0) {",
            "       if(texel.y - 1.0 > -texel.x) {",
            "           projecteeIndex = 2;",
            "       } else {",
            "           projecteeIndex = 3;",
            "       }",
            "   } else if (texel.x < 1.0) {",
            "       projecteeIndex = 2;",
            "   } else {",
            "       if (texel.y > texel.x) {",
            "           projecteeIndex = 2;",
            "       } else {",
            "           projecteeIndex = 4;",
            "       }",
            "   }",
            "} else if (texel.y > 0.0) {",
            "   if (texel.x < 0.0) {",
            "       projecteeIndex = 3;",
            "   } else {",
            "       if (texel.x > 1.0) {",
            "           projecteeIndex = 4;",
            "       } else {",
            "           projecteeIndex = 0;",
            "       }",
            "   }",
            "} else {",
            "   if (texel.x < 0.0) {",
            "       if (texel.x < texel.y) {",
            "           projecteeIndex = 3;",
            "       } else {",
            "           projecteeIndex = 1;",
            "       }",
            "   } else {",
            "       if (texel.x < 1.0) {",
            "           projecteeIndex = 1;",
            "       } else {",
            "           if (texel.x - 1.0 > -texel.y) {",
            "               projecteeIndex = 4;",
            "           } else {",
            "               projecteeIndex = 1;",
            "           }",
            "       }",
            "   }",
            "}",
            
            "if (projecteeIndex == 0) {",
            "   return texture2D(uCubeTextureCurrent, texel);",
            "}",
            
            "if (projecteeIndex < 3) {",
            "   lowp float errY = -texel.y;",
            "   lowp float splasher = (texel.x - 0.5) / (texel.y - 0.5);",
            "   lowp float tX = errY * splasher;",
            "   texel = vec2(texel.x + tX, errY);",
            "} else {",
            "   lowp float errX = -texel.x;",
            "   lowp float splasher = (texel.y - 0.5) / (texel.x - 0.5);",
            "   lowp float tY = errX * splasher;",
            "   texel = vec2(errX, texel.y + tY);",
            "}"
            ]), usedVariables: [GPUUniforms.CubeTextures.Current, GPUUniforms.CubeTextures.Left, projecteeIndex])
        
        scope ✍ transformationIndex ⬅ (GPUUniforms.sideTexturesTransformations .| (projecteeIndex - Primitive(value: 1)))
        
        scope ✍ FixedGPUInstruction(code: stringFromLines([
            "if (transformationIndex == 1) {",
            "   texel.x = -texel.x;",
            "} else if (transformationIndex == 2) {",
            "   texel.y = -texel.y;",
            "} else if (transformationIndex == 3) {",
            "   texel = -texel;",
            "} else if (transformationIndex == 4) {",
            "   texel = vec2(texel.y ,texel.x);",
            "} else if (transformationIndex == 5) {",
            "   texel = vec2(-texel.y ,texel.x);",
            "} else if (transformationIndex == 6) {",
            "   texel = vec2(-texel.y ,-texel.x);",
            "} else if (transformationIndex == 7) {",
            "   texel = vec2(texel.y ,-texel.x);",
            "}"
            ]), usedVariables: [texel, transformationIndex])
        
        let samplers = [GPUUniforms.CubeTextures.Current,
                        GPUUniforms.CubeTextures.Bottom,
                        GPUUniforms.CubeTextures.Top,
                        GPUUniforms.CubeTextures.Left,
                        GPUUniforms.CubeTextures.Right]
        for i in 0...samplers.count - 1 {
            scope ✍ ConditionInstruction(bool: projecteeIndex .== Primitive(value: i), successInstructions: [
                ReturnInstruction<GLSLColor>(evaluation: samplers[i] ☒ texel)])
        }
        
        scope ✍ FixedGPUInstruction(code: "return vec4(1.0, 0.0, 0.0, 1.0);", usedVariables: [])
        
        
        return GPUFunction<GLSLColor>(signature: "cubeMapColorWithTexel", arguments: [texel], scope: scope)
    }
    
    static func rayBoxTexelWithNormal() -> GPUFunction<GLSLVec2> {
        let scope = GPUScope()
        let normal = Variable<GLSLVec3>(name: "normal")
        
        scope ✍ FixedGPUInstruction(
            code: stringFromLines([
                "lowp float a,b,c;",
                "a = abs(normal.x);",
                "b = abs(normal.y);",
                "c = abs(normal.z);",
                "int wallIndex = 0;",
                
                "if (a>b) {",
                "   if (a>c) {",//a
                "       if (normal.x > 0.0) {",//+x
                "           wallIndex = 2;",
                "       } else {",//-x
                "           wallIndex = 0;",
                "       }",
                "   } else {",//c
                "       if (normal.z > 0.0) {",//+z
                "           wallIndex = 4;",
                "       } else {",//-z
                "           wallIndex = 5;",
                "       }",
                "   }",
                "} else {",
                "   if (b>c) {",//b
                "       if (normal.y > 0.0) {",//+y
                "           wallIndex = 1;",
                "       } else {",//-y
                "           wallIndex = 3;",
                "       }",
                "   } else {",//c
                "       if (normal.z > 0.0) {",//+z
                "           wallIndex = 4;",
                "       } else {",//-z
                "           wallIndex = 5;",
                "       }",
                "   }",
                "}",
                
                "lowp vec2 result[6];",
                "result[0] = vec2(0.4999, 0.8);",
                "result[1] = vec2(0.5001, 0.8);",
                "result[2] = vec2(0.4999, 0.5);",
                "result[3] = vec2(0.5001, 0.5);",
                "result[4] = vec2(0.4999, 0.1);",
                "result[5] = vec2(0.5001, 0.1);",
                
                "lowp vec3 planeNormal[6];",
                "planeNormal[0] = vec3(-1.0, 0.0, 0.0);",
                "planeNormal[1] = vec3(0.0, 1.0, 0.0);",
                "planeNormal[2] = vec3(1.0, 0.0, 0.0);",
                "planeNormal[3] = vec3(0.0, -1.0, 0.0);",
                "planeNormal[4] = vec3(0.0, 0.0, 1.0);",
                "planeNormal[5] = vec3(0.0, 0.0, -1.0);",
                
                "lowp float dp = dot(normal, planeNormal[wallIndex]);",
                "lowp float t = 1.0 / dp;",
                "lowp vec3 intersection = normal * t;",
                "intersection = (intersection + vec3(1.0, 1.0, 1.0)) * 0.5;",
                
                "if (wallIndex == 0) {",
                "   return vec2(intersection.y * 0.5, intersection.z / 3.0 + 2.0 / 3.0);",
                "} else {",
                "   if (wallIndex == 1) {",
                "       return vec2(intersection.x * 0.5 + 0.5, intersection.z / 3.0 + 2.0 / 3.0);",
                "   } else {",
                "       if (wallIndex == 2) {",
                "           return vec2((1.0 - intersection.y) * 0.5, intersection.z / 3.0 + 1.0 / 3.0);",
                "       } else {",
                "           if (wallIndex == 3) {",
                "               return vec2((1.0 - intersection.x) * 0.5 + 0.5, intersection.z / 3.0 + 1.0 / 3.0);",
                "           } else {",
                "               if (wallIndex == 4) {",
                "                   return vec2(intersection.x * 0.5, (1.0 - intersection.y) / 3.0);",
                "               } else {",
                "                   return vec2(intersection.x * 0.5 + 0.5, intersection.y / 3.0);",
                "               }",
                "           }",
                "       }",
                "   }",
                "}",
                "return vec2(0.0, 0.0);"
                ]), usedVariables: [])
        
        return GPUFunction<GLSLVec2>(signature: "rayBoxTexelWithNormal", arguments: [normal], scope: scope)
    }
}