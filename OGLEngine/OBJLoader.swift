//
//  OBJLoader.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 24.03.2016.
//  Copyright © 2016 MaciejCh. All rights reserved.
//

import Foundation
import GLKit

class OBJLoader : NSObject {
    
    class func objFromFileNamed(fileName: String) -> OBJ {
        let filePath: String = NSBundle.mainBundle().pathForResource(fileName, ofType: "obj")!
        
        var payload = ""
        do {
            try payload = String(contentsOfFile: filePath)
        } catch _ {
        }
        let lines: [String] = payload.componentsSeparatedByString("\n")
        
        typealias Position = (x: Float, y: Float, z: Float)
        typealias Normal = (x: Float, y: Float, z: Float)
        typealias Texel = (u: Float, v: Float)
        
        var positions: [Position] = []
        var texels: [Texel] = []
        var normals: [Normal] = []
        
        typealias VertexIndices = (p: Int, t: Int, n: Int)
        typealias FaceIndices = (v1: VertexIndices, v2: VertexIndices, v3: VertexIndices)
        
        var facesIndices: [FaceIndices] = []
        
        let stringToVec3 = { (string: String) -> (Float, Float, Float) in
            let c = string.componentsSeparatedByString(" ")
            return (Float(c[1])!, Float(c[2])!, Float(c[3])!)
        }
        let stringToVec2 = { (string: String) -> (Float, Float) in
            let c = string.componentsSeparatedByString(" ")
            return (Float(c[1])!, Float(c[2])!)
        }
        
        let stringToStrideIndices = { (string: String) -> (Int, Int, Int) in
            let c = string.componentsSeparatedByString("/")
            return (Int(c[0])!, Int(c[1])!, Int(c[2])!)
        }
        let stringToFace = { (string: String) -> FaceIndices in
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
            case "f ": facesIndices.append(stringToFace(line))
            default: break
            }
        }
        
        typealias Stride = (p: Position, t: Texel, n: Normal)
        
        let strideToIndices = { (indices: VertexIndices) -> Stride in
            return Stride(p: positions[indices.p - 1], t: texels[indices.t - 1], n: normals[indices.n - 1])
        }
        
        var strides: [Stride] = []
        
        for faceIndices in facesIndices {
            strides.append(strideToIndices(faceIndices.v1))
            strides.append(strideToIndices(faceIndices.v2))
            strides.append(strideToIndices(faceIndices.v3))
        }
        
        var ps: [Position] = []
        var ts: [Texel] = []
        var ns: [Normal] = []
        
        var tbns1: [Float] = []
        var tbns2: [Float] = []
        var tbns3: [Float] = []
        
        let strideIndices = facesIndices.map{return [$0.v1, $0.v2, $0.v3]}.stomp()
        
        let indicesComparator = { (e1: VertexIndices, e2: VertexIndices) -> (Bool) in
            return e1.p == e2.p && e1.t == e2.t && e1.n == e2.n
        }
        let indicesProcessor = { (entity: VertexIndices) -> (Void) in
            let normal = normals[entity.n - 1];
            ps.append(positions[entity.p - 1])
            ts.append(texels[entity.t - 1])
            ns.append(normal)
            
            let tangentMatrix = rotationFromVector(GLKVector3Make(normal.x, normal.y, normal.z), toVector: GLKVector3Make(0, 0, 1))
            
            let col1 = GLKMatrix3GetColumn(tangentMatrix, 0)
            let col2 = GLKMatrix3GetColumn(tangentMatrix, 1)
            let col3 = GLKMatrix3GetColumn(tangentMatrix, 2)
            
            tbns1.appendContentsOf([col1.x, col1.y, col1.z])
            tbns2.appendContentsOf([col2.x, col2.y, col2.z])
            tbns3.appendContentsOf([col3.x, col3.y, col3.z])
            
//            NSLog("%.2f %.2f %.2f", normal.x, normal.y, normal.z)
//            let test = GLKMatrix3MultiplyVector3(tangentMatrix, GLKVector3Make(normal.x, normal.y, normal.z))
//            NSLog("%.2f %.2f %.2f", test.x, test.y, test.z)
//            
//            NSLog("gg")
            
        }
        
        
        let pss = ps.map {return [$0.x, $0.y, $0.z]}.stomp()
        let tss = ts.map {return [$0.u, $0.v]}.stomp()
        let nss = ps.map {return [$0.x, $0.y, $0.z]}.stomp()
        
        
        let indices: [Int] = strideIndices.indexify(indicesComparator, processor: indicesProcessor)
        
