//
//  HomeView.swift
//  Reef
//
//  Created by Ira Einbinder on 8/31/22.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack {
            Text("Interesting Conversations")
            List {
                Text("High schoolers are getting more fucked up")
                    .lineLimit(2)
                
                Text("We still can't predict earthquakes")
                    .lineLimit(2)
            }
            
            Text("Trending Conversations")
            List {
                Text("What the heck happened today.")
                Text("How can we fix the weather today.")
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
