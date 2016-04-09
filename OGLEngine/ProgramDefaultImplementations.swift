//
//  ProgramDefaultImplementations.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 06.04.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation
import GLKit

extension GPUProgram where RenderableType: NormalMapped {
    func bindNormalMap(normalMapped: NormalMapped) {
        glActiveTexture(GLenum(GL_TEXTURE1));
        glBindTexture(GLenum(GL_TEXTURE_2D), normalMapped.normalMap.glName);
        glUniform1i(self.implementation.instances.get(.NormalMap).location, 1);
    }
}

extension GPUProgram where RenderableType: ColorMapped {
    func bindColorMap(colorMapped: ColorMapped) {
        glActiveTexture(GLenum(GL_TEXTURE0));
        glBindTexture(GLenum(GL_TEXTURE_2D), colorMapped.colorMap.glName)
        glUniform1i(self.implementation.instances.get(.ColorMap).location, 0);
    }
}

extension GPUProgram where RenderableType: Mesh {
    
    func draw(mesh: Mesh) {
        glDrawElements(GLenum(GL_TRIANGLES), GLsizei(mesh.vao.vertexCount), GLenum(GL_UNSIGNED_INT), nil);
    }
    
    func bindAttributes(mesh: Mesh) {
        glBindVertexArrayOES(mesh.vao.vaoGLName)
        for attribute in self.interface.attributes {
            glEnableVertexAttribArray(attribute.location())
        }
    }
    
    func unbindAttributes(mesh: Mesh) {
        for attribute in self.interface.attributes {
            glDisableVertexAttribArray(attribute.location())
        }
        glBindVertexArrayOES(0);
    }
    
}

extension GPUProgram where RenderableType: Model {
    
    func passModelMatrix(model: Model) {
        var modelMatrix = model.geometryModel.modelMatrix()
//        withUnsafePointer(&modelMatrix, {
//            glUniformMatrix4fv(self.interface.uniforms.uniformNamed(.ModelMatrix).location, 1, 0, UnsafePointer($0))
//        })
    }
    
    func passNormalMatrix(model: Model) {
        var normalMatrix = GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(model.geometryModel.modelMatrix()), nil);
//        withUnsafePointer(&normalMatrix, {
//            glUniformMatrix3fv(self.interface.uniforms.uniformNamed(.NormalMatrix).location, 1, 0, UnsafePointer($0))
//        })
    }
    
    func passViewMatrix(camera: Camera) {
        var viewMatrix = camera.viewMatrix()
//        withUnsafePointer(&viewMatrix, {
//            glUniformMatrix4fv(self.interface.uniforms.uniformNamed(.ViewMatrix).location, 1, 0, UnsafePointer($0))
//        })
    }
    
    func passProjectionMatrix(camera: Camera) {
        var projectionMatrix = camera.projectionMatrix()
//        withUnsafePointer(&projectionMatrix, {
//            glUniformMatrix4fv(self.interface.uniforms.uniformNamed(.ProjectionMatrix).location, 1, 0, UnsafePointer($0))
//        })
    }
    
}
