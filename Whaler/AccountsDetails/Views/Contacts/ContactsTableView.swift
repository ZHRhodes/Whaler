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
    var contactGrouper: Grouper<WorkState, Contact>
    
    init(contactGrouper: Grouper<WorkState, Contact>) {
      self.contactGrouper = contactGrouper
    }
  }
  
  private let viewModel: ViewModel
  
  init(contactGrouper: Grouper<WorkState, Contact>) {
    viewModel = ViewModel(contactGrouper: contactGrouper)
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: 2) {
      Text("CONTACTS").padding().font(Font.custom(boldFontName, size: 17))
      ContactsTableViewControllerRepresentable(contactGrouper: viewModel.contactGrouper)
    }
    .padding(EdgeInsets(top: 40, leading: 10, bottom: 40, trailing: 40))
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
