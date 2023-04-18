//
//  QuestionTableViewCell.swift
//  Reef
//
//  Created by Ira Einbinder on 4/4/22.
//

import UIKit
import RealmSwift
import SnapKit


class QuestionTableViewCell: UITableViewCell {
    
    struct Props {
        var reefQuestion: ReefQuestion
    }
    
    var props: Props!
    
    var questionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    var followingButton: UIButton = {
        let button = UIButton()
//        button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        button.setTitle("Follow", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.titleLabel?.textColor = UIColor(red: 0 / 255, green: 57 / 255, blue: 211 / 255, alpha: 1.0)
//        button.backgroundColor = .systemBlue
//        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(followingPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    var threedotsButton: UIButton = {
        let button = UIButton()
        let messageIcon = UIImage(systemName: "ellipsis")
        button.setImage(messageIcon, for: .normal)
        button.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(scale: .small), forImageIn: .normal)
        button.tintColor = UIColor(red: 95 / 255, green: 95 / 255, blue: 95 / 255, alpha: 1)
        return button
    }()
    
    var seenButton: UIButton = {
        let button = UIButton()
        let messageIcon = UIImage(systemName: "eye.fill")
        button.setImage(messageIcon, for: .normal)
        button.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(scale: .small), forImageIn: .normal)
        button.tintColor = UIColor(red: 95 / 255, green: 95 / 255, blue: 95 / 255, alpha: 1)
        return button
    }()
    
    var messageButton: UIButton = {
        let button = UIButton()
        let messageIcon = UIImage(named: "BubbleMessageUncolored")
        button.setImage(messageIcon, for: .normal)
        button.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(scale: UIImage.SymbolScale.small), forImageIn: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(replyPressed(_:)), for: .touchUpInside)
        button.imageView!.contentMode = .scaleAspectFit
        return button
    }()
    
    var shareButton: UIButton = {
        let button = UIButton()
        let messageIcon = UIImage(systemName: "arrowshape.turn.up.right.fill")
        button.setImage(messageIcon, for: .normal)
        button.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(scale: .medium), forImageIn: .normal)
        button.tintColor = UIColor(red: 95 / 255, green: 95 / 255, blue: 95 / 255, alpha: 1)
        button.addTarget(self, action: #selector(sharePressed(_:)), for: .touchUpInside)
        return button
    }()
    
    var seenLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    var messageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    var shareLabel: UILabel = {
        let label = UILabel()
        label.text  = "5.2k"
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    required convenience init(reefQuestion: ReefQuestion) {
        self.init()
        self.props = Props(reefQuestion: reefQuestion)
        setupView()
        populateView()
    }
    
//    override func layoutSubviews() {
////        self.addBottomBorderWithColor(color: UIColor.systemGray, width: 0.5)
//    }
    
    
    
    func setupView() {
        self.addSubview(questionLabel)
        questionLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
        
        let footer: ReefHorizontalStackView =
        ReefHorizontalStackView()
        .addArrangedSubview(
            ReefHorizontalStackView()
            .addArrangedSubview(
                ReefHorizontalStackView()
                .addArrangedSubview(seenButton)
                .addArrangedSubview(seenLabel)
                .setSpacing(2)
                .setAlignment(.center)
            )
            .addArrangedSubview(
                ReefHorizontalStackView()
                .addArrangedSubview(messageButton)
                .addArrangedSubview(messageLabel)
                .setSpacing(2)
                .setAlignment(.center)
            )
            .addArrangedSubview(
                ReefHorizontalStackView()
                .addArrangedSubview(shareButton)
                .addArrangedSubview(shareLabel)
                .setSpacing(2)
                .setAlignment(.center)
            )
            .setSpacing(5)
            .setAlignment(.center)
        )
        .addArrangedSubview(followingButton)
        .setDistribution(.equalCentering)
        
        let tagView = createTagView(reefTags: Array(self.props.reefQuestion.tagObjects))
        if let tagView = tagView {
            self.addSubview(tagView)
            tagView.snp.makeConstraints { make in
                make.top.equalTo(self.questionLabel.snp.bottom)
                make.leading.equalToSuperview().offset(10)
                make.trailing.equalToSuperview().offset(-10)
            }
        }
        
        self.addSubview(footer)
        footer.snp.makeConstraints { make in
            make.top.equalTo(tagView?.snp.bottom ?? self.questionLabel.snp.bottom).offset(5)
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-5)
        }
        
        self.messageButton.snp.makeConstraints { make in
            make.height.equalTo(self.shareButton.intrinsicContentSize.height)
            make.width.equalTo(self.shareButton.intrinsicContentSize.width)
        }
        
        let reportQuestion = UIAction(title: "Flag Question", image: UIImage(systemName: "flag"), discoverabilityTitle: "Flag Question") { action in
            print(action)
            Task {
                do {
                    let app = App(id: Constants.REALM_APP_ID)
                    let user = app.currentUser!
                    let flag = ReefQuestionFlag(questionID: self.props.reefQuestion._id, userID: try ObjectId(string: user.id), reason: "")
                    try await ReefIO.writeToDatabase(objs: [flag])
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        threedotsButton.showsMenuAsPrimaryAction = true
        threedotsButton.menu = UIMenu(title: "", options: .displayInline, children: [reportQuestion])
                                
        self.contentView.isUserInteractionEnabled = false
    }
    
    func populateView() {
        self.questionLabel.text = self.props.reefQuestion.bubble
        
        Task {
            do {
                if try await ReefUser.isFollowing(reefQuestion: self.props.reefQuestion) {
                    following()
                } else {
                    notFollowing()
                }
                
                let seenby = try await props.reefQuestion.getSeenBy()
                let replies = try await props.reefQuestion.getReplies()
                let shares = try await props.reefQuestion.getSharedBy()
                DispatchQueue.main.async {
                    self.seenLabel.text = seenby.description
                    self.messageLabel.text = replies.description
                    self.shareLabel.text = shares.description
                }
            } catch {
                print("error in QuestionTableViewCell configure function")
            }
        }
    }
    
    @objc func followingPressed(_ sender: UIButton) {
        if followingButton.titleLabel?.text == "Follow" {
            Task {
                do {
                    try await ReefUser.follow(reefQuestion: self.props.reefQuestion)
                    following()
                } catch {
                    print("Failed to follow the question")
                }
            }
        } else {
            Task {
                do {
                    try await ReefUser.unfollow(reefQuestion: self.props.reefQuestion)
                    notFollowing()
                } catch {
                    print("Failed to unfollow the question")
                }
            }
        }
    }
    
    func following() {
        followingButton.setTitle("Following", for: .normal)
        followingButton.setTitleColor(UIColor(red: 116 / 255, green: 116 / 255, blue: 118 / 255, alpha: 1.0), for: .normal)
    }
    
    func notFollowing() {
        followingButton.setTitle("Follow", for: .normal)
        followingButton.setTitleColor(UIColor(red: 0 / 255, green: 57 / 255, blue: 211 / 255, alpha: 1.0), for: .normal)
    }
    
    @objc func replyPressed(_ sender : UIButton) {
//        let postResponseViewController = PostResponseViewController(questionID: self.props.reefQuestion._id,
//                                                                    bubbleParentID: nil,
//                                                                    bubbleParentText: self.props.reefQuestion.bubble)
//        self.parentViewController?.navigationController!.pushViewController(postResponseViewController, animated: true)
    }
    
    @objc func sharePressed(_ sender : UIButton) {
        let url = URL(string: "reefapp://question?questionid=" + props.reefQuestion._id.stringValue)!
        let descriptionn = props.reefQuestion.bubble + "\n"
        let activityVC = UIActivityViewController(activityItems: [descriptionn, url], applicationActivities: nil)
        activityVC.completionWithItemsHandler = { activity, success, items, error in
            if success {
                Task {
                    do {
                        let app = App(id: Constants.REALM_APP_ID)
                        let user = app.currentUser!
                        let questionShare = ReefQuestionShare(questionID: self.props.reefQuestion._id, userID: try ObjectId(string: user.id))
                        try await ReefIO.writeToDatabase(objs: [questionShare])
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
        }
//        activityVC.popoverPresentationController?.sourceView = sender
        self.parentViewController?.present(activityVC, animated: true, completion: nil)
    }
    
    func createTagView(reefTags: [ReefTag]) -> UIScrollView? {
        if (reefTags.isEmpty) {
            return nil
        }
        
        var tagButtons: [UIButton] = []
        reefTags.forEach { tag in
            let button = UIButton()
            button.contentEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
            button.setTitle(tag.tag, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 10)
            button.backgroundColor = UIColor.systemBlue
            button.setTitleColor(UIColor.white, for: .normal)
            tagButtons.append(button)
        }
        
        let hstack = UIStackView(arrangedSubviews: tagButtons)
        hstack.axis = .horizontal
        hstack.spacing = 5
        
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.addSubview(hstack)
        
        hstack.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.lessThanOrEqualToSuperview()
        }
        
        hstack.layoutIfNeeded()
        scrollView.snp.makeConstraints { make in
            make.height.equalTo(hstack.subviews[0].snp.height)
        }
        return scrollView
    }
}
