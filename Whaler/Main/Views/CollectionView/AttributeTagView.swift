//
//  AttributeTagView.swift
//  Whaler
//
//  Created by Zachary Rhodes on 9/28/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import Foundation
import UIKit

struct Attribute {
  let text: String
  let foregroundColor: UIColor
  let backgroundColor: UIColor
  let borderColor: UIColor
}

class AttributeTagView: UIView {
  static let height: CGFloat = 30
  
  init(attribute: Attribute, sidePadding: CGFloat = 12, fontSize: CGFloat = 15) {
    super.init(frame: .zero)
    let backgroundView = makeBackgroundView(backgroundColor: attribute.backgroundColor, borderColor: attribute.borderColor)
    let label = makeLabel(with: attribute.text, fontSize: fontSize, textColor: attribute.foregroundColor)
    backgroundView.addSubview(label)
    
    label.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor).isActive = true
    label.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor).isActive = true
    
    backgroundView.widthAnchor.constraint(equalTo: label.widthAnchor, constant: sidePadding*2).isActive = true
    
    widthAnchor.constraint(equalTo: backgroundView.widthAnchor).isActive = true
    heightAnchor.constraint(equalTo: backgroundView.heightAnchor, constant: (2/7) * AccountStateTagView.height).isActive = true
    self.backgroundColor = .clear
  }

  private func makeBackgroundView(backgroundColor: UIColor, borderColor: UIColor) -> UIView {
    let backgroundView = UIView()
    backgroundView.layer.borderWidth = 2.0
    backgroundView.layer.borderColor = borderColor.cgColor
    backgroundView.backgroundColor = backgroundColor
    backgroundView.layer.cornerRadius = 10.0
    backgroundView.heightAnchor.constraint(equalToConstant: (4/7) * AccountStateTagView.height).isActive = true
    backgroundView.translatesAutoresizingMaskIntoConstraints = false
    addSubview(backgroundView)
    backgroundView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
    backgroundView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    return backgroundView
  }

  private func makeLabel(with text: String, fontSize: CGFloat, textColor: UIColor) -> UIView {
    let label = UILabel()
    label.text = text
    label.textColor = textColor
    label.font = UIFont.openSans(weight: .regular, size: fontSize)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
