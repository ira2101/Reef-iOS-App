//
//  SearchResultsTableView.swift
//  Reef
//
//  Created by Ira Einbinder on 3/9/23.
//

import UIKit
import SnapKit
import RealmSwift

class SearchResultsTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    struct Props {
        var uniqueTag: ReefUniqueTag
    }
    
    var props: Props!
    
    var data: Results<ReefQuestion>?
    
    convenience init(uniqueTag: ReefUniqueTag) {
        self.init()
        props = Props(uniqueTag: uniqueTag)
        self.delegate = self
        self.dataSource = self
        setupView()
        populateView()
    }
    
    func setupView() {
        self.backgroundColor = .systemBackground
    }
    
    func populateView() {
        Task {
            do {
                let app = App(id: Constants.REALM_APP_ID)
                let user = app.currentUser!
                let realm = try await Realm(configuration: user.configuration(partitionValue: Constants.GLOBAL_PARTITION))
                let reefQuestions = realm.objects(ReefQuestion.self)
                
                data = reefQuestions.where {
                    $0.tagObjects.uniqueTag._id == props.uniqueTag._id
                }
                
                DispatchQueue.main.async {
                    self.reloadData()
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return QuestionTableViewCell(reefQuestion: self.data![indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let conversationParentViewController = ConversationViewController(questionID: self.data![indexPath.row]._id,
                                                                                conversationBubbleID: nil,
                                                                                conversationText: self.data![indexPath.row].bubble)
        conversationParentViewController.loadViewIfNeeded()
        conversationParentViewController.modalPresentationStyle = .fullScreen
        self.parentViewController?.navigationController?.pushViewController(conversationParentViewController, animated: true)
    }

}
