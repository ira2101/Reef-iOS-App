//
//  ConversationTableViewCell.swift
//  Reef
//
//  Created by Ira Einbinder on 1/17/22.
//
import UIKit
import RealmSwift
import SnapKit

class ConversationTableViewCell: UITableViewCell {
    var reefLevelLabel: UILabel = {
        let label = UILabel()
        label.text = "Reef lvl. 1"
        label.textColor = .black
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    var reefResponseLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    
    var threedotsButton: UIButton = {
        let button = UIButton()
        let messageIcon = UIImage(systemName: "ellipsis")
        button.setImage(messageIcon, for: .normal)
        button.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(scale: .medium), forImageIn: .normal)
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
    
    var downButton: UIButton = {
        let button = UIButton()
        let downIcon = UIImage(systemName: "chevron.down", withConfiguration: UIImage.SymbolConfiguration(pointSize: 18.0, weight: UIImage.SymbolWeight.bold, scale: UIImage.SymbolScale.default))
        button.setImage(downIcon, for: .normal)
        button.layer.borderColor = UIColor(red: 95 / 255, green: 95 / 255, blue: 95 / 255, alpha: 1).cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.tintColor = UIColor(red: 95 / 255, green: 95 / 255, blue: 95 / 255, alpha: 1)
        button.addTarget(self, action: #selector(disagreePressed(_:)), for: .touchUpInside)
        return button
    }()
    
    var minusButton: UIButton = {
        let button = UIButton()
        let minusIcon = UIImage(systemName: "minus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 18.0, weight: UIImage.SymbolWeight.bold, scale: UIImage.SymbolScale.default))
        button.setImage(minusIcon, for: .normal)
        button.layer.borderColor = UIColor(red: 95 / 255, green: 95 / 255, blue: 95 / 255, alpha: 1).cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.tintColor = UIColor(red: 95 / 255, green: 95 / 255, blue: 95 / 255, alpha: 1)
        button.addTarget(self, action: #selector(neutralPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    var upButton: UIButton = {
        let button = UIButton()
        let upIcon = UIImage(systemName: "chevron.up", withConfiguration: UIImage.SymbolConfiguration(pointSize: 18.0, weight: UIImage.SymbolWeight.bold, scale: UIImage.SymbolScale.default))
        button.setImage(upIcon, for: .normal)
        button.layer.borderColor = UIColor(red: 95 / 255, green: 95 / 255, blue: 95 / 255, alpha: 1).cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.tintColor = UIColor(red: 95 / 255, green: 95 / 255, blue: 95 / 255, alpha: 1)
        button.addTarget(self, action: #selector(agreePressed(_:)), for: .touchUpInside)
        return button
    }()
    
    var sourcesButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(sourcesPressed(_:)), for: .touchUpInside)
        button.setTitle("Sources", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .regular)
        return button
    }()
    
    var downvoteLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    var minusLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    var upvoteLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    var seenLabel: UILabel = {
        let label = UILabel()
        label.text = "seen by 400.5k"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    let separatorView = UIView()
    
    struct Props {
        var reefBubble : ReefBubble!
    }
    
    var props: Props!

    convenience init(reefBubble : ReefBubble) {
        self.init()
        self.props = Props(reefBubble: reefBubble)
        self.reefResponseLabel.text = reefBubble.bubble
        setupView()
        populateView()
    }

    func setupView() {
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        
        let newContentView = UIView()
        newContentView.backgroundColor = .systemBackground
        newContentView.layer.cornerRadius = 5
        self.addSubview(newContentView)
        newContentView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(5)
            make.trailing.equalToSuperview().offset(-5)
        }
                
        let cellFooter : ReefHorizontalStackView =
        ReefHorizontalStackView()
            .addArrangedSubview(
                ReefHorizontalStackView()
                    .addArrangedSubview(messageButton)
                    .addArrangedSubview(shareButton)
                    .setSpacing(8)
                    .setDistribution(.fill)
            )
            .addArrangedSubview(
                ReefHorizontalStackView()
                    .addArrangedSubview(downButton)
                    .addArrangedSubview(minusButton)
                    .addArrangedSubview(upButton)
                    .setSpacing(5)
                    .setDistribution(.fillEqually)
            )
            .setSpacing(5)
            .setDistribution(.equalCentering)
        
        cellFooter.alignment = .bottom

        messageButton.snp.makeConstraints { make in
            make.height.equalTo(shareButton.intrinsicContentSize.height)
            make.width.equalTo(shareButton.intrinsicContentSize.width)
        }
    
        upButton.snp.makeConstraints { make in
            make.height.equalTo(downButton.intrinsicContentSize.height * 1.75)
            make.width.equalTo(downButton.intrinsicContentSize.width * 1.75)
        }
        
        let topstack = UIStackView(arrangedSubviews: [reefLevelLabel, threedotsButton])
        topstack.axis = .horizontal
        topstack.alignment = .center
        topstack.distribution = .fill
        
        threedotsButton.snp.makeConstraints { make in
            make.width.equalTo(threedotsButton.intrinsicContentSize.width)
            make.height.equalTo(threedotsButton.intrinsicContentSize.height)
        }
        
        let vstack1 : ReefVerticalStackView =
        ReefVerticalStackView()
            .addArrangedSubview(topstack)
            .addArrangedSubview(reefResponseLabel)
            .addArrangedSubview(if: self.props.reefBubble.sources.count > 0, then: {
                let sourceContainer = UIView()
                sourceContainer.heightAnchor.constraint(equalToConstant: 20).isActive = true
                sourceContainer.addSubview(sourcesButton)
                sourcesButton.snp.makeConstraints { make in
                    make.top.equalTo(sourceContainer.snp.top)
                    make.trailing.equalTo(sourceContainer.snp.trailing)
                    make.bottom.equalTo(sourceContainer.snp.bottom)
                }
                
                sourcesButton.setTitle("\(self.props.reefBubble.sources.count) \(self.props.reefBubble.sources.count > 1 ? "Sources" : "Source")", for: .normal)
                
                return sourceContainer
            })
            .addArrangedSubview(cellFooter)
            .setSpacing(0)
            .setPaddingLeading(10)
            .setPaddingTrailing(10)
            .setPaddingTop(5)
                
        newContentView.addSubview(vstack1)
        vstack1.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
//            make.edges.equalToSuperview()
        }
        
        
        newContentView.addSubview(downvoteLabel)
        downvoteLabel.snp.makeConstraints { make in
            make.top.equalTo(downButton.snp.bottom).priority(ConstraintPriority.required)
            make.centerX.equalTo(downButton.snp.centerX).priority(ConstraintPriority.required)
        }
        
        newContentView.addSubview(minusLabel)
        minusLabel.snp.makeConstraints { make in
            make.top.equalTo(minusButton.snp.bottom).priority(ConstraintPriority.required)
            make.centerX.equalTo(minusButton.snp.centerX).priority(ConstraintPriority.required)
        }
        
        newContentView.addSubview(upvoteLabel)
        upvoteLabel.snp.makeConstraints { make in
            make.top.equalTo(upButton.snp.bottom).priority(ConstraintPriority.required)
            make.centerX.equalTo(upButton.snp.centerX).priority(ConstraintPriority.required)
        }
        
        newContentView.addSubview(seenLabel)
        seenLabel.snp.makeConstraints { make in
            make.top.equalTo(upButton.snp.bottom).priority(ConstraintPriority.required)
            make.leading.equalToSuperview().offset(10)
        }
        
        downvoteLabel.isHidden = true
        minusLabel.isHidden = true
        upvoteLabel.isHidden = true
        seenLabel.isHidden = true
        
        separatorView.backgroundColor = .clear
        newContentView.addSubview(separatorView)
        separatorView.snp.makeConstraints { make in
            make.top.equalTo(seenLabel.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(2)
        }
        
        let reportBubble = UIAction(title: "Flag Bubble", image: UIImage(systemName: "flag"), discoverabilityTitle: "Flag Bubble") { action in
            print(action)
            Task {
                do {
                    let app = App(id: Constants.REALM_APP_ID)
                    let user = app.currentUser!
                    let flag = ReefBubbleFlag(bubbleID: self.props.reefBubble._id, userID: try ObjectId(string: user.id), reason: "")
                    try await ReefIO.writeToDatabase(objs: [flag])
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        threedotsButton.showsMenuAsPrimaryAction = true
        threedotsButton.menu = UIMenu(title: "", options: .displayInline, children: [reportBubble])
        
        //is this bad to do? It fixes my button problem though.
        contentView.isUserInteractionEnabled = false
    }
    
    func populateView() {
        reefLevelLabel.text = "Reef Level " + self.props.reefBubble.reefLevel.description
        
        Task {
            do {
                let upvotes = try await self.props.reefBubble.getUpvotes()
                let neutralvotes = try await self.props.reefBubble.getNeutralvotes()
                let downvotes = try await self.props.reefBubble.getDownvotes()
                let seenby = try await props.reefBubble.getSeenBy()
//                let replies = try await props.reefBubble.getReplies()
                DispatchQueue.main.async {
                    self.upvoteLabel.text = upvotes.description
                    self.minusLabel.text = neutralvotes.description
                    self.downvoteLabel.text = downvotes.description
                    self.seenLabel.text = "seen by " + seenby.description
//                    self.messageLabel.text = replies.description
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        
        if let interaction = ReefUser.interaction(with: self.props.reefBubble) {
            if interaction.interactionType == ReefInteractionType.agree.rawValue {
                agreeButtonSelected()
                showResults()
            } else if interaction.interactionType == ReefInteractionType.neutral.rawValue {
                neutralButtonSelected()
                showResults()
            } else if interaction.interactionType == ReefInteractionType.disagree.rawValue {
                disagreeButtonSelected()
                showResults()
            }
        }
    }
    
    func agreeButtonSelected() {
        upButton.layer.borderColor = UIColor(red: 27 / 255, green: 133 / 255, blue: 1 / 255, alpha: 1).cgColor
        upButton.layer.backgroundColor = UIColor(red: 37 / 255, green: 181 / 255, blue: 1 / 255, alpha: 1).cgColor
        upButton.tintColor = .white
    }
    
    func neutralButtonSelected() {
        minusButton.layer.borderColor = UIColor(red: 248 / 255, green: 184 / 255, blue: 8 / 255, alpha: 1).cgColor
        minusButton.layer.backgroundColor = UIColor(red: 239 / 255, green: 190 / 255, blue: 57 / 255, alpha: 1).cgColor
        minusButton.tintColor = .white
    }
    
    func disagreeButtonSelected() {
        downButton.layer.borderColor = UIColor(red: 121 / 255, green: 0 / 255, blue: 0 / 255, alpha: 1).cgColor
        downButton.layer.backgroundColor = UIColor(red: 255 / 255, green: 36 / 255, blue: 36 / 255, alpha: 1).cgColor
        downButton.tintColor = .white
    }
    
    func showResults() {
        self.downvoteLabel.isHidden = false
        self.minusLabel.isHidden = false
        self.upvoteLabel.isHidden = false
        self.seenLabel.isHidden = false
    }
        
    @objc func agreePressed(_ sender : UIButton) {
        if ReefUser.interaction(with: self.props.reefBubble) != nil {
            return
        }
        
        Task {
            do {
                try await self.props.reefBubble.upvote()
                let upvotes = try await self.props.reefBubble.getUpvotes()
                let neutralvotes = try await self.props.reefBubble.getNeutralvotes()
                let downvotes = try await self.props.reefBubble.getDownvotes()
                DispatchQueue.main.async {
                    self.upvoteLabel.text = upvotes.description
                    self.minusLabel.text = neutralvotes.description
                    self.downvoteLabel.text = downvotes.description
                    self.agreeButtonSelected()
                    self.showResults()
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    
    @objc func disagreePressed(_ sender: UIButton) {
        if ReefUser.interaction(with: self.props.reefBubble) != nil {
            return
        }
                
        Task {
            do {
                try await self.props.reefBubble.downvote()
                let upvotes = try await self.props.reefBubble.getUpvotes()
                let neutralvotes = try await self.props.reefBubble.getNeutralvotes()
                let downvotes = try await self.props.reefBubble.getDownvotes()
                DispatchQueue.main.async {
                    self.upvoteLabel.text = upvotes.description
                    self.minusLabel.text = neutralvotes.description
                    self.downvoteLabel.text = downvotes.description
                    self.disagreeButtonSelected()
                    self.showResults()
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    @objc func neutralPressed(_ sender: UIButton) {
        if ReefUser.interaction(with: self.props.reefBubble) != nil {
            return
        }
                
        Task {
            do {
                try await self.props.reefBubble.neutralvote()
                let upvotes = try await self.props.reefBubble.getUpvotes()
                let neutralvotes = try await self.props.reefBubble.getNeutralvotes()
                let downvotes = try await self.props.reefBubble.getDownvotes()
                DispatchQueue.main.async {
                    self.upvoteLabel.text = upvotes.description
                    self.minusLabel.text = neutralvotes.description
                    self.downvoteLabel.text = downvotes.description
                    self.neutralButtonSelected()
                    self.showResults()
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    @objc func replyPressed(_ sender : UIButton) {
        let postResponseViewController = PostResponseViewController(questionID: self.props.reefBubble.questionID,
                                                                    bubbleParentID: self.props.reefBubble._id,
                                                                    bubbleParentText: self.props.reefBubble.bubble)
        self.parentViewController?.navigationController!.pushViewController(postResponseViewController, animated: true)
    }
    
    @objc func sourcesPressed(_ sender: UIButton) {
        let sourcesViewController = SourcesViewController(viewingType: .viewing, sources: Array(self.props.reefBubble.sources))
        sourcesViewController.modalPresentationStyle = .formSheet
        self.parentViewController?.present(sourcesViewController, animated: true)
    }
    
    @objc func sharePressed(_ sender : UIButton) {
        let url = URL(string: "reefapp://bubble?bubbleid=" + props.reefBubble._id.stringValue + "&questionid=" + props.reefBubble.questionID.stringValue)!
        let descriptionn = props.reefBubble.bubble + "\n"
        let activityVC = UIActivityViewController(activityItems: [descriptionn, url], applicationActivities: nil)
        activityVC.completionWithItemsHandler = { activity, success, items, error in
            if success {
                Task {
                    do {
                        let app = App(id: Constants.REALM_APP_ID)
                        let user = app.currentUser!
                        let bubbleShare = ReefBubbleShare(bubbleID: self.props.reefBubble._id, userID: try ObjectId(string: user.id))
                        try await ReefIO.writeToDatabase(objs: [bubbleShare])
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
        }
//        activityVC.popoverPresentationController?.sourceView = sender
        self.parentViewController?.present(activityVC, animated: true, completion: nil)
    }
}
