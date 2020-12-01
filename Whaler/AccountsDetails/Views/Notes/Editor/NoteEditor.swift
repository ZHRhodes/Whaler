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
import Aztec

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
  var textView: Aztec.TextView!
  
  override init(frame: CGRect) {
    super.init(frame: frame)

    textView = Aztec.TextView(defaultFont: UIFont.openSans(weight: .regular, size: 25),
                                defaultParagraphStyle: .default,
                                defaultMissingImage: UIImage(named: "bold")!)
    
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
