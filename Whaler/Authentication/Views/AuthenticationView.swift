//
//  AuthenticationView.swift
//  Whaler
//
//  Created by Zachary Rhodes on 8/2/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import SwiftUI

protocol AuthenticationViewDelegate: class {
  func signInTapped(email: String, password: String)
}

struct AuthenticationView: View {
  weak var delegate: AuthenticationViewDelegate?
  weak var textFieldDelegate: TextFieldDelegate?
  @ObservedObject var viewModel: ViewModel
  //width: 2136, height: 1217)
  var body: some View {
    GeometryReader { geometry in
      HStack {
        HStack {
          Spacer().frame(width: geometry.size.width/10)
          VStack {
            ZStack {
              VStack(alignment: .leading) {
                HStack {
                  Image("tinyWhale").renderingMode(.template).foregroundColor(Color(.primaryText))
                  Spacer().frame(width: 17)
                  Text("WHALER")
                    .font(Font.custom(boldFontName, size: 29))
                }.frame(maxWidth: .infinity, alignment: .center)
                Spacer().frame(height: geometry.size.height/6)
                Text("Sign In").font(Font.custom(boldFontName, size: 31))
                Spacer().frame(height: geometry.size.height * 0.025)
                VStack {
                  CommonTextFieldRepresentable(initialText: "Email", isSecureText: false, textFieldDelegate: textFieldDelegate, text: $viewModel.email).frame(height: 72)
                  Spacer().frame(height: geometry.size.height * 0.042)
                  CommonTextFieldRepresentable(initialText: "Password", isSecureText: true, textFieldDelegate: textFieldDelegate, text: $viewModel.password).frame(height: 72)
                }
                Spacer().frame(height: geometry.size.height * 0.05)
                Button(action: {
                  delegate?.signInTapped(email: viewModel.email, password: viewModel.password)
                }) {
                  Text("Sign In")
                    .padding()
                    .font(Font.custom(regularFontName, size: 18))
                    .frame(maxWidth: .infinity)
                    .border(Color(.primaryText))
                    .foregroundColor(Color(.primaryBackground))
                    .foregroundColor(.black)
                    .background(Color(.primaryText))
                }
                .overlay(
                  RoundedRectangle(cornerRadius: 4)
                    .stroke(Color(.primaryText), lineWidth: 2)
                )
                Text(viewModel.errorMessage)
                  .font(Font.custom(regularFontName, size: 16))
                  .foregroundColor(Color(.brandRedDark))
                Spacer().frame(height: geometry.size.height * 0.23)
                Text("Treat salespeople right.")
                  .font(Font.custom(semiboldFontName, size: 21))
                  .frame(maxWidth: .infinity, alignment: .center)
              }
            }
          }       
          Spacer().frame(width: geometry.size.width/8)
        }
        Image("loginImage")
          .resizable()
          .scaledToFill()
          .frame(width: geometry.size.width/2)
      }.edgesIgnoringSafeArea(.all)
    }
    .background(Color(.primaryBackground))
    .edgesIgnoringSafeArea(.all)
  }
}

struct AuthenticationView_Previews: PreviewProvider {
  static var previews: some View {
    AuthenticationView(viewModel: AuthenticationView.ViewModel())
  }
}

extension AuthenticationView {
  class ViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage = ""
  }
}
