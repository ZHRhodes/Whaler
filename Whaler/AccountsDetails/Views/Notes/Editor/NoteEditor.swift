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
import Starscream //Temporary

struct NoteEditorRepresentable: UIViewRepresentable {
  typealias UIViewType = NoteEditor

  func makeUIView(context: Context) -> NoteEditor {
    NoteEditor(frame: .zero)
  }
  
  func updateUIView(_ uiView: NoteEditor, context: Context) {
    
  }
}

class NoteEditor: UIView {
  lazy var toolBar = EditorToolbar(options: EditorToolbarOption.allCases, delegate: self)
  var textView: Aztec.TextView!
  var socket: WebSocket! // temp
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    toolBar.translatesAutoresizingMaskIntoConstraints = false
    toolBar.layer.borderWidth = 2.0
    toolBar.layer.borderColor = UIColor.brandPurple.cgColor//UIColor(red: 0.77, green: 0.77, blue: 0.77, alpha: 0.75).cgColor
    
    addSubview(toolBar)
    let toolbarConstraints = [
      toolBar.leftAnchor.constraint(equalTo: leftAnchor, constant: 4),
      toolBar.topAnchor.constraint(equalTo: topAnchor, constant: 0),
      toolBar.heightAnchor.constraint(equalToConstant: 50),
      toolBar.widthAnchor.constraint(equalToConstant: 450) //too constant probably
    ]
    
    NSLayoutConstraint.activate(toolbarConstraints)

    textView = Aztec.TextView(defaultFont: UIFont.openSans(weight: .regular, size: 25),
                                defaultParagraphStyle: .default,
                                defaultMissingImage: UIImage(named: "bold")!)
    addSubview(textView)
    textView.translatesAutoresizingMaskIntoConstraints = false
    
    let constraints = [
      textView.leftAnchor.constraint(equalTo: leftAnchor),
      textView.rightAnchor.constraint(equalTo: rightAnchor),
      textView.bottomAnchor.constraint(equalTo: bottomAnchor),
      textView.topAnchor.constraint(equalTo: toolBar.bottomAnchor, constant: 20),
      textView.heightAnchor.constraint(equalToConstant: 100),
      textView.widthAnchor.constraint(equalToConstant: 100)
    ]
    
    NSLayoutConstraint.activate(constraints)
    
    /* Temporary */
    var request = URLRequest(url: URL(string: "http://127.0.0.1:8080/socket")!) //reminder: drop the s for local
    request.timeoutInterval = 5
    request.setValue(Lifecycle.accessToken, forHTTPHeaderField: "Authorization")
    socket = WebSocket(request: request, protocols: ["echo"])
    socket.delegate = self
    socket.enableCompression = false
    socket.connect()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  deinit {
    socket.disconnect()
  }
}

extension NoteEditor: EditorToolbarDelegate {
  func didSelect(option: EditorToolbarOption) {
    switch option {
    case .header1:
      socket.write(string: textView.text)
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

//Temp
extension NoteEditor: WebSocketDelegate {
  func websocketDidConnect(socket: WebSocketClient) {
    Log.debug("websocket did connect")
  }
  
  func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
    Log.debug("websocket did disconnect")
  }
  
  func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
    Log.debug("websocket did receive message: \(text)")
  }
  
  func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
    Log.debug("websocket did receive data")
  }
}
