//
//  AccountDetailsViewController.swift
//  Whaler
//
//  Created by Zachary Rhodes on 12/19/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import Foundation
import UIKit
import Combine

class AccountDetailsViewController: ToolbarContainingViewController {
  private var interactor: AccountDetailsInteractor?
  private let splitPaneViewController = SplitPaneViewController()
  private let contentVC = AccountDetailsContentViewController()
  private let noteEditorVC = NoteEditorViewController()
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
//    interactor?.save(account: interactor?.account, withNoteText: )
  }
  
  func configure(with dataManager: MainDataManager) {
    self.interactor = AccountDetailsInteractor(dataManager: dataManager)
    self.interactor?.viewController = self
    let interactor = AccountDetailsContentInteractor(dataManager: dataManager)
    contentVC.configure(with: interactor)
    let view1 = contentVC.view!
    view1.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(view1)
    
    view1.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6).isActive = true
    view1.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
    view1.topAnchor.constraint(equalTo: view.topAnchor, constant: 70).isActive = true
    view1.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
    
    noteEditorVC.view.translatesAutoresizingMaskIntoConstraints = false
    noteEditorVC.currentText = interactor.account.notes ?? ""
    noteEditorVC.delegate = self
    view.addSubview(noteEditorVC.view)
    
    noteEditorVC.view.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4).isActive = true
    noteEditorVC.view.topAnchor.constraint(equalTo: view.topAnchor, constant: 70).isActive = true
    noteEditorVC.view.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
    noteEditorVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
  }
  
  func didBeginSaving() {
    noteEditorVC.showProgressIndicator()
  }
  
  func didFinishSaving() {
    noteEditorVC.hideProgressIndicator()
  }
}

extension AccountDetailsViewController: NoteEditorDelegate {
  func willChangeText(_ text: String, replacingRange range: NSRange, with replacementText: String) {
  }
  
  func changedText(newValue: String) {
    interactor?.changedNoteText(newValue: newValue)
  }
}
