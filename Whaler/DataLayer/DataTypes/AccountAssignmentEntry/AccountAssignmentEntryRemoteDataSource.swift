//
//  AccountAssignmentEntryRemoteDataSource.swift
//  Whaler
//
//  Created by Zachary Rhodes on 4/3/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation
import Combine

struct AccountAssignmentEntryRemoteDataSource {
  func save(_ entry: AccountAssignmentEntry) -> AnyPublisher<AccountAssignmentEntry, RepoError> {
    return Future<AccountAssignmentEntry, RepoError> { promise in
      let mutation = CreateAccountAssignmentEntryMutation(accountId: entry.accountId,
                                                          assignedBy: entry.assignedBy,
                                                          assignedTo: entry.assignedTo)
      Graph.shared.apollo.perform(mutation: mutation) { result in
        guard let savedEntry = try? result.get().data?.accountAssignmentEntry else {
          promise(.failure(RepoError(reason: "Failed to create account assignment entry remotely", humanReadableMessage: nil)))
          return
        }
        let accountAssignmentEntry = AccountAssignmentEntry(id: savedEntry.id,
                                                            createdAt: DateFormatter.default.date(from: savedEntry.createdAt) ?? Date(),
                                                            accountId: savedEntry.accountId,
                                                            assignedBy: savedEntry.assignedBy,
                                                            assignedTo: savedEntry.assignedTo)
        promise(.success(accountAssignmentEntry))
      }
    }.eraseToAnyPublisher()
  }
}
