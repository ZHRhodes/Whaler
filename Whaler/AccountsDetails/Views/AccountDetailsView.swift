//
//  AccountDetailsView.swift
//  Whaler
//
//  Created by Zachary Rhodes on 7/20/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import SwiftUI

struct AccountDetailsView: View {
  let account: Account
  
//  let tempContacts: [ContactCellItem] = [
//    ContactCellItem(state: WorkState.inProgress),
//    ContactCellItem(contact: Contact(dictionary: ["name": "Rita Book11", "title": "Director of Design"])),
//    ContactCellItem(contact: Contact(dictionary: ["name": "Rita Book22", "title": "Director of Design"])),
//                    ContactCellItem(contact: Contact(dictionary: ["name": "Rita Book99", "title": "Director of Design"])),
//    ContactCellItem(state: WorkState.ready),
//    ContactCellItem(contact: Contact(dictionary: ["name": "Rita Book33", "title": "Director of Design"])),
//    ContactCellItem(contact: Contact(dictionary: ["name": "Rita Book44", "title": "Director of Design"])),
//    ContactCellItem(contact: Contact(dictionary: ["name": "Rita Book88", "title": "Director of Design"])),
//  ]
  
  @Environment(\.presentationMode) var presentation
  
  var body: some View {
    GeometryReader { metrics in
      HStack {
        VStack {
          CompanyInfoView(account: self.account)
            .frame(height: metrics.size.height * 0.3)
          NotesView(initialState: "")
        }
          .frame(width: metrics.size.width * 0.6)
        Rectangle()
          .fill(Color(red: 0, green: 0, blue: 0, opacity: 0.2))
          .frame(width: 1)
        ContactsTableView(contacts: self.account.contacts)
      }
//      .navigationBarItems(leading: backButton)
    }
  }
  
  var backButton: some View {
    Button("<") {
      presentation.wrappedValue.dismiss()
    }
  }
}

struct AccountDetailsView_Previews: PreviewProvider {
    static var previews: some View {
      let account = Account(dictionary: ["name": "Salesforce", "website": "salesforce.com", "phone": "555-555-5555"])
      return AccountDetailsView(account: account)
    }
}
