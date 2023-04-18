//
//  ConversationView.swift
//  Reef
//
//  Created by Ira Einbinder on 9/3/22.
//

import SwiftUI
import RealmSwift



struct ConversationVieww: View {
    //    @ObservedResults( ReefBubble.self, keyPaths: ["dateAdded"]) var bubbles: Results<ReefBubble>
    
    //    @ObservedResults var bubbles: [ReefBubble]
    
    @ObservedObject var bubbles: ReefBubblesTemp = ReefBubblesTemp()
    
    var body: some View {
        VStack {
            Text("How can we solve climate change?")
            Text("Most Thoughtful Contributions")
                .font(.system(size: 18).bold())
            
            List {
                ForEach(bubbles.bubbles) { bubble in
                    VStack(alignment: .leading) {
                        
                        Text(bubble.reefLevel)
                            .bold()
                        
                        (Text("Approval: ") +
                         Text("98.5")
                            .foregroundColor(.green)
                            .bold())
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text(bubble.reefText)
                        
                        
                        Spacer(minLength: 5)
                            Button("Sources") {
                                
                            }
                            .buttonStyle(PlainButtonStyle())
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            
                    }
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.leading)

                }
            }
            .listStyle(.plain)
        }
        .onAppear {
            let alphabet = "abcdefghijklmnopqrstuvwxyz"
            for _ in 0..<10 {
                let randomVal = arc4random_uniform(100)
                var randomText = ""
                for _ in 0..<randomVal {
                    randomText += String(alphabet.randomElement()!)
                }
                
                bubbles.bubbles.append(ReefBubbleTemp(reefLevel: "Reef Level", reefText: randomText))
            }
        }
    }
    
}

struct ConversationView_Previews: PreviewProvider {
    static var previews: some View {
        //        LoginView()
        //            .previewDevice("iPhone 13")
        ConversationVieww()
    }
}
