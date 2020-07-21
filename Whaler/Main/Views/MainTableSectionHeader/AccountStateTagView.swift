//
//  AccountStateTagView.swift
//  Whaler
//
//  Created by Zachary Rhodes on 7/7/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import UIKit
import SwiftUI

class AccountStateTagView: UIView {
  static let height: CGFloat = 70
  
  init(state: WorkState) {
    super.init(frame: .zero)
    let backgroundView = makeBackgroundView(with: state.color)
    let label = makeLabel(with: state.rawValue)
    backgroundView.addSubview(label)
    
    label.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor).isActive = true
    label.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor).isActive = true
    
    backgroundView.widthAnchor.constraint(equalTo: label.widthAnchor, constant: 48).isActive = true
    
    heightAnchor.constraint(equalTo: backgroundView.heightAnchor, constant: (2/7) * AccountStateTagView.height).isActive = true
    backgroundColor = .white
  }

  private func makeBackgroundView(with color: UIColor) -> UIView {
    let backgroundView = UIView()
    backgroundView.backgroundColor = color
    backgroundView.layer.cornerRadius = 4.0
    backgroundView.heightAnchor.constraint(equalToConstant: (5/7) * AccountStateTagView.height).isActive = true
    backgroundView.translatesAutoresizingMaskIntoConstraints = false
    addSubview(backgroundView)
    backgroundView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
    backgroundView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    return backgroundView
  }

  private func makeLabel(with text: String) -> UIView {
    let label = UILabel()
    label.text = text
    label.textColor = .white
    label.font = UIFont.boldSystemFont(ofSize: 22)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

struct AccountStateTagWrapperView: UIViewRepresentable {
  typealias UIViewType = AccountStateTagView
  let state: WorkState
  
  func makeUIView(context: Context) -> AccountStateTagView {
    return AccountStateTagView(state: state)
  }
  
  func updateUIView(_ uiView: AccountStateTagView, context: Context) {}
}
