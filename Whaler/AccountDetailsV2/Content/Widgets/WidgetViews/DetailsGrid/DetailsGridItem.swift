//
//  DetailsGridItem.swift
//  Whaler
//
//  Created by Zachary Rhodes on 2/27/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation
import UIKit

class DetailsGridItem: UIView {
  private let imageView = UIImageView()
  private let label = UILabel()
  private let rightLine = UIView()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configure(with detail: DetailItem, showRightLine: Bool) {
    configureImageView(with: detail.image)
    configureValue(value: detail.value)
    if showRightLine {
      configureRightLine()
    }
  }
  
  private func configureImageView(with image: UIImage) {
    imageView.image = image.withRenderingMode(.alwaysTemplate)
    imageView.contentMode = .scaleAspectFit
    imageView.tintColor = .borderLineColor
    
    imageView.translatesAutoresizingMaskIntoConstraints = false
    addSubview(imageView)

    imageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 19).isActive = true
    imageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    imageView.heightAnchor.constraint(equalToConstant: 26).isActive = true
    imageView.widthAnchor.constraint(equalToConstant: 26).isActive = true
  }

  private func configureValue(value: String) {
    label.font = .openSans(weight: .regular, size: 18)
    label.text = value
    label.adjustsFontSizeToFitWidth = true
    
    label.translatesAutoresizingMaskIntoConstraints = false
    addSubview(label)

    label.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 16).isActive = true
    label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    label.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
    label.heightAnchor.constraint(equalToConstant: 24).isActive = true
  }
  
  private func configureRightLine() {
    rightLine.backgroundColor = .borderLineColor
    rightLine.translatesAutoresizingMaskIntoConstraints = false
    addSubview(rightLine)
    
		rightLine.widthAnchor.constraint(equalToConstant: UIConstants.boxBorderWidth).isActive = true
    rightLine.topAnchor.constraint(equalTo: topAnchor).isActive = true
    rightLine.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    rightLine.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
  }
}
