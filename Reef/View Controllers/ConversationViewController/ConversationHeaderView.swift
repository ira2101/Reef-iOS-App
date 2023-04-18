//
//  ConversationHeaderView.swift
//  Reef
//
//  Created by Ira Einbinder on 1/7/23.
//

import UIKit
import SnapKit

class ConversationHeaderView: UIView {
    
    var titleTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textContainerInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        textView.textContainer.lineFragmentPadding = 0
        return textView
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 3
        label.textAlignment = .left
        return label
    }()
    
    var downIcon: UIImageView = {
        let image = UIImage(systemName: "chevron.down", withConfiguration: UIImage.SymbolConfiguration(pointSize: 18.0, weight: UIImage.SymbolWeight.bold, scale: UIImage.SymbolScale.default))
        let imageView = UIImageView(image: image)
        imageView.tintColor = UIColor(red: 95 / 255, green: 95 / 255, blue: 95 / 255, alpha: 1)
        return imageView
    }()
    
    struct Props {
        var bubbleText: String
    }
    
    var props: Props!
    
    var isExpanded: Bool = false
    
    convenience init(reefBubble: String) {
        self.init()
        self.props = Props(bubbleText: reefBubble)
        setupView()
        populateView()
    }
    
    func setupView() {
        self.backgroundColor = .systemBackground
        self.addSubview(titleLabel)
        self.addSubview(downIcon)
        self.addSubview(titleTextView)
        setClosedHeaderConstraints()
    }
    
    func setClosedHeaderConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.trailing.equalToSuperview().offset(-10)
            make.leading.equalToSuperview().offset(10)
        }
        downIcon.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.trailing.bottom.equalToSuperview()
        }
        titleTextView.snp.makeConstraints { make in
            make.height.equalTo(0)
        }
    }
    
    func setOpenHeaderConstraints() {
        titleTextView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.trailing.equalToSuperview()
            make.leading.equalToSuperview()
            make.height.equalTo(UIScreen.main.bounds.height * 0.5)
        }
        downIcon.snp.makeConstraints { make in
            make.top.equalTo(titleTextView.snp.bottom)
            make.trailing.bottom.equalToSuperview()
        }
    }
    
    func toggle() {
        self.isExpanded = !self.isExpanded
        titleTextView.contentOffset.y = 0
        
        if self.isExpanded {
            self.titleTextView.snp.removeConstraints()
            self.titleLabel.snp.removeConstraints()
            self.downIcon.snp.removeConstraints()
            
            setOpenHeaderConstraints()
            
            UIView.animate(withDuration: 0.5, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut) {
                self.downIcon.transform = self.downIcon.transform.rotated(by: -1 * 180.0 / 180.0 * CGFloat.pi)
            }
        } else {
            self.titleTextView.snp.removeConstraints()
            self.titleLabel.snp.removeConstraints()
            self.downIcon.snp.removeConstraints()
            
            setClosedHeaderConstraints()
            
            UIView.animate(withDuration: 0.5, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut) {
                self.downIcon.transform = self.downIcon.transform.rotated(by: 180.0 / 180.0 * CGFloat.pi)
            }
        }
    }
    
    func populateView() {
        titleLabel.text = self.props.bubbleText
        titleTextView.text = self.props.bubbleText
    }
}

class FullScreenConversationHeaderView: UIView {
    var conversationHeaderView: ConversationHeaderView!
    var bottomConstraint: Constraint?
    var isExpanded: Bool = false
    
    convenience init(reefBubble: String) {
        self.init()
        conversationHeaderView = ConversationHeaderView(reefBubble: reefBubble)
        setupView()
    }

    func setupView() {
        conversationHeaderView.layer.shadowColor = UIColor.black.cgColor
        conversationHeaderView.layer.shadowOpacity = 0.3
        conversationHeaderView.layer.shadowOffset = CGSize(width: 0, height: 7)
        conversationHeaderView.layer.shadowRadius = 5
        conversationHeaderView.layer.masksToBounds = false
        self.addSubview(conversationHeaderView)
        setClosedHeaderConstraints()
                
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toggle(_:))))
    }
    
    func setClosedHeaderConstraints() {
        conversationHeaderView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        self.bottomConstraint?.deactivate()
    }
    
    func setOpenHeaderConstraints() {
        conversationHeaderView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        self.bottomConstraint?.activate()
    }
    
    @objc func toggle(_ sender : UIButton) {
        self.conversationHeaderView.toggle()
        self.isExpanded = !self.isExpanded
        
        if (self.isExpanded) {
            conversationHeaderView.snp.removeConstraints()
            setOpenHeaderConstraints()
        } else {
            conversationHeaderView.snp.removeConstraints()
            setClosedHeaderConstraints()
        }
    }
}
