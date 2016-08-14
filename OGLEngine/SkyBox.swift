//
//  SkyBox.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 05.07.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation

struct SkyBox {
    let positiveXRenderable: SkyBoxRenderable
    let negativeXRenderable: SkyBoxRenderable
    let positiveYRenderable: SkyBoxRenderable
    let negativeYRenderable: SkyBoxRenderable
    let positiveZRenderable: SkyBoxRenderable
    let negativeZRenderable: SkyBoxRenderable
    
    init(name: String) {
        let px = ImageTexture(imageNamed: "\(name).skybox/px.png")
        px.bind()
        let nx = ImageTexture(imageNamed: "\(name).skybox/nx.png")
        nx.bind()
        let py = ImageTexture(imageNamed: "\(name).skybox/py.png")
        py.bind()
        let ny = ImageTexture(imageNamed: "\(name).skybox/ny.png")
        ny.bind()
        let pz = ImageTexture(imageNamed: "\(name).skybox/pz.png")
        pz.bind()
        let nz = ImageTexture(imageNamed: "\(name).skybox/nz.png")
        nz.bind()
        
        positiveXRenderable = SkyBoxRenderable(vao: VAO(obj: OBJLoader.objFromFileNamed("skybox_px")), colorMap: px)
        negativeXRenderable = SkyBoxRenderable(vao: VAO(obj: OBJLoader.objFromFileNamed("skybox_nx")), colorMap: nx)
        positiveYRenderable = SkyBoxRenderable(vao: VAO(obj: OBJLoader.objFromFileNamed("skybox_py")), colorMap: py)
        negativeYRenderable = SkyBoxRenderable(vao: VAO(obj: OBJLoader.objFromFileNamed("skybox_ny")), colorMap: ny)
        positiveZRenderable = SkyBoxRenderable(vao: VAO(obj: OBJLoader.objFromFileNamed("skybox_pz")), colorMap: pz)
        negativeZRenderable = SkyBoxRenderable(vao: VAO(obj: OBJLoader.objFromFileNamed("skybox_nz")), colorMap: nz)
    }
    
    func allRenderables() -> [SkyBoxRenderable] {
        return [positiveXRenderable, negativeXRenderable, positiveYRenderable, negativeYRenderable, positiveZRenderable, negativeZRenderable]
    }
}
