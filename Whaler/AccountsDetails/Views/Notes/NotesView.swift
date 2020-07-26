//
//  NotesView.swift
//  Whaler
//
//  Created by Zachary Rhodes on 7/20/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import SwiftUI

struct NotesView: View {
  @State var text: String
  
  var body: some View {
    VStack(alignment: .leading) {
      Text("NOTES")
        .padding(EdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 10))
        .font(Font.custom(boldFontName, size: 17))
      ZStack {
        VStack {
          RichTextEditorRepresentable()
            .padding()
        }
      }
      .background(Color.white)
      .background(RoundedRectangle(cornerRadius: 4)
                    .shadow(color: Color(red: 2/256, green: 2/256, blue: 2/256, opacity: 0.21),
                            radius: 6, x: 0, y: 2))
    }
    .foregroundColor(Color.black)
    .padding(EdgeInsets(top: 10, leading: 40, bottom: 40, trailing: 40))
  }
}

struct NotesView_Previews: PreviewProvider {
  static var previews: some View {
    NotesView(text: "This is a test")
      .frame(width: 600, height: 400)
  }
}
