//
//  CommonTextField.swift
//  Whaler
//
//  Created by Zachary Rhodes on 8/5/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import UIKit
import SwiftUI

protocol TextFieldDelegate: class {
  func didPressEnter(from textField: UITextField)
}

struct CommonTextFieldRepresentable: UIViewRepresentable {
  typealias UIViewType = CommonTextField
  
  let initialText: String
  let isSecureText: Bool
  weak var textFieldDelegate: TextFieldDelegate?
  @Binding var text: String

  func makeUIView(context: Context) -> CommonTextField {
    let textField = CommonTextField(label: initialText, isSecureText: isSecureText, textFieldDelegate: textFieldDelegate)
    textField.addTarget(context.coordinator,
                        action: #selector(Coordinator.textFieldDidChange(textField:)),
                        for: .editingChanged)
    return textField
  }
  
  func updateUIView(_ uiView: CommonTextField, context: Context) {
    uiView.text = text
  }
  
  func makeCoordinator() -> Coordinator {
    Coordinator($text)
  }
  
  class Coordinator: NSObject, UITextFieldDelegate {
    var text: Binding<String>
    
    init(_ text: Binding<String>) {
      self.text = text
    }
    
    @objc
    func textFieldDidChange(textField: UITextField) {
      if let text = textField.text {
        self.text.wrappedValue = text
      }
    }
  }
}

class CommonTextField: UITextField {
  private let placeholderLabel = UILabel()
  private let fieldNameLabel = UILabel()
  private weak var textFieldDelegate: TextFieldDelegate?

  init(label: String, isSecureText: Bool = false, textFieldDelegate: TextFieldDelegate?) {
    super.init(frame: .zero)
    isSecureTextEntry = isSecureText
    self.textFieldDelegate = textFieldDelegate
    configure(with: label)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configure(with label: String, obscureInput: Bool = false) {
    textColor = .black
    autocorrectionType = .no
    tintColor = .black
    
    configurePlaceholderLabel(with: label)
    configureFieldNameLabel(with: label)
    configureUnderlineView()
    
    addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    addTarget(self, action: #selector(enterPressed), for: .editingDidEndOnExit)
  }
  
  private func configurePlaceholderLabel(with label: String) {
    attributedPlaceholder = NSAttributedString(string: label, attributes: [NSAttributedString.Key.foregroundColor: UIColor.textInactive])
  }
  
  private func configureFieldNameLabel(with label: String) {
    fieldNameLabel.textColor = .textInactive
    fieldNameLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
    fieldNameLabel.text = label
    fieldNameLabel.alpha = 0.0
    fieldNameLabel.translatesAutoresizingMaskIntoConstraints = false
    
    addSubview(fieldNameLabel)
    
    fieldNameLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
    fieldNameLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
    fieldNameLabel.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
    fieldNameLabel.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
  }
  
  private func configureUnderlineView() {
    let view = UIView()
    view.backgroundColor = .textInactive
    view.translatesAutoresizingMaskIntoConstraints = false
    
    addSubview(view)

    view.heightAnchor.constraint(equalToConstant: 1).isActive = true
    view.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    view.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
    view.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
  }
  
  @objc
  private func textFieldDidChange() {
    let hasText = !(text?.isEmpty ?? true)
    let alpha: CGFloat = hasText ? 1.0 : 0.0
    let duration = hasText ? 0.125 : 0.1
    
    UIView.animate(withDuration: duration) {
      self.fieldNameLabel.alpha = alpha
    }
  }
  
  @objc
  private func enterPressed() {
    textFieldDelegate?.didPressEnter(from: self)
  }
}
