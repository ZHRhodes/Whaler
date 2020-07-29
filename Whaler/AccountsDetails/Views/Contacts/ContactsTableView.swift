//
//  ContactsTableView.swift
//  Whaler
//
//  Created by Zachary Rhodes on 7/19/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import SwiftUI

struct ContactCellItem: Identifiable {
  let state: WorkState?
  let contact: Contact?
  
  init(state: WorkState) {
    self.state = state
    self.contact = nil
  }
  
  init(contact: Contact) {
    self.contact = contact
    self.state = nil
  }
  
  var id: String {
    if let contact = contact {
      return contact.id
    } else if let state = state {
      return state.id
    } else {
      return ""
    }
  }
}

struct ContactsTableView: View {
  private class ViewModel {
    var contactItems: [ContactCellItem] = [] {
      didSet {
        print(contactItems)
      }
    }
    
    init(contacts: [Contact]) {
      let inProgress = contacts.filter { $0.state == .inProgress }.map { ContactCellItem(contact: $0) }
      let ready = contacts.filter { $0.state == .ready }.map { ContactCellItem(contact: $0) }
      let worked = contacts.filter { $0.state == .worked }.map { ContactCellItem(contact: $0) }
      
      contactItems.append(ContactCellItem(state: .inProgress))
      contactItems.append(contentsOf: inProgress)
      contactItems.append(ContactCellItem(state: .ready))
      contactItems.append(contentsOf: ready)
      contactItems.append(ContactCellItem(state: .worked))
      contactItems.append(contentsOf: worked)
    }
    
    func move(from fromIndex: IndexSet, to toIndex: Int) {
      guard let firstIndex = fromIndex.first,
            let contactCellItemToMove = contactItems[firstIndex].contact else { return }
      contactItems.move(fromOffsets: fromIndex, toOffset: toIndex)
      if let nextContact = contactItems[toIndex.advanced(by: 1)].contact {
        contactCellItemToMove.state = nextContact.state
      } else if let prevContact = contactItems[toIndex.advanced(by: 1)].contact {
        contactCellItemToMove.state = prevContact.state
      }
    }
  }
  
  private let viewModel: ViewModel
  
  init(contacts: [Contact]) {
    viewModel = ViewModel(contacts: contacts)
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: 2) {
      Text("CONTACTS").padding().font(Font.custom(boldFontName, size: 17))
      List {
        listContent
      }
    }
    .padding(EdgeInsets(top: 40, leading: 10, bottom: 40, trailing: 40))
  }
  
  private var listContent: some View {
    ForEach(viewModel.contactItems) { contactItem in
      if let state = contactItem.state {
        TagView(text: state.rawValue, color: Color(state.color))
          .moveDisabled(true)
          .padding(.top)
      } else if let contact = contactItem.contact {
        ContactRowView(contact: contact)
      }
    }
    .onMove(perform: self.onMove)
  }
    
  private func onMove(source: IndexSet, destination: Int) {
    viewModel.move(from: source, to: destination)
  }
}

//struct ContactsTableView_Previews: PreviewProvider {
//  static var previews: some View {
//    ContactsTableView(contacts: mockContacts)
//      .frame(width: 800, height: 900.0)
//  }
//}

let mockContacts = [
  Contact(dictionary: ["name": "Rita Book", "title": "Director of Design"])
]
