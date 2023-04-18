//
//  ReefBubbleTemp.swift
//  Reef
//
//  Created by Ira Einbinder on 9/3/22.
//

import Foundation

class ReefBubbleTemp : Identifiable, ObservableObject {
    @Published var reefLevel: String!
    @Published var reefText: String!
    
    init(reefLevel: String, reefText: String) {
        self.reefText = reefText
        self.reefLevel = reefLevel
    }
}

class ReefBubblesTemp: ObservableObject {
    @Published var bubbles: [ReefBubbleTemp] = []
    
}
