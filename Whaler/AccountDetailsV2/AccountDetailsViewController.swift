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

class AccountDetailsViewController: UIViewController {
  var backCancellable: AnyCancellable?
  private var interactor: AccountDetailsInteractor?
  private let splitPaneViewController = SplitPaneViewController()
  private let contentVC = AccountDetailsContentViewController()
  private let noteEditorVC = NoteEditorViewController()
  
  override func viewDidLoad() {
    super.viewDidLoad()
//    configureSplitPaneViewController()
    backCancellable = NotificationCenter.default
      .publisher(for: .back)
      .first()
      .sink(receiveValue: { [weak self] notification in
        self?.navigationController?.popViewController(animated: false)
    })
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    interactor?.save(account: interactor?.account, withNoteText: noteEditorVC.currentText)
  }
  
  func configure(with dataManager: MainDataManager) {
    self.interactor = AccountDetailsInteractor(dataManager: dataManager)
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
    view.addSubview(noteEditorVC.view)
    
    noteEditorVC.view.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4).isActive = true
    noteEditorVC.view.topAnchor.constraint(equalTo: view.topAnchor, constant: 70).isActive = true
    noteEditorVC.view.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
    noteEditorVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
  }
}
