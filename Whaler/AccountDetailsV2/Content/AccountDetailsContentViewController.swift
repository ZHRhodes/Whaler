//
//  AccountDetailsContentViewController.swift
//  Whaler
//
//  Created by Zachary Rhodes on 2/15/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation
import UIKit

class AccountDetailsContentViewController: UIViewController {
  private var interactor: AccountDetailsContentInteractor!
  private var titleLabel = UILabel()
  private var subtitleLabel = UILabel()
  private let detailsGrid = DetailsGrid()
  private let contactsVC = AccountDetailsContactsViewController()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureTitleLabel()
    configureSubtitleLabel()
  }
  
  func configure(with interactor: AccountDetailsContentInteractor) {
    self.interactor = interactor
    configureDetailsGrid()
    configureContactsSection()
  }
  
  private func configureDetailsGrid() {
    detailsGrid.configure(with: [
      DetailItem(image: UIImage(named: "IndustryDetailIcon")!, description: "Industry", value: interactor.account.industry ?? "—"),
      DetailItem(image: UIImage(named: "CityDetailIcon")!, description: "City", value: interactor.account.billingCity ?? "—", showRightLine: false),
      DetailItem(image: UIImage(named: "HeadcountDetailIcon")!, description: "Headcount", value: interactor.account.numberOfEmployees ?? "—"),
      DetailItem(image: UIImage(named: "StateDetailIcon")!, description: "State", value: interactor.account.billingState ?? "—", showRightLine: false),
      DetailItem(image: UIImage(named: "RevenueDetailIcon")!, description: "Revenue", value: interactor.account.annualRevenue ?? "—", showBottomLine: false),
      DetailItem(image: UIImage(named: "ContactsDetailIcon")!, description: "Contacts", value: "—", showBottomLine: false, showRightLine: false),
    ])
    
    detailsGrid.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(detailsGrid)
    
    detailsGrid.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40).isActive = true
    detailsGrid.heightAnchor.constraint(equalToConstant: 210).isActive = true
    detailsGrid.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40).isActive = true
    detailsGrid.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 40).isActive = true
  }
  
  private func configureContactsSection() {
    let interactor = AccountDetailsContactsInteractor(dataManager: self.interactor.dataManager)
    contactsVC.configure(with: interactor)
    contactsVC.view.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(contactsVC.view)
    contactsVC.view.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    contactsVC.view.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.65).isActive = true
    contactsVC.view.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
    contactsVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
  }
  
  private func configureTitleLabel() {
    titleLabel = UILabel()
    titleLabel.font = .openSans(weight: .bold, size: 48)
    let accountName = interactor.account.name
    let text = "📒 \(accountName)"
    
    titleLabel.text = text
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(titleLabel)
    
    let constraints = [
      titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 38),
      titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25),
      titleLabel.heightAnchor.constraint(equalToConstant: 64)
    ]
    
    NSLayoutConstraint.activate(constraints)
  }
  
  private func configureSubtitleLabel() {
    subtitleLabel = UILabel()
    subtitleLabel.font = .openSans(weight: .regular, size: 24)
    
    subtitleLabel.text = "Account Details"
    subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(subtitleLabel)
    
    let constraints = [
      subtitleLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor, constant: 0),
      subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 0),
      subtitleLabel.heightAnchor.constraint(equalToConstant: 28)
    ]
    
    NSLayoutConstraint.activate(constraints)
  }
}
