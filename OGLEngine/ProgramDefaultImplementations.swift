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
        withUnsafePointer(&modelMatrix, {
            glUniformMatrix4fv(self.implementation.instances.get(.ModelMatrix).location, 1, 0, UnsafePointer($0))
        })
    }
    
    func passNormalMatrix(model: Model) {
        var normalMatrix = model.normalMatrix()
        withUnsafePointer(&normalMatrix, {
            glUniformMatrix3fv(self.implementation.instances.get(.NormalMatrix).location, 1, 0, UnsafePointer($0))
        })
    }
    
    func passViewProjectionMatrix(camera: Camera) {
        var viewProjectionMatrix = camera.viewProjectionMatrix()
        withUnsafePointer(&viewProjectionMatrix, {
            glUniformMatrix4fv(self.implementation.instances.get(.ViewProjectionMatrix).location, 1, 0, UnsafePointer($0))
        })
    }
    
    func passModelViewProjectionMatrix(model: Model, camera: Camera) {
        let modelMatrix = model.geometryModel.modelMatrix()
        let viewProjectionMatrix = camera.viewProjectionMatrix()
        
        var modelViewProjectionMatrix = modelMatrix * viewProjectionMatrix
        
        withUnsafePointer(&modelViewProjectionMatrix, {
            glUniformMatrix4fv(self.implementation.instances.get(.ModelViewProjectionMatrix).location, 1, 0, UnsafePointer($0))
        })
    }
    
    func passLightHalfVector(model: Model, camera: Camera, light: DirectionalLight) {
        let visibleReflectionContext = VisibleReflectionContext(model: model.geometryModel, camera: camera, light: light)
        var halfVector = visibleReflectionContext.halfVector()
        withUnsafePointer(&halfVector, {
            glUniform3fv(self.implementation.instances.get(.LightHalfVector).location, 1, UnsafePointer($0))
        })
    }
    
}

extension GPUProgram where RenderableType: ReflectiveSurface {
    func passReflectionColorMap(reflectiveSurface: ReflectiveSurface) {
        glActiveTexture(GLenum(GL_TEXTURE0));
        glBindTexture(GLenum(GL_TEXTURE_2D), reflectiveSurface.reflectionColorMap.textureGlName)
        glUniform1i(self.implementation.instances.get(.ReflectionColorMap).location, 0);
    }
}

extension GPUProgram {
    func bindUniformWithPass(uniform: Uniform, pass: SceneEntityPass) {
        self.implementation.instances.get(uniform).bindWithSceneEntityPass(pass)
    }
    
    func triggerBondPasses() {
        for instance in self.implementation.instances {
            instance.passToGpu()
        }
    }
    
    func triggerPass(pass: SceneEntityPass, uniform: Uniform) {
        pass.passToGpu(self.implementation.instances.get(uniform).location)
    }
}
