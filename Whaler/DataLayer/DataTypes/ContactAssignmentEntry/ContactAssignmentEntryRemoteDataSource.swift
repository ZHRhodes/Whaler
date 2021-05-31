//
//  ContactAssignmentEntryRemoteDataSource.swift
//  Whaler
//
//  Created by Zachary Rhodes on 5/22/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation
import Combine

struct ContactAssignmentEntryRemoteDataSource {
  func save(_ entry: ContactAssignmentEntry) -> AnyPublisher<ContactAssignmentEntry, RepoError> {
    return Future<ContactAssignmentEntry, RepoError> { promise in
      let mutation = CreateContactAssignmentEntryMutation(senderID: clientId,
                                                          contactId: entry.contactId,
                                                          assignedBy: entry.assignedBy,
                                                          assignedTo: entry.assignedTo)
      Graph.shared.apollo.perform(mutation: mutation) { result in
        guard let savedEntry = try? result.get().data?.contactAssignmentEntry else {
          promise(.failure(RepoError(reason: "Failed to create contact assignment entry remotely", humanReadableMessage: nil)))
          return
        }
        let accountAssignmentEntry = ContactAssignmentEntry(id: savedEntry.id,
                                                            createdAt: DateFormatter.default.date(from: savedEntry.createdAt) ?? Date(),
                                                            contactId: savedEntry.contactId,
                                                            assignedBy: savedEntry.assignedBy,
                                                            assignedTo: savedEntry.assignedTo)
        promise(.success(accountAssignmentEntry))
      }
    }.eraseToAnyPublisher()
  }
}
