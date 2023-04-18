//
//  ReefTag.swift
//  Reef
//
//  Created by Ira Einbinder on 1/31/22.
//

import Foundation
import RealmSwift

class ReefTag : Object {
    @Persisted(primaryKey: true) var _id: ObjectId = ObjectId.generate();
    @Persisted var tag: String = ""
    @Persisted var isVerified: Bool = false
    @Persisted var dateAdded: Date = Date.now
    
    @Persisted var uniqueTagID: ObjectId
    @Persisted var questionID: ObjectId
    @Persisted var userID: ObjectId
    @Persisted var uniqueTag: ReefUniqueTag?

    convenience init(tag: String, question: ReefQuestion) async throws {
        self.init()
        
        let app = App(id: Constants.REALM_APP_ID)
        let user = app.currentUser!
        let realm = try await Realm(configuration: user.configuration(partitionValue: Constants.GLOBAL_PARTITION))
        
        self.tag = tag
        self.userID = try! ObjectId(string: user.id)
        self.questionID = question._id
                
        // Try to find a unique tag with the same string
        let uniqueTag: ReefUniqueTag? = realm.objects(ReefUniqueTag.self).where {
            $0.tag == self.tag.lowercased()
        }.first
        
        // If the unique tag already exists, then takes its id. Otherwise, we need to
        // create a new unique tag for that string
        if uniqueTag != nil {
            self.uniqueTagID = uniqueTag!._id
            self.uniqueTag = uniqueTag!
        } else {
            let uniqueTag = ReefUniqueTag(tag: self.tag)
            try await ReefIO.writeToDatabase(objs: [uniqueTag])
            self.uniqueTagID = uniqueTag._id
            self.uniqueTag = uniqueTag
        }
    }
}
