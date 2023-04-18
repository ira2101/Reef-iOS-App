//
//  ConversationParentViewController.swift
//  Reef
//
//  Created by Ira Einbinder on 2/5/22.
//

import UIKit
import RealmSwift
import SwiftUI
import SnapKit

enum ConversationOrdering {
    case TopBubbles
    case RecentBubbles
    case MyBubbles
}

class ConversationViewController: UIViewController {
    var bubbleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
        
    var conversationTableViews: [ReefConversationTableView]!
            
    struct Props {
        var questionID: ObjectId!
        var conversationBubbleID: ObjectId?
        var conversationText: String! // If parentID is nil, then parentText = "question"
    }
    
    var props: Props!
    
    var invisibleView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        return view
    }()
        
    required convenience init(questionID: ObjectId!, conversationBubbleID: ObjectId?, conversationText: String!) {
        self.init()
        self.props = Props(questionID: questionID, conversationBubbleID: conversationBubbleID, conversationText: conversationText)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task {
            do {
                let app = App(id: Constants.REALM_APP_ID)
                let user = app.currentUser!
                if props.conversationBubbleID == nil {
                    let questionSeen = ReefQuestionSeen(questionID: props.questionID, userID: try ObjectId(string: user.id))
                    try await ReefIO.writeToDatabase(objs: [questionSeen])
                } else {
                    let bubbleSeen = ReefBubbleSeen(bubbleID: props.conversationBubbleID!, userID: try ObjectId(string: user.id))
                    try await ReefIO.writeToDatabase(objs: [bubbleSeen])
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        
        setupView()
        populateView()
    }
    
    func setupView() {
        self.view.backgroundColor = UIColor.white
        
        let sayBarButton = UIBarButtonItem(title: "Say Something", style: .plain, target: self, action: #selector(saySomethingPressed))
        let voteBarButton = UIBarButtonItem(title: "Vote", style: .plain, target: self, action: #selector(votePressed))
        self.navigationItem.rightBarButtonItems = [voteBarButton, sayBarButton]
        
        
        let reefPanButton1: ReefPanButton = createReefPanButton()
        let reefPanButton2: ReefPanButton = createReefPanButton()
        let panButtonHeader: UIStackView = UIStackView(arrangedSubviews: [reefPanButton1, reefPanButton2])
        panButtonHeader.spacing = 5
        self.view.addSubview(panButtonHeader)
        
        panButtonHeader.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.leading.equalToSuperview().offset(10)
            make.trailing.lessThanOrEqualToSuperview()
        }
        reefPanButton1.snp.makeConstraints { make in
            make.width.equalTo(125)
        }
        reefPanButton2.snp.makeConstraints { make in
            make.width.equalTo(125)
        }

        let headerView = ConversationHeaderView(reefBubble: self.props.conversationText)
        self.view.addSubview(headerView)
        headerView.snp.makeConstraints { make in
            make.top.equalTo(panButtonHeader.snp.bottom).offset(5)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        conversationTableViews = [
            ReefConversationTableView(conversationOrdering: .TopBubbles, questionID: self.props.questionID, conversationBubbleID: self.props.conversationBubbleID),
            ReefConversationTableView(conversationOrdering: .RecentBubbles, questionID: self.props.questionID, conversationBubbleID: self.props.conversationBubbleID),
            ReefConversationTableView(conversationOrdering: .MyBubbles, questionID: self.props.questionID, conversationBubbleID: self.props.conversationBubbleID)
        ]

        let conversationPageView: ReefPageView = ReefPageView(pageDirection: .horizontal)
        .item(conversationTableViews[0])
        .item(conversationTableViews[1])
        .item(conversationTableViews[2])
        conversationPageView.showsHorizontalScrollIndicator = false
        conversationPageView.delegate = self

        self.view.addSubview(conversationPageView)
        conversationPageView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
        
        let fullScreenConversationHeaderView = FullScreenConversationHeaderView(reefBubble: self.props.conversationText)
        self.view.addSubview(fullScreenConversationHeaderView)
        fullScreenConversationHeaderView.snp.makeConstraints { make in
            make.top.equalTo(panButtonHeader.snp.bottom).offset(5)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        fullScreenConversationHeaderView.bottomConstraint = fullScreenConversationHeaderView.snp.prepareConstraints({ make in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        })[0]
        
        self.view.bringSubviewToFront(panButtonHeader)
    }
    
    func createReefPanButton() -> ReefPanButton {
        var buttons: [UILabel] = []
        buttons.append(UILabel())
        buttons[0].text = "Reef level: Global"

        for i in 1..<50 {
            buttons.append(UILabel())
            buttons[i].text = "Reef level: \(i)"
        }
        
        let reefPanButton = ReefPanButton(arrangedSubviews: buttons) { reefLevel in
            self.conversationTableViews.forEach {
                $0.updateReefBubbles(reefLevel: reefLevel)
            }
        }
        
        reefPanButton.layer.cornerRadius = 5
        reefPanButton.layer.borderColor = UIColor.black.cgColor
        reefPanButton.layer.borderWidth = 0.1
        reefPanButton.popupScrollView.layer.cornerRadius = 5
        reefPanButton.popupScrollView.layer.borderColor = UIColor.black.cgColor
        reefPanButton.popupScrollView.layer.borderWidth = 0.1
        reefPanButton.setTitle("Reef level: Global", for: .normal)
        return reefPanButton
    }
    

    
    func populateView() {
        bubbleLabel.text = self.props.conversationText
    }
    
    
    @objc func saySomethingPressed() {
        let postResponseViewController = PostResponseViewController(questionID: self.props.questionID,
                                                                    bubbleParentID: self.props.conversationBubbleID,
                                                                    bubbleParentText: self.props.conversationText)
        self.navigationController!.pushViewController(postResponseViewController, animated: true)
    }
    
    @objc func votePressed() {
        let pageViewController = VotePageViewController(conversationParentViewController: self)
        pageViewController.loadViewIfNeeded()
        self.navigationController!.pushViewController(pageViewController, animated: true)
    }
}

extension ConversationViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let index = lround(scrollView.contentOffset.x / scrollView.frame.size.width)
//        topBubbleButton.layer.backgroundColor = UIColor.white.cgColor
//        recentBubbleButton.layer.backgroundColor = UIColor.white.cgColor
//        myBubbleButton.layer.backgroundColor = UIColor.white.cgColor
//        
//        switch (index) {
//        case 0:
//            topBubbleButton.layer.backgroundColor = UIColor.lightGray.cgColor
//            break
//        case 1:
//            recentBubbleButton.layer.backgroundColor = UIColor.lightGray.cgColor
//            break
//        case 2:
//            myBubbleButton.layer.backgroundColor = UIColor.lightGray.cgColor
//            break
//        default:
//            break
//        }
    }
}

//var buttons: [UILabel] = []
//buttons.append(UILabel())
//buttons[0].text = "Reef level: Global"
//
//for i in 1..<50 {
//    buttons.append(UILabel())
//    buttons[i].text = "Reef level: \(i)"
//}

///* Top Section */
//let reefPanButton = ReefPanButton(arrangedSubviews: buttons)
//reefPanButton.layer.cornerRadius = 5
//reefPanButton.layer.borderColor = UIColor.black.cgColor
//reefPanButton.layer.borderWidth = 0.1
//reefPanButton.popupScrollView.layer.cornerRadius = 5
//reefPanButton.popupScrollView.layer.borderColor = UIColor.black.cgColor
//reefPanButton.popupScrollView.layer.borderWidth = 0.1
//reefPanButton.setTitle("Reef level: Global", for: .normal)
//
//self.view.addSubview(reefPanButton)
//reefPanButton.translatesAutoresizingMaskIntoConstraints = false
//reefPanButton.topAnchor.constraint(equalTo: bubbleLabel.bottomAnchor, constant: 5).isActive = true
//reefPanButton.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
//reefPanButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
//
//buttons = []
//buttons.append(UILabel())
//buttons.append(UILabel())
//buttons.append(UILabel())
//buttons[0].text = "Top Bubbles"
//buttons[1].text = "Recent Bubbles"
//buttons[2].text = "My Bubbles"
//
//let bubblesPanButton = ReefPanButton(arrangedSubviews: buttons)
//bubblesPanButton.layer.cornerRadius = 5
//bubblesPanButton.layer.borderColor = UIColor.black.cgColor
//bubblesPanButton.layer.borderWidth = 0.1
//bubblesPanButton.popupScrollView.layer.cornerRadius = 5
//bubblesPanButton.popupScrollView.layer.borderColor = UIColor.black.cgColor
//bubblesPanButton.popupScrollView.layer.borderWidth = 0.1
//bubblesPanButton.setTitle("Top Bubbles", for: .normal)
//
//self.view.addSubview(bubblesPanButton)
//bubblesPanButton.translatesAutoresizingMaskIntoConstraints = false
//bubblesPanButton.topAnchor.constraint(equalTo: bubbleLabel.bottomAnchor, constant: 5).isActive = true
//bubblesPanButton.leadingAnchor.constraint(equalTo: reefPanButton.trailingAnchor, constant: 5).isActive = true
//bubblesPanButton.widthAnchor.constraint(equalToConstant: 120).isActive = true

//self.view.bringSubviewToFront(reefPanButton)
//self.view.bringSubviewToFront(bubblesPanButton)
