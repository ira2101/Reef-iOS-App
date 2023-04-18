//
//  ReefConversationTableView.swift
//  Reef
//
//  Created by Ira Einbinder on 7/22/22.
//

import RealmSwift
import UIKit

class ReefConversationTableView: UITableView, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    var data: Results<ReefBubble>!
    
    struct Props {
        var conversationOrdering: ConversationOrdering = .TopBubbles
        var questionID: ObjectId!
        var conversationBubbleID: ObjectId?
    }
    
    var props: Props!
    
    convenience init(conversationOrdering: ConversationOrdering, questionID: ObjectId, conversationBubbleID: ObjectId?) {
        self.init()
//        super.reefDelegate = self
        delegate = self
        dataSource = self
        self.props = Props(conversationOrdering: conversationOrdering, questionID: questionID, conversationBubbleID: conversationBubbleID)
        self.data = fetchReefBubbles(conversationOrdering: conversationOrdering, reefLevel: 0)
        
        self.backgroundColor = UIColor(red: 69 / 255, green: 74 / 255, blue: 222 / 255, alpha: 1.0)
        self.sectionHeaderTopPadding = 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
//        return data.count
        return min((pageIndex + 1) * pageSize, data.count)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        if (section == 0) {
//            return nil
//        }
        
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        if (section == 0) {
//            return 0
//        }
        return 5
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if (section == data.count - 1) {
            let view = UIView()
            view.backgroundColor = .clear
            return view
        }
        return nil
    }

   func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
       if (section == data.count - 1) {
           return 5
       }
       return 0
   }
    
    
    
    
    

    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ConversationTableViewCell(reefBubble: data[indexPath.section])
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let conversationViewController = ConversationViewController(questionID: self.data[indexPath.section].questionID,
                                                                    conversationBubbleID: self.data[indexPath.section]._id,
                                                                    conversationText: self.data[indexPath.section].bubble)
        
        conversationViewController.loadViewIfNeeded()
        conversationViewController.modalPresentationStyle = .fullScreen
        self.parentViewController?.navigationController!.pushViewController(conversationViewController, animated: true)
    }
        
    var pageIndex: Int = 0
    let pageSize: Int = 10
        
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y + scrollView.frame.size.height >= scrollView.contentSize.height && pageIndex * pageSize < self.data.count  {
            self.beginUpdates()
            pageIndex += 1
            let minVal = min(pageIndex * pageSize, self.data.count)
            let maxVal = min((pageIndex + 1) * pageSize, self.data.count)
            self.insertSections(IndexSet(integersIn: minVal..<maxVal), with: .automatic)
            self.endUpdates()
        }
    }
    
    
    func reefCreateDataObserver(_ tableView: ReefTableView) -> NotificationToken? {
        return nil
//        return data.observe { change in
//            switch change {
//            case .initial(_):
//                break
//            case .update(let results, let deletions, let insertions, let modifications):
//                self.data = results
//                tableView.beginUpdates()
//                tableView.performBatchUpdates {
//                    tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
//                                         with: .automatic)
//                    tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
//                                         with: .automatic)
//                    tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
//                                         with: .automatic)
//                }
//                tableView.endUpdates()
//            case .error(_):
//                break
//            }
//        }
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 200.0
//    }
    

    
    func updateReefBubbles(reefLevel: Int) {
        self.data = fetchReefBubbles(conversationOrdering: self.props.conversationOrdering, reefLevel: reefLevel)
        self.reloadData()
    }
    
    func fetchReefBubbles(conversationOrdering: ConversationOrdering, reefLevel: Int) -> Results<ReefBubble> {
        let user = ReefIO.getCurrentUser()!
        let realm = ReefIO.getRealm(with: Constants.GLOBAL_PARTITION)!
        
        var data: Results<ReefBubble>
        switch (conversationOrdering) {
        case .TopBubbles:
            if let conversationBubbleID = self.props.conversationBubbleID {
                data = realm.objects(ReefBubble.self).where { bubble in
                    bubble.parentID == conversationBubbleID
                }
                if reefLevel > 0 {
                    data = data.where({
                        $0.reefLevel == reefLevel
                    })
                }
            } else {
                data = realm.objects(ReefBubble.self).where {
                    $0.parentID == nil && $0.questionID == self.props.questionID
                }
                if reefLevel > 0 {
                    data = data.where({
                        $0.reefLevel == reefLevel
                    })
                }
            }
            break;
        case .RecentBubbles:
            if let conversationBubbleID = self.props.conversationBubbleID {
                data = realm.objects(ReefBubble.self).where {
                    $0.parentID == conversationBubbleID
                }
                .sorted(byKeyPath: "dateAdded", ascending: false)
                
                if reefLevel > 0 {
                    data = data.where({
                        $0.reefLevel == reefLevel
                    })
                }
            } else {
                data = realm.objects(ReefBubble.self).where {
                    $0.parentID == nil && $0.questionID == self.props.questionID
                }
                .sorted(byKeyPath: "dateAdded", ascending: false)
                
                if reefLevel > 0 {
                    data = data.where({
                        $0.reefLevel == reefLevel
                    })
                }
            }
            break;
        case .MyBubbles:
            if let conversationBubbleID = self.props.conversationBubbleID {
                data = realm.objects(ReefBubble.self).where {
                    $0.parentID == conversationBubbleID && $0.userID == (try! ObjectId(string: user.id))
                }
                .sorted(byKeyPath: "dateAdded", ascending: false)
                
                if reefLevel > 0 {
                    data = data.where({
                        $0.reefLevel == reefLevel
                    })
                }
            } else {
                data = realm.objects(ReefBubble.self).where {
                    $0.parentID == nil && $0.questionID == self.props.questionID && $0.userID == (try! ObjectId(string: user.id))
                }
                .sorted(byKeyPath: "dateAdded", ascending: false)
                
                if reefLevel > 0 {
                    data = data.where({
                        $0.reefLevel == reefLevel
                    })
                }
            }
            break;
        }
        
        return data
    }
}
