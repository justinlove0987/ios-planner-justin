//
//  Layer.swift
//  Planner
//
//  Created by 曾柏瑒 on 2021/12/27.
//

import UIKit

class Layer {
    func configureMainLayer(view: UIView) -> UIView {
        view.layer.shadowRadius = 2
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = .zero
        view.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        view.layer.borderWidth = 1.0
        
        return view
    }
    
}
