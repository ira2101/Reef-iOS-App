//
//  ReefDraft.swift
//  Reef
//
//  Created by Ira Einbinder on 2/18/22.
//

import Foundation
import RealmSwift

class ReefDraft : Object {
    @Persisted(primaryKey: true) var _id : ObjectId = ObjectId.generate()
    @Persisted var bubble : String = ""
    @Persisted var userID: ObjectId = ObjectId.generate()
    @Persisted var parentID : ObjectId? = ObjectId.generate()
    @Persisted var questionID: ObjectId? = ObjectId.generate()
    @Persisted var dateAdded: Date = Date.now
    @Persisted var sources : List<String> = List<String>()
    @Persisted var tags : List<String> = List<String>()

    convenience init(bubble: String, userID: ObjectId, parentID: ObjectId?, questionID: ObjectId?) {
        self.init()
        self.bubble = bubble
        self.userID = userID
        self.parentID = parentID
        self.questionID = questionID
    }
    
//    override static func primaryKey() -> String? {
//        return "_id";
//    }
    
    func writeToDatabase() async throws {
        let app = App(id: Constants.REALM_APP_ID)
        guard let user = app.currentUser else {
            return
        }
        
        let realm = try await Realm(configuration: user.configuration(partitionValue: user.id))
        try realm.write {
            realm.add(self)
        }
    }
}
