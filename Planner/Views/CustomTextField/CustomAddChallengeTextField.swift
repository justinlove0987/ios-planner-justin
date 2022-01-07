//
//  CustomAddChallengeTextField.swift
//  Planner
//
//  Created by 曾柏瑒 on 2022/1/4.
//

import UIKit

class CustomAddChallengeTextField: UITextField {
    
    init(placeholder: String) {
        super.init(frame: .zero)
        let spacer = UIView()
        backgroundColor = .white
        attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
        textColor = Color.gray
        
        leftViewMode = .always
        spacer.setDimensions(height: 52, width: 12)
        leftView = spacer
        textAlignment = .center
        
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
