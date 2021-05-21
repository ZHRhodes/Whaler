//
//  AccountWidget.swift
//  Whaler
//
//  Created by Zack Rhodes on 5/19/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation
import Combine
import UIKit

class Task: RepoStorable {
	var id: String = "temp"
}

protocol DetailsProvider: AnyObject {
	var publisher: AnyPublisher<[DetailItem], Never> { get }
}

protocol TasksProvider: AnyObject {
	var publisher: AnyPublisher<[Task], Never> { get }
}

protocol ContactsProvider: AnyObject {
	var publisher: AnyPublisher<[Contact], Never> { get }
}

class DefaultDetailsProvider: DetailsProvider {
	var accountCancellable: AnyCancellable?
	var subject = CurrentValueSubject<[DetailItem], Never>([])
	var publisher: AnyPublisher<[DetailItem], Never> {
		return subject.eraseToAnyPublisher()
	}
	
	init(source: AnyPublisher<Account, Never>) {
		accountCancellable = source.sink(receiveValue: { [weak self] account in
			self?.subject.send([DetailItem(image: UIImage(named: "IndustryDetailIcon")!, description: "Industry", value: account.industry ?? "—"),
													DetailItem(image: UIImage(named: "StateDetailIcon")!, description: "State", value: account.billingState ?? "—"),
													DetailItem(image: UIImage(named: "CityDetailIcon")!, description: "City", value: account.billingCity ?? "—"),
													DetailItem(image: UIImage(named: "HeadcountDetailIcon")!, description: "Headcount", value: account.numberOfEmployees ?? "—"),
													DetailItem(image: UIImage(named: "RevenueDetailIcon")!, description: "Revenue", value: account.annualRevenue ?? "—"),
													DetailItem(image: UIImage(named: "ContactsDetailIcon")!, description: "Contacts", value: "—")])
		})
	}
}

class DefaultContactsProvider: ContactsProvider {
	var publisher: AnyPublisher<[Contact], Never> {
		return Just([]).eraseToAnyPublisher()
	}
}

enum AccountWidget {
	case details(DetailsProvider),
			 tasks(TasksProvider),
			 contacts(ContactsProvider)
}
