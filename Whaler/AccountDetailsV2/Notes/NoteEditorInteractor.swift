//
//  NoteEditorInteractor.swift
//  Whaler
//
//  Created by Zachary Rhodes on 4/8/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation
import Combine

class NoteEditorInteractor {
  weak var viewController: NoteEditorViewController?
  
  let accountId: String
  var note: Note?
  private var fetchCancellable: AnyCancellable?
  private var saveCancellable: AnyCancellable?
  private let noteChangePublisher = PassthroughSubject<String, Never>()
  private var noteChangeCancellable: AnyCancellable?
  
  init(accountId: String) {
    self.accountId = accountId
    noteChangeCancellable = noteChangePublisher
      .debounce(for: .seconds(0.75), scheduler: DispatchQueue.main)
      .sink { [weak self] (newValue) in
        guard let strongSelf = self else { return }
        strongSelf.viewController?.showProgressIndicator()
        let noteOrNew = strongSelf.note ?? Note(id: "", accountId: accountId, content: newValue)
        noteOrNew.content = newValue
        strongSelf.save(note: noteOrNew)
    }
  }
  
  func subscribe() {
    fetchCancellable = repoStore
      .noteRepository
      .fetchSingle(with: accountId)
      .sink(receiveCompletion: {_ in},
            receiveValue: { [weak self] (note) in
              self?.note = note
              self?.viewController?.noteChanged()
            })
  }
  
  func save(text: String) {
    noteChangePublisher.send(text)
  }
  
  func save(note: Note?) {
    guard let note = note else { return }
    saveCancellable = repoStore
      .noteRepository
      .save(note).sink(receiveCompletion: { _ in },
                       receiveValue: { [weak self] (savedNote) in
                        savedNote.first.map { self?.note = $0 }
                        self?.viewController?.hideProgressIndicator()
                       })
  }
}
