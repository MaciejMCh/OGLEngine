//
//  VAO.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 21.03.2016.
//  Copyright © 2016 MaciejCh. All rights reserved.
//

import Foundation
import GLKit

struct VBO {
    let attribute: AnyGPUAttribute
    let glName: GLuint
    let data: [Float]
}

class VAO {
    
    var vboAttributes: [AnyGPUAttribute]!
    var obj: OBJ!
    var vbos: [VBO] = []
    
    var vertexCount: UInt = 0
    var vaoGLName: GLuint = 0
    var indicesVboGLName: GLuint = 0
    
    convenience init(obj: OBJ) {
        self.init()
        self.vboAttributes = [GPUAttributes.position, GPUAttributes.texel, GPUAttributes.normal, GPUAttributes.tangent]
        self.obj = obj
        
        self.setup()
    }
    
    private func setup() {
        self.vertexCount = UInt(self.obj.indices.count)
        
        var vaoGLName: GLuint = 0
        glGenVertexArraysOES(1, &vaoGLName)
        glBindVertexArrayOES(vaoGLName)
        self.vaoGLName = vaoGLName
        
        var indicesVboGLName: GLuint = 0
        glGenBuffers(1, &indicesVboGLName)
        glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), indicesVboGLName)
        glBufferData(GLenum(GL_ELEMENT_ARRAY_BUFFER), Int(obj.indices.count) * sizeof(GLuint), obj.indices, GLenum(GL_STATIC_DRAW))
        
        self.vbos = self.vboAttributes.map{return self.generateVbo($0, data: obj.dataForAttribute($0))}
        
        glBindVertexArrayOES(0)
    }
    
    func generateVbo(attribute: AnyGPUAttribute, data: [Float]) -> VBO {
        var vboGLName: GLuint = 0
        glGenBuffers(1, &vboGLName)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), vboGLName)
        glBufferData(GLenum(GL_ARRAY_BUFFER), Int(data.count) * sizeof(GLfloat), data, GLenum(GL_STATIC_DRAW))
        glVertexAttribPointer(attribute.location, GLint(attribute.size), GLenum(GL_FLOAT), GLboolean(GL_FALSE), 0, nil)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), 0)
        return VBO(attribute: attribute, glName: vboGLName, data: data)
    }
}