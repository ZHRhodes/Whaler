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
  private lazy var noteEditorVC: NoteEditorViewController = {
    let vc = NoteEditorViewController()
    vc.interactor = NoteEditorInteractor(accountId: interactor?.account?.id ?? "",
                                         socket: interactor?.socket)
    vc.interactor.viewController = vc
    return vc
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
  }
  
  override func backTapped() {
    if let resourceId = interactor?.account?.id {
      WebSocketManager.shared.disconnectClient(with: resourceId)
    }
    super.backTapped()
  }
  
  func configure(with dataManager: MainDataManager) {
    self.interactor = AccountDetailsInteractor(dataManager: dataManager)
    self.interactor?.viewController = self
    let contentInteractor = AccountDetailsContentInteractor(dataManager: dataManager,
                                                            socket: interactor?.socket)
    contentVC.configure(with: contentInteractor)
    let view1 = contentVC.view!
    view1.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(view1)
    
    view1.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6).isActive = true
    view1.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
    view1.topAnchor.constraint(equalTo: view.topAnchor, constant: 70).isActive = true
    view1.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
    
    noteEditorVC.view.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(noteEditorVC.view)
    
    noteEditorVC.view.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4).isActive = true
    noteEditorVC.view.topAnchor.constraint(equalTo: view.topAnchor, constant: 70).isActive = true
    noteEditorVC.view.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
    noteEditorVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
		
		let line = UIView()
		line.backgroundColor = .borderLineColor
		
		view.addAndAttach(view: line, width: UIConstants.boxBorderWidth,
											attachingEdges: [.top(86),
																			 .bottom(-16),
																			 .centerX(equalTo: noteEditorVC.view.leftAnchor)])
	}
}
