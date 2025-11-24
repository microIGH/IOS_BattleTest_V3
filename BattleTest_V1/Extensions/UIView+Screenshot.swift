//
//  UIView+Screenshot.swift
//  BattleTest_V1
//
//  Created by ISRAEL GARCIA on 23/11/25.
//

import UIKit

extension UIView {
    
    /// Captura un screenshot de la vista actual
    /// ORIGEN: Vista renderizada → PROCESO: Render en contexto gráfico → DESTINO: UIImage
    func captureScreenshot() -> UIImage? {
        // Crear renderer con el tamaño de la vista
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        
        // Renderizar la vista en una imagen
        let screenshot = renderer.image { context in
            layer.render(in: context.cgContext)
        }
        
        return screenshot
    }
}
