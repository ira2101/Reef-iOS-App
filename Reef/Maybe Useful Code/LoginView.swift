//
//  LoginView.swift
//  Reef
//
//  Created by Ira Einbinder on 8/25/22.
//

import SwiftUI
import RealmSwift
import Combine

//@main
//struct mainMain: SwiftUI.App {
//    var body: some Scene {
//       WindowGroup {
//             LoginView()
//       }
//    }
//}

struct LoginView: View {
    class AppInformation: ObservableObject {
        var app: RealmSwift.App
        var currentUser: RealmSwift.User?
        
        init() {
            app = App(id: Constants.REALM_APP_ID)
            currentUser = app.currentUser
        }
    }
    
    enum FocusType: Hashable {
        case email
        case password
    }
    
    @State var email: String = ""
    @State var password: String = ""
    
    @State var backgroundColor: Color = .white
    
    @State var isLogginError: Bool = false
    @State var isLoggedIn: Bool = false
    
    @State var goToRegisterView: Bool = false
    
    @FocusState private var isFocused: FocusType?
    
    @StateObject var appInformation: AppInformation = AppInformation()
    
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer(minLength: 50)
                
                Text("Reef")
                    .font(.largeTitle.bold())
                
                VStack {
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
                }
                .padding(.horizontal)
                
                if isLogginError {
                    Text("Error logging in")
                        .foregroundColor(.red)
                }
                
                if goToRegisterView {
                    NavigationLink(destination: RegisterView(), isActive: $goToRegisterView) {
                    }
                }
                
                HStack {
                    Button(action: {
                        Task {
                            await login(email: email, password: password)
                        }
                    }) {
                        Text("Login")
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(45)
                    
                    
                    Button(action: {
                        goToRegisterView = true
                    }) {
                        Text("Register")
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(45)
                    
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .padding(.horizontal)
            }
            .background(backgroundColor)
        }
        .onAppear(perform: {
            isLoggedIn = appInformation.currentUser != nil
        })
        .fullScreenCover(isPresented: $isLoggedIn, onDismiss: nil) {
//            ConversationSwiftUIView()
//            ConversationView()
        }
        .environmentObject(appInformation)
    }
    
    private func login(email: String, password: String) async {
        if email.isEmpty || password.isEmpty {
            return
        }
        
        let app = App(id: Constants.REALM_APP_ID)
        backgroundColor = .purple
        
        do {
            _ = try await app.login(credentials: .emailPassword(email: email, password: password))
            
            isLoggedIn = true
            backgroundColor = .green
        } catch {
            isLogginError = true
            print(error)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
