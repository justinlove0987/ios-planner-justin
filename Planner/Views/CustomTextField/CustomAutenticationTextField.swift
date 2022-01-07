//
//  CustomAutenticationTextField.swift
//  Planner
//
//  Created by 曾柏瑒 on 2022/1/4.
//

import UIKit

class CustomAutenticationTextField: UITextField {

    init(placeholder: String) {
        super.init(frame: .zero)
        autocapitalizationType = .none
        autocorrectionType = .no
        returnKeyType = .continue
        attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
        textColor = Color.gray
        
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        leftViewMode = .always
        backgroundColor = .white
        
        layer.shadowRadius = 2
        layer.shadowOpacity = 0.2
        layer.shadowOffset = .zero
        layer.shadowRadius = 7
        layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        layer.borderWidth = 1.0
        layer.cornerRadius = 7
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
