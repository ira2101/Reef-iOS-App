//
//  OoshiePostQuestionViewController.swift
//  Reef
//
//  Created by Ira Einbinder on 5/1/22.
//

import UIKit
import RealmSwift
import SnapKit

class PostQuestionViewController: UIViewController {
    var titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        collectionView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.75)
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        flowLayout.itemSize = CGSize(width: 118, height: 34)
        collectionView.setCollectionViewLayout(flowLayout, animated: true)
        return collectionView
    }()
    
    var textView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        return textView
    }()
    
    var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        return searchBar
    }()
    
    var postButton: UIButton = {
        let button = UIButton(configuration: .filled(), primaryAction: .none)
        button.setTitle("Post", for: .normal)
        button.addTarget(self, action: #selector(postPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    var tags: [String] = []
    var reefDraft: ReefDraft?
    
    convenience init(reefDraft: ReefDraft? = nil) {
        self.init()
        self.reefDraft = reefDraft
        
        if reefDraft != nil {
            self.textView.text = reefDraft!.bubble
            self.tags = Array(reefDraft!.tags)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(TagCollectionViewCell.self, forCellWithReuseIdentifier: "TagCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        searchBar.delegate = self
        setupView()
    }
    

    func setupView() {
        self.view.backgroundColor = .white
        
        let barButton = UIBarButtonItem(image: .init(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(backButtonPressed(_:)))
        self.navigationItem.leftBarButtonItems = [barButton]
        
        self.view.addSubview(searchBar)
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
                
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(80)
        }
        
        self.view.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(5)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        self.view.addSubview(postButton)
        postButton.snp.makeConstraints { make in
            make.top.equalTo(textView.snp.bottom).offset(10)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-10)
            make.trailing.equalToSuperview().offset(-10)
        }
    }
    
    @objc func postPressed(_ sender: UIButton) {
        if !textView.hasText {
            return
        }
        
        Task {
            do {
                try await postResponse()
                let vcCount = self.navigationController!.viewControllers.count
                guard let questionViewController = self.navigationController!.viewControllers[vcCount - 2] as? QuestionViewController else {
                    DispatchQueue.main.async {
                        self.navigationController!.popViewController(animated: true)
                    }
                    return
                }
                try await questionViewController.loadReefQuestions()
                DispatchQueue.main.async {
                    self.navigationController!.popViewController(animated: true)
                }
            } catch {
                print(error.localizedDescription)
                return
            }
        }
    }
    
    @MainActor
    func postResponse() async throws {
        let app = App(id: Constants.REALM_APP_ID)
        let user = app.currentUser!
        
        var reefTags: [ReefTag] = []
        for i: String in tags {
            try await reefTags.append(ReefTag(tag: i, question: ReefQuestion()))
            print(reefTags.last!.description)
        }
        
        let reefQuestion = ReefQuestion(bubble: textView.text, tags: reefTags)
        let reefFollowing = ReefFollowing(followingId: reefQuestion._id, userId: try! ObjectId(string: user.id))
        
        for reefTag in reefTags {
            // The questionID of ReefTag is FAULTY.
            reefTag.questionID = reefQuestion._id
        }
                
        try await ReefIO.writeToDatabase(objs: [reefQuestion] + reefTags, partition: Constants.GLOBAL_PARTITION)
        try await ReefIO.writeToDatabase(objs: [reefFollowing], partition: user.id)
        
        if self.reefDraft != nil {
            try await ReefIO.deleteFromDatabase(objs: [self.reefDraft!], partition: user.id)
            let vcCount = self.navigationController!.viewControllers.count
            if let profileViewController = self.navigationController!.viewControllers[vcCount - 2] as? ProfileViewController {
                profileViewController.myDraftsPressed(profileViewController.myDraftsButton)
            }
        }
    }
    
    @objc func backButtonPressed(_ sender: UIBarButtonItem) {
        if reefDraft == nil {
            if !self.textView.text.isEmpty || !self.tags.isEmpty {
                let alert = UIAlertController(title: "Would you like to save your draft?", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                    Task {
                        let app = App(id: Constants.REALM_APP_ID)
                        let user = app.currentUser!
                        let reefDraft = ReefDraft(bubble: self.textView.text!,
                                                  userID: try! ObjectId(string: user.id),
                                                  parentID: nil,
                                                  questionID: nil)
                        reefDraft.tags.append(objectsIn: self.tags)
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
            if reefDraft!.bubble != self.textView.text || tagsAreDifferent(current: Array(reefDraft!.tags), changed: self.tags) {
                let alert = UIAlertController(title: "Would you like to save your draft?", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Save Changes", style: .default, handler: { action in
                    do {
                        let app = App(id: Constants.REALM_APP_ID)
                        let user = app.currentUser!
                        let userRealm = try Realm(configuration: user.configuration(partitionValue: user.id))
                        try userRealm.write {
                            self.reefDraft!.bubble = self.textView.text!
                            self.reefDraft!.tags.removeAll()
                            self.reefDraft!.tags.append(objectsIn: self.tags)
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
    
    func tagsAreDifferent(current: [String], changed: [String]) -> Bool {
        let minCount = min(current.count, changed.count)
        for i in 0..<minCount {
            if current[i] != changed[i] {
                return true
            }
        }
        
        return current.count != changed.count
    }
}

extension PostQuestionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.tags.count
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCollectionViewCell", for: indexPath) as! TagCollectionViewCell
        cell.configure(tag: self.tags[indexPath.row],
                       indexPath: indexPath,
                       postQuestionViewController: self)        
        return cell
//        return TagCollectionViewCell(tag: self.tags[indexPath.row], indexPath: indexPath, postQuestionViewController: self)
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return (self.tags[indexPath.row] as NSString).size(withAttributes: nil)
//    }
}

extension PostQuestionViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        tags.append(searchBar.text!)
        self.collectionView.reloadData()
        searchBar.text = ""
    }
}
