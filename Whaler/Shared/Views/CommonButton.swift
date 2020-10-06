//
//  Button.swift
//  Whaler
//
//  Created by Zachary Rhodes on 6/29/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import UIKit

      
//rename button to something else -- it's conflicting with the swiftui Button
class CommonButton: UIButton {
  private let style: ButtonStyle
  
  init(style: ButtonStyle) {
    self.style = style
    super.init(frame: .zero)
    layer.borderWidth = 2
    layer.borderColor = style.borderColor.cgColor
    layer.cornerRadius = 4.0
    
    backgroundColor = style.fillColor
    setTitleColor(style.textColor, for: .normal)
    
    let hover = UIHoverGestureRecognizer(target: self, action: #selector(hovering(_:)))
    addGestureRecognizer(hover)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  @objc
  func hovering(_ recognizer: UIHoverGestureRecognizer) {
    switch recognizer.state {
    case .began:
      UIView.animate(withDuration: 0.15) {
        self.backgroundColor = self.style.highlightFillColor
        self.titleLabel?.textColor = self.style.highlightTextColor
      }
    case .ended:
      UIView.animate(withDuration: 0.15) {
        self.backgroundColor = self.style.fillColor
        self.titleLabel?.textColor = self.style.textColor
      }
    default:
      break
    }
  }
}

enum ButtonStyle {
  case outline
  
  var borderColor: UIColor {
    switch self {
    case .outline:
      return .brandGreen
    }
  }
  
  var fillColor: UIColor {
    switch self {
    case .outline:
      return .white
    }
  }
  
  var highlightFillColor: UIColor {
    switch self {
    case .outline:
      return .brandGreen
    }
  }
  
  var textColor: UIColor {
    switch self {
    case .outline:
      return .black
    }
  }
  
  var highlightTextColor: UIColor {
    switch self {
    case .outline:
      return .white
    }
  }
}

