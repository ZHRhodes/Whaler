//
//  ContactRowView.swift
//  Whaler
//
//  Created by Zachary Rhodes on 7/19/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import SwiftUI

struct ContactRowView: View {
  let contact: Contact
  
  init(contact: Contact) {
    self.contact = contact
  }
  
  var body: some View {
    HStack {
      Image(uiImage: UIImage(named: "moveDots")!)
      Spacer().frame(width: 20)
      Text(contact.name).font(Font.custom(regularFontName, size: 17))
      Spacer()
      Text(contact.title).font(Font.custom(regularFontName, size: 17))
      Spacer()
      Image(uiImage: UIImage(named: "moveDots")!)
      Spacer().frame(width: 20)
    }
    .foregroundColor(Color.black)
    .padding()
    .background(Color.white)
    .background(RoundedRectangle(cornerRadius: 4)
                .shadow(color: Color(red: 2/256, green: 2/256, blue: 2/256, opacity: 0.21),
                        radius: 6, x: 0, y: 2))
  }
}

struct ContactRowView_Previews: PreviewProvider {
    static var previews: some View {
      ContactRowView(contact: mockContacts[0])
        .preferredColorScheme(.light)
    }
}
