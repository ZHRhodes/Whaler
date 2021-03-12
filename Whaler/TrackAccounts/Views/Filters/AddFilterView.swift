//
//  AddFilterView.swift
//  Whaler
//
//  Created by Zachary Rhodes on 3/11/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation
import UIKit

protocol AddFilterViewDelegate: class {
  func tapped()
}

class AddFilterView: UIView {
  weak var delegate: AddFilterViewDelegate?
  private let label = UILabel()
  
  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
    updateColorsWithTraits()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    configure()
  }
  
  private func configure() {
    layer.borderWidth = 2.0
    layer.cornerRadius = 24.0
    updateColorsWithTraits()
    configureLabel()
    let hover = UIHoverGestureRecognizer(target: self, action: #selector(hovering(_:)))
    addGestureRecognizer(hover)
    let tap = UITapGestureRecognizer(target: self, action: #selector(tapped(_:)))
    addGestureRecognizer(tap)
  }
  
  private func configureLabel() {
    label.text = "+  Filter"
    label.textColor = .primaryText
    label.contentMode = .center
    addAndAttach(view: label, height: 48, attachingEdges: [.left(24),
                                                           .right(-24),
                                                           .top(0),
                                                           .bottom(0)])
  }
  
  private func updateColorsWithTraits() {
    layer.borderColor = UIColor.primaryText.cgColor
  }
  
  @objc
  private func tapped(_ recognizer: UITapGestureRecognizer) {
    delegate?.tapped()
  }
  
  @objc
  private func hovering(_ recognizer: UIHoverGestureRecognizer) {
    #if targetEnvironment(macCatalyst)
    switch recognizer.state {
    case .began, .changed:
      backgroundColor = .primaryBackgroundInverted
      label.textColor = .primaryTextInverted
    case .ended:
      backgroundColor = .primaryBackground
      label.textColor = .primaryText
    default:
      break
    }
    #endif
  }
}
