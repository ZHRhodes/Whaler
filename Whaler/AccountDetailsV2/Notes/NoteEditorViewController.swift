//
//  NoteEditorViewController.swift
//  Whaler
//
//  Created by Zachary Rhodes on 2/12/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation
import UIKit

enum UIConstants {
	static let boxCornerRadius: CGFloat = 10.0
	static let boxBorderWidth: CGFloat = 1.0
}

class NoteEditorViewController: UIViewController {
  var interactor: NoteEditorInteractor!
  private let noteEditor = NoteEditor(frame: .zero)
  private var progressView: TextFinishedProgressIndicator!
  
  var currentText: String {
    get {
      return noteEditor.textView.text
    }
    set {
      noteEditor.textView.text = newValue
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureNotesView()
//    configureProgressIndicator()
    noteEditor.registerAsDelegate(resourceId: interactor.accountId,
                                  socket: interactor.socket)
  }
  
  private func configureNotesView() {
    noteEditor.translatesAutoresizingMaskIntoConstraints = false
    noteEditor.delegate = self
		noteEditor.backgroundColor = .primaryBackground
		noteEditor.layer.borderColor = UIColor.borderLineColor.cgColor
		noteEditor.clipsToBounds = true
		noteEditor.layer.cornerRadius = UIConstants.boxCornerRadius
		noteEditor.layer.borderWidth = 0//UIConstants.boxBorderWidth
    
		view.addAndAttachToEdges(view: noteEditor, inset: 16.0)
  }
  
//  private func configureProgressIndicator() {
//    progressView = TextFinishedProgressIndicator(text: "Saved",
//                                          textColor: .brandGreen,
//                                          progressView: ProgressView(colors: [.brandGreen, .brandPurple, .brandRed], lineWidth: 5))
//    progressView.translatesAutoresizingMaskIntoConstraints = false
//    view.addSubview(progressView)
//    progressView.widthAnchor.constraint(equalToConstant: 90).isActive = true
//    progressView.heightAnchor.constraint(equalToConstant: 41).isActive = true
//    progressView.centerYAnchor.constraint(equalTo: label.centerYAnchor, constant: 0).isActive = true
//    progressView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -64).isActive = true
//  }
  
  func noteChanged() {
    guard let newText = interactor.note?.content else { return }
    currentText = newText
  }
  
  func showProgressIndicator() {
    progressView.startAnimation()
  }
  
  func hideProgressIndicator() {
    progressView.finishAnimation()
  }
}

extension NoteEditorViewController: NoteEditorDelegate {
  func willChangeText(_ text: String, replacingRange range: NSRange, with replacementText: String) {
    
  }
  
  func changedText(newValue: String) {
//    interactor.save(text: newValue)
  }
}
