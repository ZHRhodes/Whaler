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
  private let label = UILabel()
  private let noteEditor = NoteEditor(frame: .zero)
  private var progressView: ProgressView!
  
  var delegate: NoteEditorDelegate? {
    didSet {
      noteEditor.delegate = delegate
    }
  }
  
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
    progressView = ProgressView(colors: [.brandGreen, .brandPurple, .brandRed],
                                lineWidth: 5)
    progressView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(progressView!)
    progressView.widthAnchor.constraint(equalToConstant: 20).isActive = true
    progressView.heightAnchor.constraint(equalTo: progressView.widthAnchor).isActive = true
    progressView.centerYAnchor.constraint(equalTo: label.centerYAnchor, constant: 0).isActive = true
    progressView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -64).isActive = true
  }
  
  func showProgressIndicator() {
    progressView.isAnimating = true
  }
  
  func hideProgressIndicator() {
    progressView.isAnimating = false
  }
}
