//
//  NoteEditor.swift
//  Whaler
//
//  Created by Zachary Rhodes on 7/23/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

struct NoteEditorRepresentable: UIViewRepresentable {
  typealias UIViewType = NoteEditor

  func makeUIView(context: Context) -> NoteEditor {
    NoteEditor(frame: .zero)
  }
  
  func updateUIView(_ uiView: NoteEditor, context: Context) {
    
  }
}

class NoteEditor: UIView {
  let toolBar = EditorToolbar(options: EditorToolbarOption.allCases)
  let textView = UITextView()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(textView)
    textView.translatesAutoresizingMaskIntoConstraints = false
    
    let constraints = [
      textView.leftAnchor.constraint(equalTo: leftAnchor),
      textView.rightAnchor.constraint(equalTo: rightAnchor),
      textView.bottomAnchor.constraint(equalTo: bottomAnchor),
      textView.topAnchor.constraint(equalTo: topAnchor),
      textView.heightAnchor.constraint(equalToConstant: 100),
      textView.widthAnchor.constraint(equalToConstant: 100)
    ]
    
    NSLayoutConstraint.activate(constraints)
    toolBar.translatesAutoresizingMaskIntoConstraints = false
    
    addSubview(toolBar)
    let toolbarConstraints = [
      toolBar.leftAnchor.constraint(equalTo: textView.leftAnchor, constant: 20),
      toolBar.topAnchor.constraint(equalTo: textView.topAnchor, constant: 20),
      toolBar.heightAnchor.constraint(equalToConstant: 100),
      toolBar.widthAnchor.constraint(equalToConstant: 800)
    ]
    
    NSLayoutConstraint.activate(toolbarConstraints)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

class EditorToolbar: UIView {
  private let stackView = UIStackView()
  private var options: [EditorToolbarOption] = []
  
  init(options: [EditorToolbarOption]) {
    super.init(frame: .zero)
    self.options = options
    configure()
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
    configureStackView()
  }
  
  private func configureStackView() {
    addSubview(stackView)
    stackView.axis = .horizontal
    
    options.forEach { option in
      let button = makeToolbarButton(for: option)
      stackView.addArrangedSubview(button)
    }
    
    let constraints = [
      stackView.leftAnchor.constraint(equalTo: leftAnchor),
      stackView.rightAnchor.constraint(equalTo: rightAnchor),
      stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
      stackView.topAnchor.constraint(equalTo: topAnchor)
    ]
    
    NSLayoutConstraint.activate(constraints)
  }
  
  func makeToolbarButton(for option: EditorToolbarOption) -> UIButton {
    let button = ToolbarButton(option: option)
    button.setImage(option.icon, for: .normal)
    button.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
    
    let constraints = [
      button.heightAnchor.constraint(equalToConstant: 20),
      button.widthAnchor.constraint(equalToConstant: 30)
    ]
    
    NSLayoutConstraint.activate(constraints)
    
    return button
  }
  
  @objc
  private func buttonTapped(sender: ToolbarButton) {
    Log.debug("Button tapped. \(sender.option)", context: .textEditor)
  }
}

class ToolbarButton: UIButton {
  let option: EditorToolbarOption
  
  init(option: EditorToolbarOption) {
    self.option = option
    super.init(frame: .zero)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

enum EditorToolbarOption: CaseIterable {
  case header1, header2, bold, italic, underline, bulletList, numberList, table, link, image
  
  var icon: UIImage {
    switch self {
    case .header1:
      return UIImage(named: "h1")!
    case .header2:
      return UIImage(named: "h2")!
    case .bold:
      return UIImage(named: "bold")!
    case .italic:
      return UIImage(named: "italic")!
    case .underline:
      return UIImage(named: "underline")!
    case .bulletList:
      return UIImage(named: "bulletList")!
    case .numberList:
      return UIImage(named: "numList")!
    case .table:
      return UIImage(named: "table")!
    case .link:
      return UIImage(named: "link")!
    case .image:
      return UIImage(named: "insertImage")!
    }
  }
}
