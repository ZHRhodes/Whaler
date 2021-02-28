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
  private let splitPaneViewController = SplitPaneViewController()
  private let contentVC = AccountDetailsContentViewController()
  
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
  
  func configure(with dataManager: MainDataManager) {
    let interactor = AccountDetailsContentInteractor(dataManager: dataManager)
    contentVC.configure(with: interactor)
    let view1 = contentVC.view!
    view1.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(view1)
    
    view1.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6).isActive = true
    view1.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
    view1.topAnchor.constraint(equalTo: view.topAnchor, constant: 70).isActive = true
    view1.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
    
    let noteEditorVC = NoteEditorViewController()
    noteEditorVC.view.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(noteEditorVC.view)
    
    noteEditorVC.view.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4).isActive = true
    noteEditorVC.view.topAnchor.constraint(equalTo: view.topAnchor, constant: 70).isActive = true
    noteEditorVC.view.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
    noteEditorVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
  }
}
