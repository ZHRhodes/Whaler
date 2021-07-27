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
  static let smallCornerRadius: CGFloat = 6.0
}

class NoteEditorViewController: UIViewController {
  var interactor: NoteEditorInteractor!
  private let noteEditor = NoteEditor(frame: .zero)
	private var loadingCover: LoadingCoverView?
  
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
//		showNotesLoadingCover()
    noteEditor.registerAsDelegate(resourceId: interactor.accountId,
                                  socket: interactor.socket)
  }
	
	private func showNotesLoadingCover() {
		loadingCover = LoadingCoverView()
		view.addAndAttach(view: loadingCover!, attachingEdges: [.all()])
	}
	
	private func hideNotesLoadingCover() {
		loadingCover?.removeFromSuperview()
		loadingCover = nil
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
  
  func noteChanged() {
    guard let newText = interactor.note?.content else { return }
    currentText = newText
  }
}

extension NoteEditorViewController: NoteEditorDelegate {
  func willChangeText(_ text: String, replacingRange range: NSRange, with replacementText: String) {
    
  }
  
  func changedText(newValue: String) {
//    interactor.save(text: newValue)
  }
}
