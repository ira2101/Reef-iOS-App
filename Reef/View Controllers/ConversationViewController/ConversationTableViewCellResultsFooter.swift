//
//  ConversationTableViewCellResultsFooter.swift
//  Reef
//
//  Created by Ira Einbinder on 12/30/22.
//

import UIKit

class ConversationTableViewCellResultsFooter: UIView {
    
    var seenByLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    var downvoteLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    var neutralLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    var upvoteLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    required convenience init() {
        self.init()
        
        
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
