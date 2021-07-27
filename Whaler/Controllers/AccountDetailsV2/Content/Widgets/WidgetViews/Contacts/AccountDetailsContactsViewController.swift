//
//  AccountDetailsContactsViewController.swift
//  Whaler
//
//  Created by Zachary Rhodes on 2/15/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation
import UIKit
import Combine

class AccountDetailsContactsViewController: UIViewController {
  private var interactor: AccountDetailsContactsInteractor!
  private let layout = UICollectionViewFlowLayout()
  private var collectionView: UICollectionView!
  private var dataChangeCancellable: AnyCancellable?
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
//    collectionView.showAnimatedGradientSkeleton()
  }
  
  override func viewWillLayoutSubviews() {
    collectionView.collectionViewLayout.invalidateLayout()
    super.viewWillLayoutSubviews()
  }
  
  func configure(with interactor: AccountDetailsContactsInteractor) {
    self.interactor = interactor
		view.clipsToBounds = true
		view.layer.cornerRadius = UIConstants.boxCornerRadius
    configureCollectionView()
    dataChangeCancellable = interactor.dataChanged.sink { [weak self] in
      self?.collectionView.reloadData()
    }
    interactor.subscribeToContacts(for: interactor.dataManager)
  }
  
  private func configureCollectionView() {
    layout.scrollDirection = .horizontal
    layout.minimumLineSpacing = 33.0
    
    collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
		collectionView.backgroundColor = .accentBackground
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.isSkeletonable = true
    collectionView.register(TableInCollectionViewCell<ContactTableCell, Contact>.self,
                            forCellWithReuseIdentifier: TableInCollectionViewCell<ContactTableCell, Contact>.id())
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.contentInset = .init(top: 0, left: 16, bottom: 0, right: 16)

		view.addAndAttach(view: collectionView, attachingEdges: [.all()])
		collectionView.heightAnchor.constraint(equalToConstant: 700).isActive = true
  }
}

extension AccountDetailsContactsViewController: MainCollectionCellDelegate {
  func didClickAssignButton(_ button: UIButton, forAccount account: Account) {
    //this needs to bbe removed after switching to other cell/delegate
  }
  
  func didSelectRowAt(section: Int, didSelectRowAt indexPath: IndexPath) {

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
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TableInCollectionViewCell<ContactTableCell, Contact>.id(), for: indexPath) as? TableInCollectionViewCell<ContactTableCell, Contact> else {
      return UICollectionViewCell()
    }
    
    let state = interactor.contactStates[indexPath.row]
    let data = interactor.contactGrouper?[state]
		let sectionInfo = SectionInfo(title: state.rawValue, color: state.color, compact: true)
    cell.configure(sectionInfo: sectionInfo, dataSource: data ?? [], delegate: self, cellDelegate: self, showSkeleton: data == nil)
    return cell
  }
}

extension AccountDetailsContactsViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: (collectionView.frame.size.width/3) - 36, height: collectionView.frame.size.height - 13)
  }
}

extension AccountDetailsContactsViewController: TablePopoverViewControllerDelegate {
  func didSelectItem(_ item: SimpleItem) {
    dismiss(animated: true) { [weak self] in
      guard let user = item as? User,
            let contact = self?.interactor.contactBeingAssigned else { return }
      
      self?.interactor.assign(user, to: contact)
      
      guard let state = contact.state,
            let data = self?.interactor.contactGrouper?[state],
            let stateIndex = self?.interactor.contactStates.firstIndex(of: state),
            let collectionCell = self?.collectionView.cellForItem(at: IndexPath(row: stateIndex, section: 0)) as? TableInCollectionViewCell<ContactTableCell, Contact> else { return }
      
      for (i, existingContact) in data.enumerated() {
        if existingContact == contact {
          collectionCell.tableView.reloadRows(at: [IndexPath(row: i, section: 0)],
                                              with: .automatic)
        }
      }
    }
  }
}

extension AccountDetailsContactsViewController: TableInCollectionViewDelegate {
  func didSelectItemAt(section: String, row: Int) {
    
  }
  
  func requestChangeToData<ObjectType>(adding: ObjectType, index: Int, sectionTitle: String) {
    guard let contact = adding as? Contact,
          let state = WorkState(from: sectionTitle) else { return }
    interactor.addContact(contact, state: state, index: index)
    
    guard let stateIndex = interactor.contactStates.firstIndex(of: state) else { return }
    if let cell = collectionView.cellForItem(at: IndexPath(row: stateIndex, section: 0)) as? TableInCollectionViewCell<ContactTableCell, Contact> {
      cell.dataSource = interactor.contactGrouper?[state] ?? []
    }
  }
  
  func requestChangeToData(removingFrom index: Int, sectionTitle: String) {
    guard let state = WorkState(from: sectionTitle) else { return }
    interactor.removeFrom(state: state, index: index)
    guard let stateIndex = interactor.contactStates.firstIndex(of: state) else { return }
    if let cell = collectionView.cellForItem(at: IndexPath(row: stateIndex, section: 0)) as? TableInCollectionViewCell<ContactTableCell, Contact> {
      cell.dataSource = interactor.contactGrouper?[state] ?? []
    }
  }
}

extension AccountDetailsContactsViewController: ContactTableCellDelegate {
  func didClickAssignButton(_ button: UIButton, forContact contact: Contact) {
    interactor.contactBeingAssigned = contact
    let viewController = TablePopoverViewController()
    viewController.modalPresentationStyle = .popover
    viewController.provider = OrgUsersProvider()
    viewController.delegate = self
    present(viewController, animated: true, completion: nil)
    let popoverVC = viewController.popoverPresentationController
    popoverVC?.permittedArrowDirections = [.left, .up, .right]
    popoverVC?.sourceView = button
  }
}
