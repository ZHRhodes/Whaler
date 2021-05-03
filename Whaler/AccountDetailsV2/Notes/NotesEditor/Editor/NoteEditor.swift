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
import Starscream

//temp placement


struct NoteEditorRepresentable: UIViewRepresentable {
  typealias UIViewType = NoteEditor

  func makeUIView(context: Context) -> NoteEditor {
    NoteEditor(frame: .zero)
  }
  
  func updateUIView(_ uiView: NoteEditor, context: Context) {
    
  }
}

protocol NoteEditorDelegate {
  func willChangeText(_ text: String, replacingRange range: NSRange, with replacementText: String)
  func changedText(newValue: String)
}

class NoteEditor: UIView {
  private let container = UIView()
  lazy var toolBar = EditorToolbar(options: EditorToolbarOption.allCases, delegate: self)
  var delegate: NoteEditorDelegate?
  var textView: Aztec.TextView!
  var socket: WebSocketClient!
  var otClient: OTClient?
  var resourceId: String?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    configureView()
    configureContainer()
    configureToolBar()
    configureTextView()
  }
  
  func startConnection(with resourceId: String) {
    /* Temporary */
//      {"type": "docDelta", "data": {"documentID": "1", "value": "Hello World!"}}
    self.resourceId = resourceId
    socket = WebSocketManager.shared.registerConnection(id: resourceId,
                                                        delegate: self)
  }
  
  private func configureView() {
    translatesAutoresizingMaskIntoConstraints = false
    layer.borderColor = UIColor.borderLineColor.cgColor
    layer.borderWidth = 1.0
    layer.cornerRadius = 10.0
  }
  
  private func configureContainer() {
    container.translatesAutoresizingMaskIntoConstraints = false
    container.backgroundColor = .cellBackground
    container.clipsToBounds = true
    container.layer.cornerRadius = 10.0
    
    addAndAttachToEdges(view: container, inset: 0)
  }
  
  private func configureToolBar() {
    toolBar.translatesAutoresizingMaskIntoConstraints = false
    toolBar.backgroundColor = .cellBackground

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
    textView.backgroundColor = .cellBackground
    textView.delegate = self
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
  func didReceiveMessage(_ message: SocketMsg, socket: WebSocketClient) {
    Log.debug("Did receive message:\n\(message)")
    switch message {
    case .resourceConnectionConf(let conf):
//      guard //let data = message.data,
//            let connectionConf = try? JSONDecoder().decode(ResourceConnectionConf.self,
//                                                           from: message.data) else {
//        return
//      }
      textView.text = conf.initialState
      otClient = WebSocketManager.shared.makeOTClient(resourceId: resourceId!,
                                                      docString: conf.initialState,
                                                      over: socket)
    break
    case .docChange:
      //    let range = NSRange(message.data.range)
      //    textView.textStorage.replaceCharacters(in: range, with: message.data.value)
      break
    case .docChangeReturn(let returnMsg):
      print("did receive return message: \(returnMsg)")
      guard let otClient = otClient else { return }
      do {
//        var returnOps = [OTOp]()
//        for (i, n) in returnMsg.n.enumerated() {
//          returnOps.append(OTOp(n: n, s: returnMsg.s[i]))
//        }
//        try client.recv(ops: returnOps)
//        textView.text = client.doc.toString()
        try otClient.ack()
      } catch {
        Log.error(error.localizedDescription)
      }
    default:
      break
    }
  }
  
  func connectionEstablished(socket: WebSocketClient) {
    guard let resourceId = resourceId else { return }
    let data = ResourceConnection(resourceId: resourceId)
    let message = SocketMessage(type: .resourceConnection, data: data)
    socket.send(message: message)
  }
}

extension NoteEditor: EditorToolbarDelegate {
  func didSelect(option: EditorToolbarOption) {
    switch option {
    case .header1:
//      let message = SocketMessage(type: .docChange, data: DocumentChange(type: .format, value: textView.text))
//      conn.send(message: message)
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

extension NoteEditor: UITextViewDelegate {
  func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    delegate?.willChangeText(textView.text, replacingRange: range, with: text)
    guard let otClient = otClient else { return false }
    let ops = [OTOp].init(currentText:
                            textView.text,
                          changeRange: range,
                          replacementText: text)
    do {
      try otClient.apply(ops: ops)
    } catch {
      Log.error("Failed to apply ops to client. Error: \(error)")
    }
    Log.debug("Successfully applied own ops to doc. Ops: \(ops)")
    return true
  }
  
  func textViewDidChange(_ textView: UITextView) {
    delegate?.changedText(newValue: textView.text)
  }
}
