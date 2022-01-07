//
//  CustomShowChallengeButton.swift
//  Planner
//
//  Created by 曾柏瑒 on 2022/1/4.
//

import UIKit

class CustomShowChallengeButton: UIButton {

    init(imageSystemName: String) {
        super.init(frame: .zero)
        backgroundColor = #colorLiteral(red: 0.5734010339, green: 0.862889111, blue: 0.8325993419, alpha: 1)
        layer.cornerRadius = 7

        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 18, weight: .semibold, scale: .default)
        let image = UIImage(systemName: imageSystemName,
                            withConfiguration: symbolConfig)

        setImage(image, for: .normal)
        tintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)

        layer.shadowRadius = 3
        layer.shadowOpacity = 0.4
        layer.shadowOffset = .zero
        layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        layer.borderWidth = 1.0

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
