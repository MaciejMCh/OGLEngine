//
//  OBJLoader.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 24.03.2016.
//  Copyright © 2016 MaciejCh. All rights reserved.
//

import Foundation

class OBJLoader : NSObject {
    
    class func objFromFileNamed(fileName: String) -> OBJ {
        let filePath: String = NSBundle.mainBundle().pathForResource(fileName, ofType: "obj")!
        
        var payload = ""
        do {
            try payload = String(contentsOfFile: filePath)
        } catch _ {
        }
        let lines: [String] = payload.componentsSeparatedByString("\n")
        
        var positions: [(x: Float, y: Float, z: Float)] = []
        var texels: [(u: Float, v: Float)] = []
        var normals: [(x: Float, y: Float, z: Float)] = []
        typealias Vertex = (p: Int, t: Int, n: Int)
        typealias Face = (v1: Vertex, v2: Vertex, v3: Vertex)
        var faces: [Face] = []
        
        let stringToVec3 = { (string: String) -> (Float, Float, Float) in
            let c = string.componentsSeparatedByString(" ")
            return (Float(c[1])!, Float(c[2])!, Float(c[3])!)
        }
        let stringToVec2 = { (string: String) -> (Float, Float) in
            let c = string.componentsSeparatedByString(" ")
            return (Float(c[1])!, Float(c[2])!)
        }
        
        let stringToStrideIndices = { (string: String) -> Vertex in
            let c = string.componentsSeparatedByString("/")
            return (Int(c[0])!, Int(c[1])!, Int(c[2])!)
        }
        let stringToFace = { (string: String) -> Face in
            let c = string.componentsSeparatedByString(" ")
            return (stringToStrideIndices(c[1]), stringToStrideIndices(c[2]), stringToStrideIndices(c[3]))
        }
        
        
        for line in lines {
            if line.startIndex.distanceTo(line.endIndex) < 2 {
                continue
            }
            switch line.substringToIndex(line.startIndex.advancedBy(2)) {
            case "v ": positions.append(stringToVec3(line))
            case "vt": texels.append(stringToVec2(line))
            case "vn": normals.append(stringToVec3(line))
            case "f ": faces.append(stringToFace(line))
            default: break
            }
        }
        
        
        
        
        
        return OBJ()
    }
}