        let arrayToArray = { (array: [Int]) -> GLIntArray in
            let glArray = GLIntArray()
            glArray.data = array.map{return UInt($0)}
            glArray.count = UInt(array.count)
            return glArray
        }
        
        let floatArrayToArray = { (array: [Float]) -> GLFloatArray in
            let glArray = GLFloatArray()
            glArray.data = array
            glArray.count = UInt(array.count)
            return glArray
        }
        
        let obj = OBJ()
        obj.indices = arrayToArray(indices)
        obj.positions = floatArrayToArray(pss)
        obj.texels = floatArrayToArray(tss)
        obj.normals = floatArrayToArray(nss)
        
        let pz = ps.map { (position: (x: Float, y: Float, z: Float)) -> [Float] in
            return [position.x, position.y, position.z]
        }.stomp()
        let tz = ts.map { (texel: (u: Float, v: Float)) -> [Float] in
            return [texel.u, texel.v]
        }.stomp()
        let nz = ns.map { (normal: (x: Float, y: Float, z: Float)) -> [Float] in
            return [normal.x, normal.y, normal.z]
        }.stomp()
        
        obj.positions = floatArrayToArray(pz)
        obj.texels = floatArrayToArray(tz)
        obj.normals = floatArrayToArray(nz)
        obj.tbnMatrices1 = floatArrayToArray(tbns1)
        obj.tbnMatrices2 = floatArrayToArray(tbns2)
        obj.tbnMatrices3 = floatArrayToArray(tbns3)
        
        return obj
    }
}

func rotationFromVector(formVector: GLKVector3, toVector: GLKVector3) -> GLKMatrix3 {
    let dot = GLKVector3DotProduct(formVector, toVector);
    switch dot {
    case 1: return GLKMatrix3Identity
    case -1: return GLKMatrix3MakeRotation(Float(M_PI), 1, 0, 0)
    default: break
    }
    
    let axis = GLKVector3Normalize(GLKVector3CrossProduct(formVector, toVector));
    let radians = acosf(dot);
    let mat = GLKMatrix3RotateWithVector3(GLKMatrix3Identity, radians, axis);
    return mat;
}

extension Array where Element : CollectionType {
    func stomp() -> [Element.Generator.Element] {
        var result: [Element.Generator.Element] = []
        for element in self {
            result.appendContentsOf(element)
        }
        return result
    }
}

extension Array {
    func indexify(identificator: ((e1: Element, e2: Element)->(Bool)), processor: (processingEntity: Element) -> (Void)) -> [Int] {
        var indices: [Int] = []
        var stack: [Element] = []
        
        for element in self {
            if let index = stack.firstOccurence(element, identificator: identificator) {
                indices.append(index)
            } else {
                indices.append(stack.count)
                stack.append(element)
                processor(processingEntity: element)
            }
        }
        
        return indices
    }
    
    func filterDuplicates(identificator: ((e1: Element, e2: Element)->(Bool))) -> [Element] {
        var result: [Element] = []
        var i: Int = 0
        for element in self {
            if self.firstOccurence(element, identificator: identificator) == i {
                result.append(element)
            }
            i += 1
        }
        return result
    }

    func firstOccurence(element: Element, identificator: ((e1: Element, e2: Element)->(Bool))) -> Int? {
        var i: Int = 0
        for iteratingElement in self {
            if (identificator(e1: element, e2: iteratingElement)) {
                return i;
            }
            i += 1
        }
        return nil
    }
}