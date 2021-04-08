//
//  NoteRemoteDataSource.swift
//  Whaler
//
//  Created by Zachary Rhodes on 4/7/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation
import Combine

struct NoteRemoteDataSource {
  func fetchSingle(accountID: String) -> AnyPublisher<Note?, RepoError> {
    return Future<Note?, RepoError> { promise in
      let query = NoteQuery(accountID: accountID)
      Graph.shared.apollo.fetch(query: query) { result in
        guard let resultNote = try? result.get().data?.note else {
          promise(.failure(RepoError(reason: "Failed to query note.",
                                                                                           
                                     humanReadableMessage: nil)))
          return
        }
        let note = Note(id: resultNote.id,
                        accountId: resultNote.accountId,
                        content: resultNote.content)
        promise(.success(note))
      }
    }.eraseToAnyPublisher()
  }
  
  func save(note: Note) -> AnyPublisher<Note, RepoError> {
    return Future<Note, RepoError> { promise in
      let newNote = NewNote(id: note.id, accountId: note.accountId, content: note.content)
      let mutation = SaveNoteMutation(input: newNote)
      Graph.shared.apollo.perform(mutation: mutation) { result in
        guard let resultNote = try? result.get().data?.saveNote else {
          promise(.failure(RepoError(reason: "Failed to mutate note.",
                                                                                           
                                     humanReadableMessage: nil)))
          return
        }
        let note = Note(id: resultNote.id,
                        accountId: resultNote.accountId,
                        content: resultNote.content)
        promise(.success(note))
      }
    }.eraseToAnyPublisher()
  }
}
