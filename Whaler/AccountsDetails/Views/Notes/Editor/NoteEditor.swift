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
  private let container = UIView()
  lazy var toolBar = EditorToolbar(options: EditorToolbarOption.allCases, delegate: self)
  var textView: Aztec.TextView!
  var conn: WebSocketConn!
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    configureView()
    configureContainer()
    configureToolBar()
    configureTextView()

    /* Temporary */
//      {"type": "docDelta", "data": {"documentID": "1", "value": "Hello World!"}}
    conn = WebSocketManager.shared.registerConnection(id: "072cf97d-ecda-41f7-adb7-a9ab538f44ec",
                                                      delegate: self)
  }
  
  private func configureView() {
    translatesAutoresizingMaskIntoConstraints = false
    layer.masksToBounds = false
    layer.shadowRadius = 10
    layer.shadowColor = UIColor(red: 0.454, green: 0.435, blue: 0.571, alpha: 0.3).cgColor
    layer.shadowOpacity = 1.0
    layer.shadowOffset = .init(width: 0, height: 4)
  }
  
  private func configureContainer() {
    container.translatesAutoresizingMaskIntoConstraints = false
    container.backgroundColor = .primaryBackground
    container.clipsToBounds = true
    container.layer.cornerRadius = 10.0
    
    addAndAttachToEdges(view: container, inset: 0)
  }
  
  private func configureToolBar() {
    toolBar.translatesAutoresizingMaskIntoConstraints = false
    toolBar.backgroundColor = .primaryBackground

    container.addSubview(toolBar)
    let toolbarConstraints = [
      toolBar.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 8),
      toolBar.topAnchor.constraint(equalTo: container.topAnchor, constant: 8),
      toolBar.heightAnchor.constraint(equalToConstant: 50),
      toolBar.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -8)
    ]

    NSLayoutConstraint.activate(toolbarConstraints)
  }
  
  private func configureTextView() {
    textView = Aztec.TextView(defaultFont: UIFont.openSans(weight: .regular, size: 25),
                                defaultParagraphStyle: .default,
                                defaultMissingImage: UIImage(named: "bold")!)
    container.addSubview(textView)
    textView.translatesAutoresizingMaskIntoConstraints = false

    let constraints = [
      textView.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 16),
      textView.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -16),
      textView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -16),
      textView.topAnchor.constraint(equalTo: toolBar.bottomAnchor, constant: 20),
    ]

    NSLayoutConstraint.activate(constraints)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  deinit {
//    socket.disconnect() //still have to do something about this
  }
}

extension NoteEditor: LiteWebSocketDelegate {
  func didReceiveMessage(_ message: SocketMessage) {
    Log.debug("Did receive message:\n\(message)")
    textView.text += message.data.value
  }
}

extension NoteEditor: EditorToolbarDelegate {
  func didSelect(option: EditorToolbarOption) {
    switch option {
    case .header1:
      let message = SocketMessage(type: .docDelta, data: DocumentDelta(value: textView.text))
      conn.send(message: message)
      textView.toggleHeader(.h1, range: textView.selectedRange)
    case .header2:
      textView.toggleHeader(.h2, range: textView.selectedRange)
    case .bold:
      textView.toggleBold(range: textView.selectedRange)
    case .italic:
      textView.toggleItalic(range: textView.selectedRange)
    case .underline:
      textView.toggleUnderline(range: textView.selectedRange)
    case .bulletList:
      textView.toggleUnorderedList(range: textView.selectedRange)
    case .numberList:
      textView.toggleOrderedList(range: textView.selectedRange)
    default:
      break
    }
  }
}
