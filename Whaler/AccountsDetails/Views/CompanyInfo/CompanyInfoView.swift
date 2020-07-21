//
//  CompanyInfoView.swift
//  Whaler
//
//  Created by Zachary Rhodes on 7/19/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import SwiftUI

struct CompanyInfoView: View {
  let account: Account
  
  var body: some View {
    VStack(alignment: .leading) {
      CompanyInfoHeaderView(account: account)
      CompanyInfoValuesView(account: account)
    }
    .padding()
  }
}

struct CompanyInfoView_Previews: PreviewProvider {
  static var previews: some View {
    let account = Account(dictionary: ["name": "Salesforce", "website": "salesforce.com", "phone": "555-555-5555"])
    return CompanyInfoView(account: account)
  }
}
