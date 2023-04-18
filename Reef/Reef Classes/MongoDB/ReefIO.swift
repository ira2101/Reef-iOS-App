//
//  ReefIO.swift
//  Reef
//
//  Created by Ira Einbinder on 1/31/22.
//

import Foundation
import RealmSwift

class ReefIO {
    static func writeToDatabase(objs: [Object], partition: String = Constants.GLOBAL_PARTITION) async throws {
        let app = App(id: Constants.REALM_APP_ID)
        guard let user = app.currentUser else {
            return
        }
        
        let realm = try await Realm(configuration: user.configuration(partitionValue: partition))
        try realm.write {
            realm.add(objs)
        }
    }
    
    static func updateToDatabase(objs: [Object], partition: String = Constants.GLOBAL_PARTITION) async throws {
        let app = App(id: Constants.REALM_APP_ID)
        guard let user = app.currentUser else {
            return
        }
        
        let realm = try await Realm(configuration: user.configuration(partitionValue: partition))
        try realm.write {
            realm.add(objs, update: .modified)
        }
    }
    
    static func deleteFromDatabase(objs: [Object], partition: String = Constants.GLOBAL_PARTITION) async throws {
        let app = App(id: Constants.REALM_APP_ID)
        guard let user = app.currentUser else {
            return
        }
        
        let realm = try await Realm(configuration: user.configuration(partitionValue: partition))
        try realm.write {
            realm.delete(objs)
        }
    }
    
    static func getCurrentUser() -> User? {
        let app = App(id: Constants.REALM_APP_ID)
        return app.currentUser
    }
    
    static func getRealm(with partition: String = Constants.GLOBAL_PARTITION) -> Realm? {
        let app = App(id: Constants.REALM_APP_ID)
        guard let user = app.currentUser else {
            return nil
        }
        
        
        do {
            let realm = try Realm(configuration: user.configuration(partitionValue: partition))
            return realm
        } catch {
            return nil
        }
    }
    

}
