//
//  ReefFollowing.swift
//  Reef
//
//  Created by Ira Einbinder on 2/1/22.
//

import Foundation
import RealmSwift

class ReefFollowing : Object {
    @Persisted(primaryKey: true) var _id: ObjectId = ObjectId.generate();
    @Persisted var userId: ObjectId = ObjectId.generate()
    @Persisted var followingId: ObjectId = ObjectId.generate();
    @Persisted var dateAdded: Date = Date.now

    convenience init(followingId: ObjectId, userId: ObjectId) {
        self.init()
        self.followingId = followingId
        self.userId = userId
    }

}
