//
//  TextFinishedProgressIndicator.swift
//  Whaler
//
//  Created by Zachary Rhodes on 3/5/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation
import UIKit

class TextFinishedProgressIndicator: UIView {
  var text = ""
  var textColor: UIColor?
  var progressView: ProgressView?
  private let label = UILabel()
  
  init(text: String, textColor: UIColor, progressView: ProgressView) {
    super.init(frame: .zero)
    self.text = text
    self.textColor = textColor
    self.progressView = progressView
    configureProgressView()
    configureLabel()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configureProgressView() {
    guard let progressView = progressView else { return }
    progressView.translatesAutoresizingMaskIntoConstraints = false
    addSubview(progressView)
    
    NSLayoutConstraint.activate([
      
      progressView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5),
      progressView.widthAnchor.constraint(equalTo: progressView.heightAnchor),
      progressView.rightAnchor.constraint(equalTo: rightAnchor, constant: -0),
      progressView.centerYAnchor.constraint(equalTo: centerYAnchor),
    ])
  }
  
  private func configureLabel() {
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = text
    label.textColor = textColor
    label.alpha = 0.0
    
    addSubview(label)
    
    NSLayoutConstraint.activate([
      label.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.60),
      label.leftAnchor.constraint(equalTo: leftAnchor),
      label.topAnchor.constraint(equalTo: topAnchor),
      label.bottomAnchor.constraint(equalTo: bottomAnchor),
    ])
  }
  
  func startAnimation() {
    progressView?.alpha = 1.0
    progressView?.isAnimating = true
  }
  
  func finishAnimation() {
    UIView.animate(withDuration: 1.0) {
      self.progressView?.alpha = 0.0
      self.label.alpha = 1.0
    } completion: { (_) in
      self.progressView?.isAnimating = false
      UIView.animateKeyframes(withDuration: 0.5, delay: 0.5) {
        self.label.alpha = 0.0
      }
    }
  }
}
