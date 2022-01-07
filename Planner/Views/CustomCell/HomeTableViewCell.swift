//
//  HomeTableViewCell.swift
//  Planner
//
//  Created by 曾柏瑒 on 2021/12/23.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    
    static let identifier = "HomeTableViewCell"

    
    let backView: HomeHorizontalProgressView = {
        let view = HomeHorizontalProgressView()
        view.backgroundColor = #colorLiteral(red: 0.9786321521, green: 0.6168946624, blue: 0.5518803, alpha: 1)
        view.contentMode = .scaleToFill
        view.layer.shadowRadius = 2
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = .zero
        
        return view
    }()
    
    let rightImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.compact.right")
        imageView.tintColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        imageView.contentMode = .scaleAspectFit
        imageView.sizeToFit()
        return imageView
    }()
    
    public let challengetName: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor  = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 20)

        return label
    }()
    
    private let triangleView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return view
    }()
    

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = Color.mainBackground
        
        contentView.addSubview(backView)
        contentView.addSubview(challengetName)
        contentView.addSubview(rightImageView)
        backView.addSubview(triangleView)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backView.anchor(top: self.topAnchor,
                        left: self.leftAnchor,
                        bottom: self.bottomAnchor,
                        right: self.rightAnchor,
                        paddingTop: 10,
                        paddingLeft: 10,
                        paddingBottom: 10,
                        paddingRight: 10)
        
        
        challengetName.centerY(inView: backView)
        challengetName.anchor(left: backView.leftAnchor, paddingLeft: 17)
        challengetName.setDimensions(height: 52, width: 152)
        
        rightImageView.centerY(inView: backView)
        rightImageView.anchor(right: backView.rightAnchor, paddingRight: 17)
        
        
        let point1 = CGPoint(x: backView.frame.minX, y: backView.frame.minY)
        let point2 = CGPoint(x: backView.frame.minX, y: backView.frame.maxY)
        let point3 = CGPoint(x: backView.frame.maxX, y: backView.frame.minY)
    
        let trianglePath = UIBezierPath()
        trianglePath.move(to: point1)
        trianglePath.addLine(to: point2)
        trianglePath.addLine(to: point3)
        trianglePath.close()
        
//        let path = CGMutablePath()
//        path.move(to: point1)
//        path.addArc(tangent1End: point2, tangent2End: point3, radius: 7)
//        path.addLine(to: point3)
//        path.closeSubpath()
        
        let triangleLayer = CAShapeLayer()
        triangleLayer.path = trianglePath.cgPath
        triangleView.layer.mask = triangleLayer
        
        triangleView.anchor(top: contentView.topAnchor,
                            left: contentView.leftAnchor,
                            bottom: contentView.bottomAnchor,
                            right: contentView.rightAnchor,
                            paddingTop: 0,
                            paddingLeft: 0,
                            paddingBottom: 0,
                            paddingRight: 0

        )
        
        
    }

}
