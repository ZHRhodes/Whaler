//
//  NoteEditorViewController.swift
//  Whaler
//
//  Created by Zachary Rhodes on 2/12/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation
import UIKit

class NoteEditorViewController: UIViewController {
  var interactor: NoteEditorInteractor!
  private let label = UILabel()
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
    configureLabel()
    configureNotesView()
    configureProgressIndicator()
    noteEditor.startConnection(with: interactor.accountId)
  }
  
  private func configureLabel() {
    label.text = "Notes"
    label.font = .openSans(weight: .regular, size: 24)
    label.textColor = .primaryText
    label.translatesAutoresizingMaskIntoConstraints = false
    
    view.addSubview(label)
    
    let constraints = [
      label.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 44),
      label.topAnchor.constraint(equalTo: view.topAnchor, constant: 84),
      label.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -44),
      label.heightAnchor.constraint(equalToConstant: 41)
    ]
    
    NSLayoutConstraint.activate(constraints)
  }
  
  private func configureNotesView() {
    noteEditor.translatesAutoresizingMaskIntoConstraints = false
    noteEditor.delegate = self
    
    view.addSubview(noteEditor)
    
    let constraints = [
      noteEditor.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 44),
      noteEditor.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 31),
      noteEditor.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -44),
      noteEditor.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 10)
    ]
    
    NSLayoutConstraint.activate(constraints)
  }
  
  private func configureProgressIndicator() {
    progressView = TextFinishedProgressIndicator(text: "Saved",
                                          textColor: .brandGreen,
                                          progressView: ProgressView(colors: [.brandGreen, .brandPurple, .brandRed], lineWidth: 5))
    progressView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(progressView)
    progressView.widthAnchor.constraint(equalToConstant: 90).isActive = true
    progressView.heightAnchor.constraint(equalToConstant: 41).isActive = true
    progressView.centerYAnchor.constraint(equalTo: label.centerYAnchor, constant: 0).isActive = true
    progressView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -64).isActive = true
  }
  
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
