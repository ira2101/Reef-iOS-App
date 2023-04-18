//
//  VoteViewController.swift
//  Reef
//
//  Created by Ira Einbinder on 2/7/22.
//

import UIKit
import RealmSwift
import SnapKit

class VoteViewController: UIViewController {
        
    var reefResponseLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        
        return label
    }()
    
    var reefLevelLabel: UILabel = {
        let label = UILabel()
        label.text = "Reef lvl. 1"
        label.textColor = .black
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        
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
    
    var titleTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        textView.textContainer.lineFragmentPadding = 0
        return textView
    }()
    
    struct Props {
        var reefBubble: ReefBubble!
    }
    
    var props: Props!
    
    
    func configure(reefBubble: ReefBubble) {
        self.props = Props(reefBubble: reefBubble)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupView()
        populateView()
    }
    
    func setupView() {
        let topstack = UIStackView(arrangedSubviews: [reefLevelLabel, threedotsButton])
        topstack.axis = .horizontal
        topstack.alignment = .center
        topstack.distribution = .fill

        threedotsButton.snp.makeConstraints { make in
            make.width.equalTo(threedotsButton.intrinsicContentSize.width)
            make.height.equalTo(threedotsButton.intrinsicContentSize.height)
        }
        
        let footer : ReefHorizontalStackView =
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

        footer.alignment = .bottom

        messageButton.snp.makeConstraints { make in
            make.height.equalTo(shareButton.intrinsicContentSize.height)
            make.width.equalTo(shareButton.intrinsicContentSize.width)
        }

        upButton.snp.makeConstraints { make in
            make.height.equalTo(downButton.intrinsicContentSize.height * 1.75)
            make.width.equalTo(downButton.intrinsicContentSize.width * 1.75)
        }
        
        let fullstack: ReefVerticalStackView =
        ReefVerticalStackView()
            .addArrangedSubview(topstack)
            .addArrangedSubview(titleTextView)
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
            .addArrangedSubview(footer)
            .setSpacing(0)
            .setPaddingLeading(10)
            .setPaddingTrailing(10)
            .setPaddingTop(5)

        self.view.addSubview(fullstack)
        fullstack.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
        }
        
        self.view.addSubview(downvoteLabel)
        downvoteLabel.snp.makeConstraints { make in
            make.top.equalTo(downButton.snp.bottom).priority(ConstraintPriority.required)
            make.centerX.equalTo(downButton.snp.centerX).priority(ConstraintPriority.required)
        }
        
        self.view.addSubview(minusLabel)
        minusLabel.snp.makeConstraints { make in
            make.top.equalTo(minusButton.snp.bottom).priority(ConstraintPriority.required)
            make.centerX.equalTo(minusButton.snp.centerX).priority(ConstraintPriority.required)
        }
        
        self.view.addSubview(upvoteLabel)
        upvoteLabel.snp.makeConstraints { make in
            make.top.equalTo(upButton.snp.bottom).priority(ConstraintPriority.required)
            make.centerX.equalTo(upButton.snp.centerX).priority(ConstraintPriority.required)
        }
        
        self.view.addSubview(seenLabel)
        seenLabel.snp.makeConstraints { make in
            make.top.equalTo(upButton.snp.bottom).priority(ConstraintPriority.required)
            make.leading.equalToSuperview().offset(10)
        }
        
        downvoteLabel.isHidden = true
        minusLabel.isHidden = true
        upvoteLabel.isHidden = true
        seenLabel.isHidden = true
        
        let separatorView = UIView()
        separatorView.backgroundColor = .clear
        self.view.addSubview(separatorView)
        separatorView.snp.makeConstraints { make in
            make.top.equalTo(seenLabel.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            make.height.equalTo(5)
        }
    }
    
    func populateView() {
        reefLevelLabel.text = "Reef Level " + self.props.reefBubble.reefLevel.description
        titleTextView.text = self.props.reefBubble.bubble
        
        Task {
            do {
                let upvotes = try await self.props.reefBubble.getUpvotes()
                let neutralvotes = try await self.props.reefBubble.getNeutralvotes()
                let downvotes = try await self.props.reefBubble.getDownvotes()
                DispatchQueue.main.async {
                    self.upvoteLabel.text = upvotes.description
                    self.minusLabel.text = neutralvotes.description
                    self.downvoteLabel.text = downvotes.description
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
    
    
    
    @objc func sourcesPressed(_ sender: UIButton) {
        let sourcesViewController = SourcesViewController(viewingType: .viewing, sources: Array(self.props.reefBubble.sources))
        sourcesViewController.modalPresentationStyle = .formSheet
        self.present(sourcesViewController, animated: true)
    }
    
    @objc func replyPressed(_ sender : UIButton) {
        let postResponseViewController = PostResponseViewController(questionID: self.props.reefBubble.questionID,
                                                                    bubbleParentID: self.props.reefBubble._id,
                                                                    bubbleParentText: self.props.reefBubble.bubble)
        self.navigationController!.pushViewController(postResponseViewController, animated: true)
    }
}
