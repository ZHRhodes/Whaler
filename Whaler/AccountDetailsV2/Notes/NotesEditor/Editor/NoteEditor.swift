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
  var otClient: OTClient?
  var resourceId: String?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configureView()
    configureContainer()
    configureToolBar()
    configureTextView()
  }
  
  func registerAsDelegate(resourceId: String, socket: WebSocketClient?) {
    guard let socket = socket else { return }
    self.resourceId = resourceId
    WebSocketManager.shared.info(for: socket)?.delegates.add(delegate: self)
  }
  
  private func configureView() {
    translatesAutoresizingMaskIntoConstraints = false
  }
  
  private func configureContainer() {
    addAndAttachToEdges(view: container, inset: 0)
  }
  
  private func configureToolBar() {
    toolBar.translatesAutoresizingMaskIntoConstraints = false

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
    textView.delegate = self
    container.addSubview(textView)
    textView.translatesAutoresizingMaskIntoConstraints = false
		textView.backgroundColor = .primaryBackground

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
}

extension NoteEditor: LiteWebSocketDelegate {
  func didReceiveMessage(_ message: SocketMsg, socket: WebSocketClient) {
    Log.debug("Did receive message:\n\(message)")
    switch message {
    case .resourceConnectionConf(let conf):
      textView.text = conf.initialState
      otClient = WebSocketManager.shared.makeOTClient(resourceId: resourceId!,
                                                      docString: conf.initialState,
                                                      revision: conf.revision,
                                                      over: socket)
    break
    case .docChange:
      break
    case .docChangeReturn(let returnMsg, let wasSender):
      print("did receive return message: \(returnMsg)")
      guard let otClient = otClient else { return }
      do {
        if wasSender {
          try otClient.ack()
        } else {
          var returnOps = [OTOp]()
          for (i, n) in returnMsg.n.enumerated() {
            returnOps.append(OTOp(n: n, s: returnMsg.s[i]))
          }
          try otClient.recv(ops: returnOps)
					var range: NSRange?
					if let id = Lifecycle.currentUser?.id,
						 let cursor = otClient.doc.cursors.first(where: { $0.id == id }) {
						range = NSRange(location: cursor.position, length: 0)
					}
					textView.text = otClient.doc.toString()
					/* New cursor has to be captured before text is changed.
					Cursor will reset to end when text is changed */
					range.map { textView.selectedRange = $0 }
        }
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
    let message = SocketMessage(type: .resourceConnection,
                                data: data)
    WebSocketManager.shared.send(message: message, over: socket)
  }
}

extension NoteEditor: EditorToolbarDelegate {
  func didSelect(option: EditorToolbarOption) {
    switch option {
    case .header1:
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
	
	func textViewDidChangeSelection(_ textView: UITextView) {
		guard let id = Lifecycle.currentUser?.id else { return }
		otClient?.doc.setCursor(id: id, position: textView.selectedRange.location)
	}
}
