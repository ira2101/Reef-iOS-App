//
//  ReefTagUnique.swift
//  Reef
//
//  Created by Ira Einbinder on 1/12/23.
//

import Foundation
import RealmSwift

class ReefUniqueTag : Object, Codable {
    @Persisted(primaryKey: true) var _id: ObjectId = ObjectId.generate();
    @Persisted var tag: String = ""
    @Persisted var isVerified: Bool = false
    @Persisted var timestamp: Date = Date.now
    
    convenience init(tag: String) {
        self.init()
        self.tag = tag.lowercased()
    }
    
    override init() {
        
    }
    
//    @Persisted var someValue: String

    enum CodingKeys: String, CodingKey {
        case _id
        case tag
        case isVerified
        case timestamp
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(_id.stringValue, forKey: ._id)
        try container.encode(tag, forKey: .tag)
        try container.encode(isVerified.description, forKey: .isVerified)
        
        let dateFormatter = ISO8601DateFormatter()
        try container.encode(dateFormatter.string(from: timestamp), forKey: .timestamp)
    }
    
    required init(from decoder: Decoder) throws {
        super.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let _id = try container.decode(String.self, forKey: ._id)
        let tag = try container.decode(String.self, forKey: .tag)
        let isVerified = try container.decode(String.self, forKey: .isVerified)
        let timestamp = try container.decode(String.self, forKey: .timestamp)
        
        self._id = try ObjectId(string: _id)
        self.tag = tag
        self.isVerified = Bool(isVerified)!
        
        let dateFormatter = ISO8601DateFormatter()
        self.timestamp = dateFormatter.date(from: timestamp)!
    }
    
}
