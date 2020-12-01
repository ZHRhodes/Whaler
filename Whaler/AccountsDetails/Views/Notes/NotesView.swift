//
//  NotesView.swift
//  Whaler
//
//  Created by Zachary Rhodes on 7/20/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import SwiftUI

struct NotesView: View {
  let initialState: String
  let editor = RichTextEditor()
  private(set) var editorView: NoteEditorRepresentable!
  
  init(initialState: String) {
    self.initialState = initialState
    editorView = NoteEditorRepresentable()
  }
  
  var body: some View {
    VStack(alignment: .leading) {
      Text("NOTES")
        .padding(EdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 10))
        .font(Font.custom(boldFontName, size: 17))
      ZStack {
        VStack {
          editorView
            .padding()
            .onAppear(perform: {
              Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false, block: { (_) in
//                editor.restoreEditor(to: initialState)
              })
            })
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
    NotesView(initialState: #"{"document":[{"text":[{"type":"string","attributes":{},"string":"test"},{"type":"string","attributes":{"blockBreak":true},"string":"\\n"}],"attributes":["heading1"]}],"selectedRange":[0,4]}"#)
      .frame(width: 600, height: 400)
  }
}
