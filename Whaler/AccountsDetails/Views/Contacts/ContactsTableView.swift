//
//  ContactsTableView.swift
//  Whaler
//
//  Created by Zachary Rhodes on 7/19/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import SwiftUI

struct ContactsTableView: View {
  let contacts: [Contact]
  
  var body: some View {
    VStack(alignment: .leading, spacing: 2) {
      Text("CONTACTS").padding().font(Font.custom(boldFontName, size: 17))
      List {
        ForEach(WorkState.allCases) { state in
          Section(header:
                    VStack {
                      TagView(text: state.rawValue,
                              color: Color(state.color))
                      Spacer().frame(height: 10)
                    },
                  footer: Rectangle().fill(Color.white)
          ) {
            ForEach(contacts.filter { $0.state == state}) { contact in
              ContactRowView(contact: contact).background(Color.white)
            }
            .onMove(perform: onMove)
          }
        }
      }
    }
    .padding(EdgeInsets(top: 40, leading: 10, bottom: 40, trailing: 40))
  }
  
  private func onMove(source: IndexSet, destination: Int) {
    
  }
}

struct ContactsTableView_Previews: PreviewProvider {
  static var previews: some View {
    ContactsTableView(contacts: mockContacts)
      .frame(width: 800, height: 900.0)
  }
}

let mockContacts = [
  Contact(dictionary: ["name": "Rita Book", "title": "Director of Design"])
]
