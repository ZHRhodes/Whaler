//
//  TitleValueView.swift
//  Whaler
//
//  Created by Zachary Rhodes on 7/17/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import SwiftUI

struct TitleValueView: View {
  let title: String
  let value: String
    
  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      Text(title)
        .font(Font.custom(boldFontName, size: 15))
        .foregroundColor(Color.init(red: 188/255, green: 188/255, blue: 188/255))
      Text(value)
        .font(Font.custom(regularFontName, size: 19))
    }
    .foregroundColor(Color.black)
    .background(Color.white)
  }
}

struct TitleValueView_Previews: PreviewProvider {
    static var previews: some View {
      TitleValueView(title: "Industry", value: "Marketing")
        
    }
}
