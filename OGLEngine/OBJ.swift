//
//  OBJ.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 21.03.2016.
//  Copyright © 2016 MaciejCh. All rights reserved.
//

import Foundation
import GLKit

struct OBJ {
    
    let indices : [Int]
    let positions : [Float]
    let texels : [Float]!
    let normals : [Float]!
    let tangents : [Float]!
    
    init(indices: [Int], positions: [Float], texels: [Float]! = nil, normals: [Float]! = nil, tangents: [Float]! = nil) {
        self.indices = indices
        self.positions = positions
        self.texels = texels
        self.normals = normals
        self.tangents = tangents
    }
    
    func dataForAttribute(attribute: AnyGPUAttribute) -> [Float]! {
        switch attribute.location {
        case 0: return self.positions
        case 1: return self.texels
        case 2: return self.normals
        case 3: return self.tangents
        default: return nil
        }
    }
}
