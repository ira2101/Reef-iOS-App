//
//  RegisterView.swift
//  Reef
//
//  Created by Ira Einbinder on 8/25/22.
//

import SwiftUI
import RealmSwift

struct RegisterView: View {
    enum FocusType: Hashable {
        case email
        case password
    }
        
    @State private var email: String = ""
    @State private var password: String = ""
    
    @State private var isLoggedIn: Bool = false
    
    @FocusState private var isFocused: FocusType?
    
    var body: some View {

        
        GeometryReader { reader in
            VStack {
                Text("Register")
                    .font(.largeTitle.bold())
                
                Button("Sign In with Google") {}
                    .foregroundColor(Color.white)
                    .padding()
                    .frame(width: reader.size.width * 0.8, alignment: .center)
                    .background(Color.red.opacity(0.8))
                
                Button("Sign In with Apple") {}
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: reader.size.width * 0.8, alignment: .center)
                    .background(Color.black)
                
                Text("or")
                
                
                TextField("Email", text: $email)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.gray.opacity(0.5))
                    .cornerRadius(45)
                    .focused($isFocused, equals: .email)
                    .onTapGesture {
                        isFocused = .email
                    }
                
                TextField("Password", text: $password)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.gray.opacity(0.5))
                    .cornerRadius(45)
                    .focused($isFocused, equals: .password)
                    .onTapGesture {
                        isFocused = .password
                    }
                
                Button("Register") {
                    Task {
                        await register(email: email, password: password)
                    }
                }
                .padding()
                .foregroundColor(.white)
                .background(.blue)
                .cornerRadius(10)
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding(EdgeInsets(top: 50, leading: 0, bottom: 0, trailing: 0))
        }
        .padding(.horizontal)
        .fullScreenCover(isPresented: $isLoggedIn, onDismiss: nil) {
            ConversationSwiftUIView()
        }
    }
    
    private func register(email: String, password: String) async {
        if email.isEmpty || password.isEmpty {
            return
        }
        
        let app = App(id: Constants.REALM_APP_ID)
        
        do {
            try await app.emailPasswordAuth.registerUser(email: email, password: password)
            isLoggedIn = true
        } catch {
            print("Login Error:\n")
            print(error.localizedDescription)
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
