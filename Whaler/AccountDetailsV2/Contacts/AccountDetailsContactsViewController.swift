//
//  AccountDetailsContactsViewController.swift
//  Whaler
//
//  Created by Zachary Rhodes on 2/15/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation
import UIKit

class AccountDetailsContactsViewController: UIViewController {
  private var interactor: AccountDetailsContactsInteractor!
  private var collectionView: UICollectionView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  func configure(with interactor: AccountDetailsContactsInteractor) {
    self.interactor = interactor
    configureCollectionView()
  }
  
  private func configureCollectionView() {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.minimumLineSpacing = 50.0
    
    collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.backgroundColor = .primaryBackground
    collectionView.register(MainCollectionCell<MainTableCell>.self, forCellWithReuseIdentifier: MainCollectionCell<MainTableCell>.id())
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.contentInset = .init(top: 0, left: 40, bottom: 0, right: 40)

    view.addAndAttachToEdges(view: collectionView)
  }
}

extension AccountDetailsContactsViewController: MainCollectionCellDelegate {
  func didClickAssignButton(_ button: UIButton, forAccount account: Account) {
    //this needs to bbe removed after switching to other cell/delegate
  }
  
  func didSelectRowAt(section: Int, didSelectRowAt indexPath: IndexPath) {

  }

  func didClickAssignButton(_ button: UIButton, forContact contact: Contact) {
    interactor.contactBeingAssigned = contact
    let viewController = TablePopoverViewController()
    viewController.modalPresentationStyle = .popover
    viewController.provider = OrgUsersProvider()
    viewController.delegate = self
    navigationController?.present(viewController, animated: true, completion: nil)
    let popoverVC = viewController.popoverPresentationController
    popoverVC?.permittedArrowDirections = [.left, .up, .right]
    popoverVC?.sourceView = button
  }
}

extension AccountDetailsContactsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return interactor.contactStates.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCollectionCell<MainTableCell>.id(), for: indexPath) as? MainCollectionCell<MainTableCell> else {
      return UICollectionViewCell()
    }
//      let state = interactor.accountStates[indexPath.section]
//      let account = interactor.accountGrouper[state][indexPath.row]
    cell.section = indexPath.row
    cell.dataSource = interactor.dataManager
    cell.delegate = self
    return cell
  }
}

extension AccountDetailsContactsViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: (collectionView.frame.size.width/3) - 70, height: collectionView.frame.size.height - 13)
    //width: (collectionView.frame.size.width/4) - 20
//    return CGSize(width: 500, height: 1400)
  }
}

extension AccountDetailsContactsViewController: TablePopoverViewControllerDelegate {
  func didSelectItem(_ item: SimpleItem) {
    guard let user = item as? User,
          let contact = interactor.contactBeingAssigned else { return }
    interactor.assign(user, to: contact)
  }
}
