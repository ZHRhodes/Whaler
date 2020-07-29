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
  var contactsItems: [ContactCellItem] = []
  
  init(contacts: [Contact]) {
    let inProgress = contacts.filter { $0.state == .inProgress }.map { ContactCellItem(contact: $0) }
    let ready = contacts.filter { $0.state == .ready }.map { ContactCellItem(contact: $0) }
    let worked = contacts.filter { $0.state == .worked }.map { ContactCellItem(contact: $0) }
    
    contactsItems.append(ContactCellItem(state: .inProgress))
    contactsItems.append(contentsOf: inProgress)
    contactsItems.append(ContactCellItem(state: .ready))
    contactsItems.append(contentsOf: ready)
    contactsItems.append(ContactCellItem(state: .worked))
    contactsItems.append(contentsOf: worked)
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: 2) {
      Text("CONTACTS").padding().font(Font.custom(boldFontName, size: 17))
      List {
        ForEach(contactsItems) { contactItem in
          if let state = contactItem.state {
            TagView(text: state.rawValue, color: Color(state.color))
              .moveDisabled(true)
          } else if let contact = contactItem.contact {
            ContactRowView(contact: contact)
          }
        }
        .onMove(perform: self.onMove)
      }
    }
    .padding(EdgeInsets(top: 40, leading: 10, bottom: 40, trailing: 40))
  }
    
  private func onMove(source: IndexSet, destination: Int) {
    
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
