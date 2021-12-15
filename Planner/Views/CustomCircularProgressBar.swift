//
//  ProgressBar.swift
//  Planner
//
//  Created by 曾柏瑒 on 2021/12/12.
//

import UIKit

class CustomCircularProgressBar: UIView {
    @IBInspectable public var backGroundCircleColor: UIColor = UIColor.lightGray
    @IBInspectable public var startGradientColor: UIColor = UIColor.red
    @IBInspectable public var endGradientColor: UIColor = UIColor.orange
    @IBInspectable public var textColor: UIColor = UIColor.white
    
    private var backgroundLayer: CAShapeLayer!
    private var foregroundLayer: CAShapeLayer!
    private var textLayer: CATextLayer!
    private var gradientLayer: CAGradientLayer!
    
    public var progress: CGFloat = 0 {
        
        didSet {
            didProgressUpdated()
        }
    }
    
    override func draw(_ rect: CGRect) {
        
        guard layer.sublayers == nil else { return }
        
        let width = rect.width
        let height = rect.height
        let lineWidth = 0.1 * min(width, height)
        
        backgroundLayer = createCircularLayer(rect: rect, strokeColor: UIColor.lightGray.cgColor, fillColor: UIColor.clear.cgColor, lineWidth: lineWidth)
        
        foregroundLayer = createCircularLayer(rect: rect, strokeColor: UIColor.red.cgColor, fillColor: UIColor.clear.cgColor, lineWidth: lineWidth)
        
        gradientLayer = CAGradientLayer()
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.5)
        
        gradientLayer.colors = [startGradientColor.cgColor,endGradientColor.cgColor]
        gradientLayer.frame = rect
        gradientLayer.mask = foregroundLayer
        
        textLayer = createTextLayer(rect: rect, textColor: textColor.cgColor)
        
        layer.addSublayer(backgroundLayer)
        layer.addSublayer(gradientLayer)
        layer.addSublayer(textLayer)
        
    }
    
    private func createCircularLayer(rect: CGRect, strokeColor: CGColor,
                                     fillColor: CGColor, lineWidth: CGFloat) -> CAShapeLayer {
        let width = rect.width
        let height = rect.height
        
        let center = CGPoint(x: width / 2, y: height / 2)
        let radius = (min(width, height) - lineWidth) / 2
        
        let startAngle = -CGFloat.pi / 2
        let endAngle = startAngle + 2 * CGFloat.pi
        
        let curcularPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = curcularPath.cgPath
        shapeLayer.strokeColor = strokeColor
        shapeLayer.fillColor = fillColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineCap = .round
        
        return shapeLayer
        
    }
    
    private func createTextLayer(rect: CGRect, textColor: CGColor) -> CATextLayer {
        
        let width = rect.width
        let height = rect.height
        
        let fontSize = min(width, height) / 4
        let offset = min(width, height) * 0.1
        
        let layer = CATextLayer()
        layer.string = "\(Int(progress * 100))"
        layer.backgroundColor = UIColor.clear.cgColor
        layer.foregroundColor = textColor
        layer.fontSize = fontSize
        layer.frame = CGRect(x: 0, y: (height - fontSize - offset) / 2 , width: width, height: fontSize + offset)
        layer.alignmentMode = .center
        
        return layer
    }
    
    private func didProgressUpdated() {
        textLayer?.string = "\(Int(progress * 100))%"
        foregroundLayer?.strokeEnd = progress
    }
}

class CustomHorizontalProgressView: UIView {
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
        
        self.layer.cornerRadius = self.frame.height / 2.0
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.borderWidth = 1.0
        
        let margin: CGFloat = 6.0
        var width = (self.frame.width - margin)  * progress
        let height = self.frame.height - margin
        
        if (width < height) {
            width = height
        }
        
        let pathRef = UIBezierPath(roundedRect: CGRect(x: margin / 2.0, y: margin / 2.0, width: width, height: height), cornerRadius: height / 2.0)
        
        #colorLiteral(red: 0.8979603648, green: 0.8980898261, blue: 0.8979322314, alpha: 1).setFill()
        
        pathRef.fill()
        
        UIColor.clear.setStroke()
        pathRef.stroke()
        
        pathRef.close()
        
        self.setNeedsDisplay()
    }
}
