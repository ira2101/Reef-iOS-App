//
//  ProfileViewController.swift
//  Reef
//
//  Created by Ira Einbinder on 2/2/22.
//

import UIKit
import RealmSwift
import SnapKit

class ProfileViewController: UIViewController {
    
    var reefLevelLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    var myPostsButton: UIButton = {
        let button = UIButton(configuration: UIButton.Configuration.filled())
        button.setTitle("Posts", for: .normal)
        button.addTarget(self, action: #selector(myPostsPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    var followingPostsButton: UIButton = {
        let button = UIButton(configuration: UIButton.Configuration.filled())
        button.setTitle("Following", for: .normal)
        button.addTarget(self, action: #selector(followingPostsPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    var myDraftsButton: UIButton = {
        let button = UIButton(configuration: UIButton.Configuration.filled())
        button.setTitle("Drafts", for: .normal)
        button.addTarget(self, action: #selector(myDraftsPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    var tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    var agreeLabel: UILabel = {
        let label = UILabel()
        label.text = "Agree"
        label.textAlignment = .right
        return label
    }()
    
    var disagreeLabel: UILabel = {
        let label = UILabel()
        label.text = "Disagree"
        label.textAlignment = .left
        return label
    }()
    
    var levelProgressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .bar)
        progressView.trackTintColor = .lightGray
        progressView.progress = 0.5
    
        return progressView
    }()
    
    var nextLevelLabel: UILabel =  {
        let label = UILabel()
        label.text = "5,000 more reef points"
        return label
    }()
    
    var tableData: [Object] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        setupView()
        populateView()
    }
    
    @objc func settingsPressed(_ sender: UIButton) {
        let vc = SettingsBottomSheetViewController()
        vc.modalPresentationStyle = .pageSheet
        
        if let sheet = vc.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
//            sheet.prefersScrollingExpandsWhenScrolledToEdge = true
//            sheet.largestUndimmedDetentIdentifier = .medium
            sheet.prefersGrabberVisible = true
//            sheet.animateChanges {}
//            vc.isModalInPresentation = true // prevents it from being dismissed
            sheet.largestUndimmedDetentIdentifier = .large
        }
        
