//
//  CompanyInfoValuesView.swift
//  Whaler
//
//  Created by Zachary Rhodes on 7/19/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import SwiftUI

struct CompanyInfoValuesView: View {
  let account: Account
  
  var body: some View {
    VStack(alignment: .leading, spacing: 20) {
      ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: 60) {
          TitleValueView(title: "INDUSTRY", value: account.industry ?? "N/A")
          Spacer()
          TitleValueView(title: "HEADCOUNT", value: account.employees ?? "N/A")
          Spacer()
          TitleValueView(title: "REVENUE", value: account.annualRevenue ?? "N/A")
          Spacer()
          TitleValueView(title: "CITY", value: account.billingCity ?? "N/A")
          Spacer()
          TitleValueView(title: "STATE", value: account.billingState ?? "N/A")
        }
      }
      TitleValueView(title: "DESCRIPTION", value: account.accountDescription ?? "N/A")
    }
    .padding()
    .background(Color.white)
    .background(RoundedRectangle(cornerRadius: 4)
                .shadow(color: Color(red: 2/256, green: 2/256, blue: 2/256, opacity: 0.21),
                        radius: 6, x: 0, y: 2))
  }
}

struct CompanyInfoValues_Previews: PreviewProvider {
  static var previews: some View {
    let account = Account(dictionary: ["name": "Salesforce", "website": "salesforce.com", "phone": "555-555-5555"])
    return CompanyInfoValuesView(account: account)
  }
}
