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
  
  override var isEnabled: Bool {
    didSet {
      if isEnabled {
        backgroundColor = style.fillColor
        layer.borderColor = style.borderColor.cgColor
      } else {
        backgroundColor = style.disabledFillColor
        layer.borderColor = style.disabledBorderColor.cgColor
      }
    }
  }
  
  init(style: ButtonStyle) {
    self.style = style
    super.init(frame: .zero)
    layer.borderWidth = 2
    layer.borderColor = style.borderColor.cgColor
    layer.cornerRadius = 6.0
    
    backgroundColor = style.fillColor
		titleLabel?.font = .openSans(weight: .regular, size: 18)
    setTitleColor(style.textColor, for: .normal)
    setTitleColor(style.disabledTextColor, for: .disabled)
    
    let hover = UIHoverGestureRecognizer(target: self, action: #selector(hovering(_:)))
    addGestureRecognizer(hover)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  @objc
  func hovering(_ recognizer: UIHoverGestureRecognizer) {
    guard isEnabled else { return }
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
  case filled
  
  var borderColor: UIColor {
    switch self {
    case .outline:
      return .brandGreen
    case .filled:
      return .brandGreen
    }
  }
  
  var fillColor: UIColor {
    switch self {
    case .outline:
      return .clear
    case .filled:
      return .brandGreen
    }
  }
  
  var highlightFillColor: UIColor {
    switch self {
    case .outline:
      return .brandGreen
    case .filled:
      return .brandGreenDark
    }
  }
  
  var textColor: UIColor {
    switch self {
    case .outline:
      return .primaryText
    case .filled:
      return .black
    }
  }
  
  var highlightTextColor: UIColor {
    switch self {
    case .outline:
      return .primaryText
    case .filled:
      return .black
    }
  }
  
  var disabledBorderColor: UIColor {
    switch self {
    case .outline:
      return .secondaryText
    case .filled:
      return .secondaryText
    }
  }
  
  var disabledFillColor: UIColor {
    switch self {
    case .outline:
      return .clear
    case .filled:
      return .secondaryText
    }
  }
  
  var disabledTextColor: UIColor {
    switch self {
    case .outline:
      return .secondaryText
    case .filled:
      return .white
    }
  }
}

