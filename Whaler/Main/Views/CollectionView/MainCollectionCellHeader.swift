//
//  MainCollectionCellHeader.swift
//  Whaler
//
//  Created by Zachary Rhodes on 10/14/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import Foundation
import UIKit

class MainCollectionCellHeader: UICollectionViewCell {
  static let height: CGFloat = 41.0
  private let label = UILabel()
  
  init(text: String, colors: [UIColor]) {
    super.init(frame: .zero)
    configureLabel(with: text)
//    configureGradient(with: colors)
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    configureLabel(with: "")
//    configureGradient(with: [])
  }
  
  private func configureLabel(with text: String) {
		label.textColor = .primaryText
    label.font = .openSans(weight: .semibold, size: 18)
    label.text = text
    label.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(label)
    label.heightAnchor.constraint(equalToConstant: 41).isActive = true
    label.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
    label.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
    label.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
  }
  
  private func configureGradient(with colors: [UIColor]) {
    let gradientView = GradientView(colors: colors)
    contentView.addSubview(gradientView)
    gradientView.translatesAutoresizingMaskIntoConstraints = false
    gradientView.heightAnchor.constraint(equalToConstant: 2).isActive = true
    gradientView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
    gradientView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
    gradientView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 6).isActive = true
  }
}

class GradientView: UIView {
  override class var layerClass: AnyClass {
    return CAGradientLayer.self
  }
  
  init(colors: [UIColor]) {
    super.init(frame: .zero)
    guard let gradientLayer = self.layer as? CAGradientLayer else { return }
    gradientLayer.colors = colors.map { $0.cgColor }
    gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
    gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
