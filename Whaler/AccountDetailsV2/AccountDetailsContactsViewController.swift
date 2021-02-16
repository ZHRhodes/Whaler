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
  private var interactor: MainInteractor!
  private var collectionView: UICollectionView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  func configure(with interactor: MainInteractor) {
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
    collectionView.register(MainCollectionCell.self, forCellWithReuseIdentifier: MainCollectionCell.id)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.contentInset = .init(top: 0, left: 40, bottom: 0, right: 40)

    view.addAndAttachToEdges(view: collectionView)
  }
}

extension AccountDetailsContactsViewController: MainCollectionCellDelegate {
  func didSelectRowAt(section: Int, didSelectRowAt indexPath: IndexPath) {
    let accountState = interactor.accountStates[section]
    let account = interactor.accountGrouper[accountState][indexPath.row]
    interactor.getContacts(for: account) { [weak self] in
//      let view = AccountDetailsView(account: account)
      let viewController = AccountDetailsViewController()//UIHostingController(rootView: view)
      self?.navigationController?.pushViewController(viewController, animated: false)
    }
  }
  
  func didClickAssignButton(_ button: UIButton, forAccount account: Account) {
    interactor.accountBeingAssigned = account
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
    return 3//get this from contactStates.count    //interactor.accountStates.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCollectionCell.id, for: indexPath) as? MainCollectionCell else {
      return UICollectionViewCell()
    }
  //    let state = interactor.accountStates[indexPath.section]
  //    let account = interactor.accountGrouper[state][indexPath.row]
    cell.section = indexPath.row
    cell.dataSource = interactor
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
          let account = interactor.accountBeingAssigned else { return }
    interactor.assign(user, to: account)
  }
}
