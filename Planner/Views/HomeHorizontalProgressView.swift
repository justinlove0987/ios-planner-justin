//
//  HomeHorizontalProgressView.swift
//  Planner
//
//  Created by 曾柏瑒 on 2021/12/23.
//

import UIKit

class HomeHorizontalProgressView: UIView {
    
    var progress: CGFloat = 0.0 {
        didSet {
            setProgress()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        self.backgroundColor = UIColor.clear
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setProgress()
    }

    
    
    func setProgress() {
        var progress = self.progress
        progress = progress > 1.0 ? progress / 100 : progress
        
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.borderWidth = 1.0
        
        
        // content progress bar
        let margin: CGFloat = 0.0
        
        var width = (self.frame.width - margin)  * progress
        var height = self.frame.height - margin

        let pathRef = UIBezierPath(roundedRect: CGRect(x: 0,
                                                       y: 0,
                                                       width: width,
                                                       height: height), cornerRadius: 0)


        if (width == 0) {
            height = 0
        } else if (width < height) {
            width = height
        }


        #colorLiteral(red: 0.5734010339, green: 0.862889111, blue: 0.8325993419, alpha: 1).setFill()
        pathRef.fill()

        UIColor.clear.setStroke()
        pathRef.stroke()

        pathRef.close()

        self.setNeedsDisplay()
        
    }

}
