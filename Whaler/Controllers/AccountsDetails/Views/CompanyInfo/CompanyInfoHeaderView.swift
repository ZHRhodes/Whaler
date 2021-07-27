//
//  CompanyInfoHeaderView.swift
//  Whaler
//
//  Created by Zachary Rhodes on 7/17/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import SwiftUI

struct CompanyInfoHeaderView: View {
  let account: Account
  
  var body: some View {
    VStack(alignment: .leading, spacing: 10) {
      Text(account.name.uppercased()).font(Font.custom(boldFontName, size: 25))
        .foregroundColor(Color.black)
        .font(Font.custom(boldFontName, size: 17))
      HStack(spacing: 10) {
        Text(account.website ?? "").font(Font.custom(regularFontName, size: 17))
        Text("|")
        Text(account.phone ?? "").font(Font.custom(regularFontName, size: 17))
      }
      .foregroundColor(Color.black)
    }
  }
}

struct CompanyInfoHeaderView_Previews: PreviewProvider {
  static var previews: some View {
    let account = Account(dictionary: ["name": "Salesforce", "website": "salesforce.com", "phone": "555-555-5555"])
    return CompanyInfoHeaderView(account: account)
  }
}
