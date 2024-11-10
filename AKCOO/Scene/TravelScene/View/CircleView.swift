//
//  CircleView.swift
//  AKCOO
//
//  Created by KIM SEOWOO on 11/10/24.
//

import UIKit

class CircleView: UIView {
  
// MARK: - Initializers
override init(frame: CGRect) {
  super.init(frame: frame)
  backgroundColor = .clear
  }
    
required init?(coder: NSCoder) {
  fatalError("init(coder:) has not been implemented")
  }
  
override func draw(_ rect: CGRect) {
  guard let context = UIGraphicsGetCurrentContext() else { return }
  let circlePath = UIBezierPath(ovalIn: bounds)
  UIColor.akColor(.akGreen).setFill()
  circlePath.fill()
    }
}
