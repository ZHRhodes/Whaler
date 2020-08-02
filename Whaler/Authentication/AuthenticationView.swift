//
//  AuthenticationView.swift
//  Whaler
//
//  Created by Zachary Rhodes on 8/2/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import SwiftUI

struct AuthenticationView: View {
    var body: some View {
      GeometryReader { geometry in
        HStack {
          Image("loginImage")
            .resizable()
            .scaledToFill()
            .frame(width: geometry.size.width/2)
          HStack {
            Spacer().frame(width: geometry.size.width/8)
            VStack {
              ZStack {
                VStack(alignment: .leading) {
                  Image("whalerLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                  Spacer().frame(height: 26)
                  Text("SIGN IN").font(Font.custom(boldFontName, size: 25))
                  Spacer().frame(height: 26)
                  Text("Email")
                  Spacer().frame(height: 50)
                  Text("Password")
                  Spacer().frame(height: 60)
                  Button(action: {
                    
                  }) {
                    Text("SIGN IN")
                      .padding()
                      .frame(maxWidth: .infinity)
                      .border(Color(.accent1))
                      .foregroundColor(.black)
                  }
                  .overlay(
                    RoundedRectangle(cornerRadius: 4)
                      .stroke(Color(.accent1), lineWidth: 2)
                  )
                }
              }
            }
            Spacer().frame(width: geometry.size.width/8)
          }
        }
      }
    }
}

struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView()
    }
}