        self.present(vc, animated: true)
    }
    
    func setupView() {
        let rightBarItem = UIBarButtonItem(image: UIImage(systemName: "gearshape"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(settingsPressed(_:)))
        self.navigationItem.rightBarButtonItems = [rightBarItem]
        
        let reefLevelView = ReefLevelView(fish: "goldfish")
        self.view.addSubview(reefLevelView)
        reefLevelView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
        }
        


        
        let horizontalStackView1 = UIStackView(arrangedSubviews: [agreeLabel, disagreeLabel])
        horizontalStackView1.axis = .horizontal
        horizontalStackView1.distribution = .fillEqually
        horizontalStackView1.spacing = 10
        self.view.addSubview(horizontalStackView1)
        horizontalStackView1.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.top.equalTo(reefLevelView.snp.bottom).offset(10)
        }
        
        let horizontalStackView2 = UIStackView(arrangedSubviews: [myPostsButton, followingPostsButton, myDraftsButton])
        horizontalStackView2.axis = .horizontal
        horizontalStackView2.spacing = 5
        horizontalStackView2.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(horizontalStackView2)
        horizontalStackView2.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.top.equalTo(horizontalStackView1.snp.bottom).offset(10)
        }
        
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.top.equalTo(horizontalStackView2.snp.bottom).offset(10)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    func populateView() {
        Task {
            do {
                try await agreeLabel.text = ReefUser.numberOfAgrees().description + " agrees"
                try await disagreeLabel.text = ReefUser.numberOfDisagrees().description + " disagrees"
                try await reefLevelLabel.text = "Reef Level " + ReefUser.getReefLevel().description
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    @objc func followingPostsPressed(_ sender: UIButton) {
        let app = App(id: Constants.REALM_APP_ID)
        let user = app.currentUser!
        
        do {
            let realmUser = try Realm(configuration: user.configuration(partitionValue: user.id))
            let realmGlobal = try Realm(configuration: user.configuration(partitionValue: Constants.GLOBAL_PARTITION))
            
            let reefFollowing = realmUser.objects(ReefFollowing.self)
            let reefQuestion = realmGlobal.objects(ReefQuestion.self)
            
            
            tableData.removeAll()
            for i in 0..<reefFollowing.count {
                tableData += Array(reefQuestion.where {
                    $0._id == reefFollowing[i].followingId
                })
            }
        } catch {
            print(error.localizedDescription)
        }
        
        tableView.reloadData()
    }
    
    @objc func myPostsPressed(_ sender: UIButton) {
        let app = App(id: Constants.REALM_APP_ID)
        let user = app.currentUser!
        
        do {
            let realmGlobal = try Realm(configuration: user.configuration(partitionValue: Constants.GLOBAL_PARTITION))
            let reefBubble = realmGlobal.objects(ReefBubble.self)
            
            tableData.removeAll()
            tableData += Array(reefBubble.where {
                $0.userID == (try! ObjectId(string: user.id))
            })
        } catch {
            print(error.localizedDescription)
        }
        
        tableView.reloadData()
    }
    
    @objc func myDraftsPressed(_ sender: UIButton) {
        let app = App(id: Constants.REALM_APP_ID)
        let user = app.currentUser!
        
        do {
            let realmUser = try Realm(configuration: user.configuration(partitionValue: user.id))
            let reefDraft = realmUser.objects(ReefDraft.self)
            
            tableData.removeAll()
            tableData += Array(reefDraft)
        } catch {
            print(error.localizedDescription)
        }
        
        tableView.reloadData()
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        var config = cell.defaultContentConfiguration()
        
        if self.tableData[indexPath.row] is ReefQuestion {
            config.text = (self.tableData[indexPath.row] as! ReefQuestion).bubble
        } else if self.tableData[indexPath.row] is ReefBubble {
            config.text = (self.tableData[indexPath.row] as! ReefBubble).bubble
        } else if self.tableData[indexPath.row] is ReefDraft {
            config.text = (self.tableData[indexPath.row] as! ReefDraft).bubble
        }
        
        cell.contentConfiguration = config
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let reefQuestion = self.tableData[indexPath.row] as? ReefQuestion {
            let conversationParentViewController = ConversationViewController(questionID: reefQuestion._id, conversationBubbleID: nil, conversationText: reefQuestion.bubble)
            conversationParentViewController.modalPresentationStyle = .fullScreen
            self.navigationController!.pushViewController(conversationParentViewController, animated: true)
        } else if let reefBubble = self.tableData[indexPath.row] as? ReefBubble {
            let conversationParentViewController = ConversationViewController(questionID: reefBubble.questionID, conversationBubbleID: reefBubble._id, conversationText: reefBubble.bubble)
            conversationParentViewController.modalPresentationStyle = .fullScreen
            self.navigationController!.pushViewController(conversationParentViewController, animated: true)
        } else if let reefDraft = self.tableData[indexPath.row] as? ReefDraft {
            //now check if this is a question draft or a bubble draft
            if reefDraft.questionID == nil {
                let postQuestionViewController = PostQuestionViewController(reefDraft: reefDraft)
                postQuestionViewController.modalPresentationStyle = .fullScreen
                self.navigationController!.pushViewController(postQuestionViewController, animated: true)
            } else {
                let postResponseViewController = PostResponseViewController(questionID: reefDraft.questionID,
                                                                            bubbleParentID: reefDraft.parentID,
                                                                            bubbleParentText: nil,
                                                                            bubbleResponseText: reefDraft.bubble,
                                                                            reefDraft: reefDraft)
                self.navigationController!.pushViewController(postResponseViewController, animated: true)
            }
        }
    }
}
