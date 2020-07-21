//
//  ContactsTableView.swift
//  Whaler
//
//  Created by Zachary Rhodes on 7/19/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import SwiftUI

var mockContacts: [Contact] = [
  Contact(name: "Rita Book", title: "Design Director", state: WorkState.inProgress),
  Contact(name: "Stanley Knife", title: "VP of Design", state: WorkState.inProgress),
  Contact(name: "Rita Book", title: "Design Director", state: WorkState.ready),
  Contact(name: "Stanley Knife", title: "VP of Design", state: WorkState.ready),
  Contact(name: "Rita Book", title: "Design Director", state: WorkState.worked),
  Contact(name: "Box Shepherd", title: "VP of Design", state: WorkState.worked),
  Contact(name: "Dita Dernbern", title: "Design Director", state: WorkState.inProgress),
  Contact(name: "Carlton Smockles", title: "VP of Design", state: WorkState.inProgress),
  Contact(name: "Brian Bilshford", title: "Design Director", state: WorkState.ready),
  Contact(name: "Jose Romirez", title: "VP of Design", state: WorkState.ready),
  Contact(name: "John Johnson", title: "Design Director", state: WorkState.worked),
  Contact(name: "Ryan Rickles", title: "VP of Design", state: WorkState.worked),
]

struct ContactsTableView: View {
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
            ForEach(mockContacts.filter { $0.state == state}) { contact in
              ContactRowView(contact: contact).background(Color.white)
            }
            .onMove(perform: onMove)
          }
        }
      }
    }
  }
  
  private func onMove(source: IndexSet, destination: Int) {
    
  }
}

struct ContactsTableView_Previews: PreviewProvider {
  static var previews: some View {
    ContactsTableView()
      .frame(width: 800, height: 900.0)
  }
}
