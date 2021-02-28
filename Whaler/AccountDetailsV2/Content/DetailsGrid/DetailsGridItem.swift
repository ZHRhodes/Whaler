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
  private let dividerLine = UIView()
  private let bottomLine = UIView()
  private let rightLine = UIView()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configureDividerLine()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configure(with detail: DetailItem) {
    configureImageDescriptionCell(image: detail.image, description: detail.description)
    configureValueCell(value: detail.value)
    if detail.showBottomLine {
      configureBottomLine()
    }
    if detail.showRightLine {
      configureRightLine()
    }
  }
  
  private func configureImageDescriptionCell(image: UIImage, description: String) {
    configureImageView(with: image)
    configureDescriptionLabel(with: description)
  }
  
  private func configureImageView(with image: UIImage) {
    let imageView = UIImageView()
    imageView.image = image.withRenderingMode(.alwaysTemplate)
    imageView.contentMode = .scaleAspectFit
    imageView.tintColor = .borderLineColor
    
    imageView.translatesAutoresizingMaskIntoConstraints = false
    addSubview(imageView)

    imageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 26).isActive = true
    imageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    imageView.heightAnchor.constraint(equalToConstant: 32).isActive = true
    imageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
  }
  
  private func configureDescriptionLabel(with description: String) {
    let label = UILabel()
    label.font = .openSans(weight: .regular, size: 18)
    label.text = description
    label.textColor = .secondaryText
    
    label.translatesAutoresizingMaskIntoConstraints = false
    addSubview(label)

    label.leftAnchor.constraint(equalTo: leftAnchor, constant: 82).isActive = true
    label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    label.heightAnchor.constraint(equalToConstant: 24).isActive = true
  }
  
  private func configureValueCell(value: String) {
    let label = UILabel()
    label.font = .openSans(weight: .regular, size: 18)
    label.text = value
    
    label.translatesAutoresizingMaskIntoConstraints = false
    addSubview(label)

    label.leftAnchor.constraint(equalTo: dividerLine.rightAnchor, constant: 40).isActive = true
    label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    label.heightAnchor.constraint(equalToConstant: 24).isActive = true
  }
  
  private func configureDividerLine() {
    dividerLine.backgroundColor = .borderLineColor
    dividerLine.translatesAutoresizingMaskIntoConstraints = false
    addSubview(dividerLine)
    
    dividerLine.widthAnchor.constraint(equalToConstant: 1).isActive = true
    dividerLine.topAnchor.constraint(equalTo: topAnchor).isActive = true
    dividerLine.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    dividerLine.leftAnchor.constraint(equalTo: leftAnchor, constant: 220).isActive = true
  }
  
  private func configureBottomLine() {
    bottomLine.backgroundColor = .borderLineColor
    bottomLine.translatesAutoresizingMaskIntoConstraints = false
    addSubview(bottomLine)
    
    bottomLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
    bottomLine.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    bottomLine.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    bottomLine.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
  }
  
  private func configureRightLine() {
    rightLine.backgroundColor = .borderLineColor
    rightLine.translatesAutoresizingMaskIntoConstraints = false
    addSubview(rightLine)
    
    rightLine.widthAnchor.constraint(equalToConstant: 1).isActive = true
    rightLine.topAnchor.constraint(equalTo: topAnchor).isActive = true
    rightLine.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    rightLine.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
  }
}
