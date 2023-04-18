//
//  ViewController.swift
//  Reef
//
//  Created by Ira Einbinder on 1/1/22.
//

import UIKit
import RealmSwift
import SnapKit

class QuestionViewController: UIViewController {
    var questionTable: UITableView = {
        let table = UITableView()
        return table
    }()
    
    var data: [ReefQuestion] = [];
        
    override func viewDidLoad() {
        super.viewDidLoad()
        questionTable.delegate = self
        questionTable.dataSource = self
        setupView()
        populateView()
    }
    
    func setupView() {
        let sayBarButton = UIBarButtonItem(title: "What's On Your Mind?", style: .plain, target: self, action: #selector(poseQuestionPressed))
        let searchBarButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(searchPressed))
        self.navigationItem.rightBarButtonItems = [searchBarButton, sayBarButton]
        
        
        self.view.addSubview(questionTable)
        questionTable.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide.snp.edges)
        }
    }
    
    func populateView() {
        Task {
            do {
                try await loadReefQuestions();
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    @objc func poseQuestionPressed() {
        let postQuestionViewController = PostQuestionViewController(reefDraft: nil)
        postQuestionViewController.modalPresentationStyle = .fullScreen
        self.navigationController!.pushViewController(postQuestionViewController, animated: true)
    }
    
    @objc func searchPressed() {
        let vc = SearchViewController()
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func loadReefQuestions() async throws {
        let app = App(id: Constants.REALM_APP_ID);
        guard let user = app.currentUser else {
            return;
        }
                
        let realm = try await Realm(configuration: user.configuration(partitionValue: Constants.GLOBAL_PARTITION))

        self.data.removeAll()
        self.data += Array(realm.objects(ReefQuestion.self))

        DispatchQueue.main.async {
            self.questionTable.reloadData();
        }
    }
    
    var pageIndex: Int = 0
    let pageSize: Int = 20
}

extension QuestionViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return min((self.pageIndex + 1) * self.pageSize, self.data.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return QuestionTableViewCell(reefQuestion: self.data[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let conversationParentViewController = ConversationViewController(questionID: self.data[indexPath.row]._id,
                                                                                conversationBubbleID: nil,
                                                                                conversationText: self.data[indexPath.row].bubble)
        conversationParentViewController.loadViewIfNeeded()
        conversationParentViewController.modalPresentationStyle = .fullScreen
        self.navigationController!.pushViewController(conversationParentViewController, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y + scrollView.frame.size.height >= scrollView.contentSize.height && pageIndex * pageSize < self.data.count  {
            self.questionTable.beginUpdates()
            self.pageIndex += 1
            let minVal = min(pageIndex * pageSize, self.data.count)
            let maxVal = min((pageIndex + 1) * pageSize, self.data.count)
            self.questionTable.insertRows(at: (minVal..<maxVal).map({
                return IndexPath(row: $0, section: 0)
            }), with: .automatic)
            self.questionTable.endUpdates()
        }
    }
}


//func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//    let lastRowIndex = tableView.numberOfRows(inSection: 0) - 1
//    if indexPath.row == lastRowIndex {
//        loadMoreData()
//        tableView.reloadData()
//    }
//}

//Array(allObjects[currentPage*pageSize..<(currentPage+1)*pageSize])

