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
  
  var body: some View {
    VStack {
      CompanyInfoView(account: account)
      HStack {
        ContactsTableView(contacts: account.contacts)
        NotesView(text: "")
      }
    }
  }
}

struct AccountDetailsView_Previews: PreviewProvider {
    static var previews: some View {
      let account = Account(dictionary: ["name": "Salesforce", "website": "salesforce.com", "phone": "555-555-5555"])
      return AccountDetailsView(account: account)
    }
}
