//
//  SwiftUIView.swift
//  Reef
//
//  Created by Ira Einbinder on 1/18/22.
//

import SwiftUI
import UIKit
import RealmSwift

struct Animal : Identifiable {
    let name : String
    let id = UUID()
}

struct ConversationHeader: View {
    struct TypeOfBubble: View {
        private var name: String
        init(name: String) {
            self.name = name
        }
        
        var body: some View {
            Button(action: pressed) {
                Text(self.name)
                    .foregroundColor(.black)
                    .font(.system(size: 12))
                    .fontWeight(.semibold)
                    .padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5))
            }
            .frame(maxWidth: .infinity)
        }
    }
    
    var body: some View {
        HStack(spacing: 0) {
            TypeOfBubble(name: "Top Bubbles")
            TypeOfBubble(name: "Recent Bubbles")
            TypeOfBubble(name: "My Bubbles")
        }
    }
}

struct ConversationSwiftUIView: View {
    @ObservedResults( ReefBubble.self, keyPaths: ["dateAdded"]) var data: Results<ReefBubble>
    
    //    let data = [
    //        Animal(name: "The apple ate the tree and this is the only tesdf;sdfjlksjdhfljsdhvlljhvlsdkj lsdljsdkjhsd kjhsd jdhks nt that I see. The apple ate the tree and this is the only tent that I see.e the tree and this is the only tent that I see.e the tree and this is the only tent that I see."),
    //        Animal(name: "Chicken"),
    //        Animal(name: "Chicken"),
    //        Animal(name: "Chicken"),
    //        Animal(name: "Chicken"),
    //        Animal(name: "Chicken"),
    //        Animal(name: "Chicken"),
    //        Animal(name: "Chicken"),
    //        Animal(name: "Chicken"),
    //        Animal(name: "Chicken"),
    //        Animal(name: "Chicken"),
    //        Animal(name: "Chicken"),
    //        Animal(name: "Chicken"),
    //        Animal(name: "Chicken"),
    //        Animal(name: "Chicken"),
    //        Animal(name: "Duck")
    //    ]
    
    let color1 = Color(.sRGB, red: 240 / 255, green: 189 / 255, blue: 113 / 255, opacity: 1)
    let color2 = Color(.sRGB, red: 219 / 255, green: 64 / 255, blue: 64 / 255, opacity: 1)
    let color3 = Color(.sRGB, red: 42 / 255, green: 156 / 255, blue: 65 / 255, opacity: 1)
    
    @State private var response : String = ""
    
    var body: some View {
        VStack {
            ConversationHeader()
            
            List {
                ForEach(self.data) { bubble in
                    HStack() {
                        VStack(alignment: .leading) {
                            Text("Reef lvl. 1")
                                .font(.system(size: 16))
                                .bold()
                            
                            ScrollView {
                                Text(bubble.bubble)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(EdgeInsets(top: 5, leading: 0, bottom: 0, trailing: 0))
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            .frame(maxHeight: 150)
                            
                            
                            HStack(spacing: 0) {
                                HStack(spacing: 0) {
                                    Label("Ira", systemImage: "message")
                                        .frame(width: 30, alignment: .leading)
                                        .padding(0)
                                        .foregroundColor(.black)
                                    Label("", systemImage: "flag")
                                        .frame(width: 30, alignment: .leading)
                                        .foregroundColor(.black)
                                    Label("", systemImage: "square.and.arrow.up")
                                        .frame(width: 30, alignment: .leading)
                                        .foregroundColor(.black)
                                }
                                
                                Button(action: pressed) {
                                    Text("Disagree")
                                        .foregroundColor(.white)
                                        .font(.system(size: 12))
                                        .fontWeight(.semibold)
                                        .padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5))
                                }
                                .frame(minWidth: 80, maxWidth: 80, maxHeight: .infinity)
                                .background(
                                    LinearGradient(gradient: Gradient(colors: [.red, color2, .red]), startPoint: .top, endPoint: .bottom)
                                )
                                .buttonStyle(DefaultButtonStyle())
                                .cornerRadius(5, corners: [.topLeft, .bottomLeft])
                                Button(action: pressed) {
                                    Text("Neutral")
                                        .foregroundColor(.white)
                                        .font(.system(size: 12))
                                        .fontWeight(.semibold)
                                        .padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5))
                                }
                                .frame(minWidth: 100, maxWidth: 100, maxHeight: .infinity)
                                .background(
                                    LinearGradient(gradient: Gradient(colors: [.orange, color1, .orange]), startPoint: .top, endPoint: .bottom)
                                )
                                .buttonStyle(DefaultButtonStyle())
                                Button(action: pressed) {
                                    Text("Agree")
                                        .foregroundColor(.white)
                                        .font(.system(size: 12))
                                        .fontWeight(.semibold)
                                        .padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5))
                                }
                                .frame(minWidth: 80, maxWidth: 80, maxHeight: .infinity)
                                .background(
                                    LinearGradient(gradient: Gradient(colors: [.green, color3, .green]), startPoint: .top, endPoint: .bottom)
                                )
                                .buttonStyle(DefaultButtonStyle())
                                .cornerRadius(5, corners: [.topRight, .bottomRight])
                            }
                            .frame(maxWidth: .infinity, minHeight: 30, maxHeight:30, alignment: .trailing)
                            
                            
                        }
                        .buttonStyle(DefaultButtonStyle())
                        
                    }
                }
            }
            .listStyle(PlainListStyle())
        }
    }
}

struct ConversationSwiftUIView_Previews: PreviewProvider {
    @State static var isLoggedIn: Bool = false
    static var count: Int = 1
    
    @AsyncOpen(appId: Constants.REALM_APP_ID,
               partitionValue: Constants.GLOBAL_PARTITION,
               timeout: 10000) static var asyncOpen
    
    static var previews: some View {
        switch asyncOpen {
        case .open(_):
            ProgressView("Open")
   
        case .connecting:
            let cat = { () -> Int in
                count += 1
                return count
            }
            
           ProgressView("Connecting " + cat().description)
        case .waitingForUser:
            if isLoggedIn {
                ConversationSwiftUIView()
                    .previewDevice("iPhone 13 Pro")
                    .previewInterfaceOrientation(.portrait)
                    .environment(\.realmConfiguration, App(id: Constants.REALM_APP_ID).currentUser!.configuration(partitionValue: Constants.GLOBAL_PARTITION))
            } else {
                ProgressView()
                    .onAppear {
                        let app = App(id: Constants.REALM_APP_ID)
                        app.login(credentials: Credentials.emailPassword(email: Constants.EMAIL, password: Constants.PASSWORD)) { result in
                            switch result {
                            case .success(_):
                                isLoggedIn = true
                            case .failure(let error):
                                print(error)
                            }
                        }
                    }
            }
        case .progress(_):
            ProgressView("Progress")
        case .error(_):
            ConversationSwiftUIView()
                .previewDevice("iPhone 13 Pro")
                .previewInterfaceOrientation(.portrait)
                .background(Color.purple)
        }

        //            .environment(\.realmConfiguration, configuration)
        //            .environment(\.partitionValue, Constants.GLOBAL_PARTITION)
        
    }
}

func pressed() {
    print("Pressed")
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {
    
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
