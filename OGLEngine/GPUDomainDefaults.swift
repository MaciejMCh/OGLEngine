//
//  Programs.swift
//  SwiftyProgram
//
//  Created by Maciej Chmielewski on 18.03.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation
import GLKit

enum Attribute {
    case Position
    case Texel
    case Normal
    case Tangent
    
    func name() -> String {
        switch self {
        case .Position: return "position"
        case .Texel: return "texel"
        case .Normal: return "normal"
        case .Tangent: return "tangent"
        }
    }
    
    func location() -> GLuint {
        switch self {
        case .Position: return 0
        case .Texel: return 1
        case .Normal: return 2
        case .Tangent: return 3
        }
    }
    
    func size() -> Int {
        switch self {
        case .Position: return 3
        case .Texel: return 2
        case .Normal: return 3
        case .Tangent: return 3
        }
    }
}
