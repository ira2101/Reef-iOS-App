//
//  ReefQuestion.swift
//  Reef
//
//  Created by Ira Einbinder on 1/26/22.
//

import Foundation
import RealmSwift

class ReefQuestion : Object {
    @Persisted(primaryKey: true) var _id: ObjectId = ObjectId.generate();
    @Persisted var bubble: String = ""
    @Persisted var isVerified: Bool = false
    @Persisted var dateAdded: Date = Date.now
    @Persisted var tags = List<String>()
    @Persisted var tagObjects: List<ReefTag>

    convenience init(bubble: String, tags: [ReefTag]) {
        self.init()
        self.bubble = bubble
        self.tagObjects.append(objectsIn: tags)
    }
    
    func getTags() async throws -> [ReefTag] {
        let app = App(id: Constants.REALM_APP_ID)
        let user = app.currentUser!
        let realm = try await Realm(configuration: user.configuration(partitionValue: Constants.GLOBAL_PARTITION))
        
        let tags = realm.objects(ReefTag.self).where {
            $0.questionID == self._id
        }
        
        return Array(tags)
    }
    
    func getSeenBy() async throws -> Int {
        let app = App(id: Constants.REALM_APP_ID)
        let user = app.currentUser!
        let realm = try await Realm(configuration: user.configuration(partitionValue: Constants.GLOBAL_PARTITION))
        let seenby = realm.objects(ReefQuestionSeen.self).where {
            $0.questionID == self._id
        }
        return seenby.count
    }
    
    func getSharedBy() async throws -> Int {
        let app = App(id: Constants.REALM_APP_ID)
        let user = app.currentUser!
        let realm = try await Realm(configuration: user.configuration(partitionValue: Constants.GLOBAL_PARTITION))
        let seenby = realm.objects(ReefQuestionShare.self).where {
            $0.questionID == self._id
        }
        return seenby.count
    }
    
    func getReplies() async throws -> Int {
        let app = App(id: Constants.REALM_APP_ID)
        let user = app.currentUser!
        let realm = try await Realm(configuration: user.configuration(partitionValue: Constants.GLOBAL_PARTITION))
        let replies = realm.objects(ReefBubble.self).where {
            $0.questionID == self._id
        }
        return replies.count
    }
    
    
    
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
