//
//  ReefBubble.swift
//  Reef
//
//  Created by Ira Einbinder on 1/25/22.
//

import Foundation
import RealmSwift
import Combine

class ReefBubble : Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id : ObjectId = ObjectId.generate();
    @Persisted var bubble : String = ""
    @Persisted var userID: ObjectId = ObjectId.generate()
    @Persisted var parentID : ObjectId? = ObjectId.generate()
    @Persisted var questionID: ObjectId = ObjectId.generate()
    @Persisted var dateAdded: Date = Date.now
    @Persisted var sources : List<String> = List<String>()
    
    @Persisted var reefLevel : Int
    
    @Persisted var upvotes: Int
    @Persisted var neutralvotes: Int
    @Persisted var downvotes: Int

    convenience init(bubble: String, userID: ObjectId, parentID: ObjectId?, questionID: ObjectId, reefLevel: Int) {
        self.init()
        self.bubble = bubble
        self.userID = userID
        self.parentID = parentID
        self.questionID = questionID
        self.upvotes = 0
        self.neutralvotes = 0
        self.downvotes = 0
        self.reefLevel = reefLevel
        
//        print("Here!!!")
        
//        Task {
//            do {
//                self.upvotes = try await getUpvotes()
//                self.neutralvotes = try await getNeutralvotes()
//                self.downvotes = try await getDownvotes()
//                print("Upvotes = \(self.upvotes)")
//            } catch {
//                print(error.localizedDescription)
//            }
//        }
    }
    
    func getUpvotes() async throws -> Int {
        let app = App(id: Constants.REALM_APP_ID)
        let user = app.currentUser!
        let realm = try await Realm(configuration: user.configuration(partitionValue: Constants.GLOBAL_PARTITION))
        let upvotes = realm.objects(ReefInteraction.self).where {
            $0.interactionType == "AGREE" && $0.interactedWithBubble == self._id
        }
        return upvotes.count
    }

    func getNeutralvotes() async throws -> Int {
        let app = App(id: Constants.REALM_APP_ID)
        let user = app.currentUser!
        let realm = try await Realm(configuration: user.configuration(partitionValue: Constants.GLOBAL_PARTITION))
        let neutralvotes = realm.objects(ReefInteraction.self).where {
            $0.interactionType == "NEUTRAL" && $0.interactedWithBubble == self._id
        }
        return neutralvotes.count
    }

    func getDownvotes() async throws -> Int {
        let app = App(id: Constants.REALM_APP_ID)
        let user = app.currentUser!
        let realm = try await Realm(configuration: user.configuration(partitionValue: Constants.GLOBAL_PARTITION))
        let downvotes = realm.objects(ReefInteraction.self).where {
            $0.interactionType == "DISAGREE" && $0.interactedWithBubble == self._id
        }
        return downvotes.count
    }
    
    func getSeenBy() async throws -> Int {
        let app = App(id: Constants.REALM_APP_ID)
        let user = app.currentUser!
        let realm = try await Realm(configuration: user.configuration(partitionValue: Constants.GLOBAL_PARTITION))
        let seenby = realm.objects(ReefBubbleSeen.self).where {
            $0.bubbleID == self._id
        }
        return seenby.count
    }
    
    func getSharedBy() async throws -> Int {
        let app = App(id: Constants.REALM_APP_ID)
        let user = app.currentUser!
        let realm = try await Realm(configuration: user.configuration(partitionValue: Constants.GLOBAL_PARTITION))
        let seenby = realm.objects(ReefBubbleShare.self).where {
            $0.bubbleID == self._id
        }
        return seenby.count
    }
    
    func getReplies() async throws -> Int {
        let app = App(id: Constants.REALM_APP_ID)
        let user = app.currentUser!
        let realm = try await Realm(configuration: user.configuration(partitionValue: Constants.GLOBAL_PARTITION))
        let replies = realm.objects(ReefBubble.self).where {
            $0.parentID == self._id
        }
        return replies.count
    }

    func upvote() async throws {
        let app = App(id: Constants.REALM_APP_ID)
        guard let user = app.currentUser else {
            return
        }
            
        if ReefUser.interaction(with: self) != nil {
            return
        }

        
        let realm = try await Realm(configuration: user.configuration(partitionValue: Constants.GLOBAL_PARTITION))
        try realm.write {
            let reefInteraction = ReefInteraction(userID: try! ObjectId(string: user.id),
                                                  interactedWithUserID: self.userID,
                                                  interactedWithBubble: self._id,
                                                  interactionType: "AGREE")
            realm.add(reefInteraction)
        }
    }
    
    func downvote() async throws {
        let app = App(id: Constants.REALM_APP_ID)
        guard let user = app.currentUser else {
            return
        }
            
        if ReefUser.interaction(with: self) != nil {
            return
        }
        
        let realm = try await Realm(configuration: user.configuration(partitionValue: Constants.GLOBAL_PARTITION))
        try realm.write {
            let reefInteraction = ReefInteraction(userID: try! ObjectId(string: user.id),
                                                  interactedWithUserID: self.userID,
                                                  interactedWithBubble: self._id,
                                                  interactionType: "DISAGREE")
            realm.add(reefInteraction)
//            self.downvotes += 1
        }
    }
    
    func neutralvote() async throws {
        let app = App(id: Constants.REALM_APP_ID)
        guard let user = app.currentUser else {
            return
        }
                    
        if ReefUser.interaction(with: self) != nil {
            return
        }
        
        let realm = try await Realm(configuration: user.configuration(partitionValue: Constants.GLOBAL_PARTITION))
        try realm.write {
            let reefInteraction = ReefInteraction(userID: try! ObjectId(string: user.id),
                                                  interactedWithUserID: self.userID,
                                                  interactedWithBubble: self._id,
                                                  interactionType: "NEUTRAL")
            realm.add(reefInteraction)
//            self.neutralvotes += 1
        }
    }
    
//    func userAlreadyInteracted() -> Bool {
//        let app = App(id: Constants.REALM_APP_ID)
//        guard let user = app.currentUser else {
//            return false
//        }
//
//        do {
//            let realm = try Realm(configuration: user.configuration(partitionValue: Constants.GLOBAL_PARTITION))
//            let results = realm.objects(ReefInteraction.self).where {
//                $0.userID == (try! ObjectId(string: user.id)) && $0.interactedWithBubble == self._id
//            }
//
//            return results.count > 0
//        } catch {
//            print(error.localizedDescription)
//        }
//
//        return false
//    }
}

enum ReefInteractionType: String {
    case agree = "AGREE"
    case neutral = "NEUTRAL"
    case disagree = "DISAGREE"
    case none = "NONE"
}

//"upvotes": {
//  "bsonType": "int"
//},
//"downvotes": {
//  "bsonType": "int"
//},
//"neutralvotes": {
//  "bsonType": "long"
//},
