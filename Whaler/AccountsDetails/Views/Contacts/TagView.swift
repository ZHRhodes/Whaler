//
//  TagView.swift
//  Whaler
//
//  Created by Zachary Rhodes on 7/19/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import SwiftUI

struct TagView: View {
  let text: String
  let color: Color
  
  var body: some View {
    Text(text)
      .font(Font.custom(boldFontName, size: 17))
      .padding(EdgeInsets(top: 7, leading: 7, bottom: 7, trailing: 7))
      .background(color)
      .foregroundColor(.white)
      .cornerRadius(2)
  }
}

struct TagView_Previews: PreviewProvider {
    static var previews: some View {
      TagView(text: WorkState.inProgress.rawValue, color: Color(.inProgress))
    }
}
