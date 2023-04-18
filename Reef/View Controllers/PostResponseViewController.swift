//
//  PostViewController.swift
//  Reef
//
//  Created by Ira Einbinder on 1/21/22.
//

import UIKit
import RealmSwift
import SnapKit

class PostResponseViewController: UIViewController {
    var responseTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .lightGray.withAlphaComponent(0.2)
        return textView
    }()
    
    var replyingToLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    var addSourceButton: UIButton = {
        let button = UIButton(configuration: .filled(), primaryAction: .none)
        button.addTarget(self, action: #selector(addSourcePressed(_:)), for: .touchUpInside)
        button.setTitle("Sources", for: .normal)
        return button
    }()
    
    var postButton: UIButton = {
        let button = UIButton(configuration: .filled(), primaryAction: .none)
        button.addTarget(self, action: #selector(postPressed(_:)), for: .touchUpInside)
        button.setTitle("Post", for: .normal)
        return button
    }()
    
    var sourcesViewController: SourcesViewController = {
        let vc = SourcesViewController()
        vc.view.backgroundColor = .white
        vc.modalPresentationStyle = .formSheet
        return vc
    }()
    
    var questionID: ObjectId!
    var bubbleParentID: ObjectId?
    var bubbleParentText: String!
    var reefDraft: ReefDraft?
        
    convenience init(questionID: ObjectId!, bubbleParentID: ObjectId?, bubbleParentText: String?, bubbleResponseText: String = "", reefDraft: ReefDraft? = nil) {
        self.init()
        self.questionID = questionID
        self.bubbleParentID = bubbleParentID
        self.bubbleParentText = bubbleParentText
        self.responseTextView.text = bubbleResponseText
        self.reefDraft = reefDraft
        if reefDraft != nil {
            self.sourcesViewController.sources += reefDraft!.sources
        }
        
        do {
            if bubbleParentID != nil {
                let app = App(id: Constants.REALM_APP_ID)
                let user = app.currentUser!
                let globalRealm = try Realm(configuration: user.configuration(partitionValue: Constants.GLOBAL_PARTITION))
                let parentBubble = globalRealm.objects(ReefBubble.self).first {
                    $0._id == bubbleParentID
                }
                
                //if parentBubble is null, then this could be a sign that the parentBubble was deleted.
                guard parentBubble != nil else {
                    self.navigationController!.popViewController(animated: false)
                    return
                }
                self.navigationItem.title = parentBubble!.bubble
                self.replyingToLabel.text = parentBubble!.bubble
            } else {
                let app = App(id: Constants.REALM_APP_ID)
                let user = app.currentUser!
                let globalRealm = try Realm(configuration: user.configuration(partitionValue: Constants.GLOBAL_PARTITION))
                let parentQuestion = globalRealm.objects(ReefQuestion.self).first {
                    $0._id == questionID
                }
                
                //if parentQuestion is null, then this could be a sign that the parentQuestion was deleted.
                guard parentQuestion != nil else {
                    self.navigationController!.popViewController(animated: false)
                    return
                }
                self.navigationItem.title = parentQuestion!.bubble
                self.replyingToLabel.text = parentQuestion!.bubble
            }
        } catch {
            print(error.localizedDescription)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        self.view.backgroundColor = .white
        
        let barButton = UIBarButtonItem(image: .init(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(backButtonPressed(_:)))
        self.navigationItem.leftBarButtonItems = [barButton]
        
        self.view.addSubview(replyingToLabel)
        replyingToLabel.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(5)
            make.leading.equalToSuperview().offset(5)
            make.trailing.equalToSuperview()
        }
        self.view.addSubview(postButton) //necessary here because responseTextView bottom anchor constraint
        postButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-5)
            make.trailing.equalToSuperview().offset(-5)
        }
        
        self.view.addSubview(responseTextView)
        responseTextView.snp.makeConstraints { make in
            make.top.equalTo(replyingToLabel.snp.bottom).offset(5)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalTo(postButton.snp.top).offset(-5)
        }
        
        self.view.addSubview(addSourceButton)
        addSourceButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-5)
            make.trailing.equalTo(postButton.snp.leading).offset(-5)
        }
    }
    
    @objc func backButtonPressed(_ sender: UIBarButtonItem) {
        if reefDraft == nil {
            if !self.sourcesViewController.sources.isEmpty || !self.responseTextView.text.isEmpty {
                let alert = UIAlertController(title: "Would you like to save your draft?", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                    Task {
                        let app = App(id: Constants.REALM_APP_ID)
                        let user = app.currentUser!
                        let reefDraft = ReefDraft(bubble: self.responseTextView.text!,
                                                  userID: try! ObjectId(string: user.id),
                                                  parentID: self.bubbleParentID,
                                                  questionID: self.questionID)
                        reefDraft.sources.append(objectsIn: self.sourcesViewController.sources)
                        try! await ReefIO.writeToDatabase(objs: [reefDraft], partition: user.id)
                    }
                    self.navigationController!.popViewController(animated: true)
                }))
                alert.addAction(UIAlertAction(title: "No", style: .default, handler: { action in
                    self.navigationController!.popViewController(animated: true)
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { action in
                    //do nothing
                }))
                self.present(alert, animated: true)
            } else {
                self.navigationController!.popViewController(animated: true)
            }
        } else {
            if reefDraft!.bubble != self.responseTextView.text || sourcesAreDifferent(current: Array(reefDraft!.sources),
                                                                                      changed: self.sourcesViewController.sources) {
                let alert = UIAlertController(title: "Would you like to save your draft?", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Save Changes", style: .default, handler: { action in
                    do {
                        let app = App(id: Constants.REALM_APP_ID)
                        let user = app.currentUser!
                        let userRealm = try Realm(configuration: user.configuration(partitionValue: user.id))
                        try userRealm.write {
                            self.reefDraft!.bubble = self.responseTextView.text!
                            self.reefDraft!.sources.removeAll()
                            self.reefDraft!.sources.append(objectsIn: self.sourcesViewController.sources)
                        }
                        DispatchQueue.main.async {
                            let vcCount = self.navigationController!.viewControllers.count
                            if let profileViewController = self.navigationController!.viewControllers[vcCount - 2] as? ProfileViewController {
                                profileViewController.myDraftsPressed(profileViewController.myDraftsButton)
                            }
                            self.navigationController!.popViewController(animated: true)
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                }))
                alert.addAction(UIAlertAction(title: "Delete Changes", style: .default, handler: { action in
                    self.navigationController!.popViewController(animated: true)
                }))
                alert.addAction(UIAlertAction(title: "Delete Draft", style: .default, handler: { action in
                    Task {
                        let app = App(id: Constants.REALM_APP_ID)
                        let user = app.currentUser!
                        try await ReefIO.deleteFromDatabase(objs: [self.reefDraft!], partition: user.id)
                        DispatchQueue.main.async {
                            let vcCount = self.navigationController!.viewControllers.count
                            if let profileViewController = self.navigationController!.viewControllers[vcCount - 2] as? ProfileViewController {
                                profileViewController.myDraftsPressed(profileViewController.myDraftsButton)
                            }
                            self.navigationController!.popViewController(animated: true)
                        }
                    }
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { action in
                    //do nothing
                }))
                self.present(alert, animated: true)
            } else {
                self.navigationController!.popViewController(animated: true)
            }
        }
    }
    
    func sourcesAreDifferent(current: [String], changed: [String]) -> Bool {
        let minCount = min(current.count, changed.count)
        for i in 0..<minCount {
            if current[i] != changed[i] {
                return true
            }
        }
        
        return current.count != changed.count
    }

    @objc func postPressed(_ sender : UIButton) {
        if !responseTextView.hasText {
            return
        }
        
        Task {
            do {
                try await postResponse()
                DispatchQueue.main.async {
                    self.navigationController!.popViewController(animated: true)
                }
            } catch {
                print(error.localizedDescription)
                return
            }
        }
    }
    
    @objc func addSourcePressed(_ sender: UIButton) {
        self.present(sourcesViewController, animated: true)
    }
    
    @MainActor
    func postResponse() async throws {
        let app = App(id: Constants.REALM_APP_ID)
        let user = app.currentUser!
        
        let reefLevelOfUser = try await ReefUser.getReefLevel()
        
        let reefBubble = ReefBubble(bubble: self.responseTextView.text!,
                                    userID: try! ObjectId(string: user.id),
                                    parentID: self.bubbleParentID,
                                    questionID: self.questionID,
                                    reefLevel: reefLevelOfUser)
        reefBubble.sources.append(objectsIn: sourcesViewController.sources)
        try await ReefIO.writeToDatabase(objs: [reefBubble], partition: Constants.GLOBAL_PARTITION)
        
        if self.reefDraft != nil {
            try await ReefIO.deleteFromDatabase(objs: [self.reefDraft!], partition: user.id)
            let vcCount = self.navigationController!.viewControllers.count
            if let profileViewController = self.navigationController!.viewControllers[vcCount - 2] as? ProfileViewController {
                profileViewController.myDraftsPressed(profileViewController.myDraftsButton)
            }
        }
    }
}
