//
//  CustomHorizontalProgressView.swift
//  Planner
//
//  Created by 曾柏瑒 on 2021/12/23.
//

import UIKit

class HorizontalProgressView: UIView {

    @IBInspectable public var textColor: UIColor = UIColor.red
    private var textLayer: CATextLayer!
    private var progressLayer: CAShapeLayer!
    
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
    
    private func createTextLayer(rect: CGRect, textColor: CGColor) -> CATextLayer {
        
        let width = rect.width
        let height = rect.height
        
        let fontSize = min(width, height) / 2
        let offset = min(width, height) * 0.1
        
        let layer = CATextLayer()
        layer.string = "\(Int(progress * 100))%"
        layer.backgroundColor = UIColor.clear.cgColor
        layer.foregroundColor = textColor
        layer.fontSize = fontSize
        layer.frame = CGRect(x: 0, y: (height - fontSize - offset) / 2 , width: width, height: fontSize + offset)
        layer.alignmentMode = .center
        
        return layer
    }

    
    
    func setProgress() {
        var progress = self.progress
        progress = progress > 1.0 ? progress / 100 : progress
        
        
        self.layer.cornerRadius = 7
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.borderWidth = 1.0
        
        
        // content progress bar
        let margin: CGFloat = 6.0
        
        var width = (self.frame.width - margin)  * progress
        var height = self.frame.height - margin

        let pathRef = UIBezierPath(roundedRect: CGRect(x: margin / 2.0,
                                                       y: margin / 2.0,
                                                       width: width,
                                                       height: height),
                                   cornerRadius: 7)


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
    
    
    
    
//    func setProgress() {
//        var progress = self.progress
//        progress = progress > 1.0 ? progress / 100 : progress
//
//        self.layer.cornerRadius = 7
//        self.layer.borderColor = UIColor.gray.cgColor
//        self.layer.borderWidth = 1.0
//
//
//        let margin: CGFloat = 6.0
//
//        var width = (self.frame.width - margin)  * progress
//        var height = self.frame.height - margin
//
//        let pathRef = UIBezierPath(roundedRect: CGRect(x: margin / 2.0, y: margin / 2.0, width: width, height: height), cornerRadius: 7)
//
//
//        if (width == 0) {
//            height = 0
//        } else if (width < height) {
//            width = height
//        }
//
//
//        #colorLiteral(red: 0.5734010339, green: 0.862889111, blue: 0.8325993419, alpha: 1).setFill()
//
//        pathRef.fill()
//
//        UIColor.clear.setStroke()
//        pathRef.stroke()
//
//        pathRef.close()
//
//        self.setNeedsDisplay()
//    }
    
//    private func didProgressUpdated() {
//        textLayer?.string = "\(Int(progress * 100))%"
//    }


}
