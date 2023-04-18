//
//  ReefQuestionFlag.swift
//  Reef
//
//  Created by Ira Einbinder on 1/26/23.
//

import Foundation
import RealmSwift

class ReefQuestionFlag : Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id : ObjectId = ObjectId.generate();
    @Persisted var questionID: ObjectId
    @Persisted var userID : ObjectId
    @Persisted var reason: String
    @Persisted var timestamp: Date = Date.now
    
    convenience init(questionID: ObjectId, userID: ObjectId, reason: String) {
        self.init()
        self.questionID = questionID
        self.userID = userID
        self.reason = reason
    }
}
