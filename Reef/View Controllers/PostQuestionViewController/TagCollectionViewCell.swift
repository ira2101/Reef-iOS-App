//
//  TagCollectionViewCell.swift
//  Reef
//
//  Created by Ira Einbinder on 5/1/22.
//

import UIKit
import SnapKit

class TagCollectionViewCell: UICollectionViewCell {
    var label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        return label
    }()
    
    var xButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "xmark.circle")
        button.setImage(image, for: .normal)
        button.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(scale: .medium), forImageIn: .normal)
        button.tintColor = .white
//        button.addTarget(self, action: #selector(removeTagPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    var indexPath: IndexPath!
    var postQuestionViewController: PostQuestionViewController!
    
    convenience init(tag: String, indexPath: IndexPath, postQuestionViewController: PostQuestionViewController) {
        self.init()
        label.text = tag
        self.indexPath = indexPath
        self.postQuestionViewController = postQuestionViewController
        setupView()
    }
    
    func configure(tag: String, indexPath: IndexPath, postQuestionViewController: PostQuestionViewController) {
        label.text = tag
        self.indexPath = indexPath
        self.postQuestionViewController = postQuestionViewController
        setupView()
    }
    
    func setupView() {
        self.backgroundColor = .black
//        self.contentView.isUserInteractionEnabled = false
        
        self.addSubview(label)
        self.addSubview(xButton)
        xButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.trailing.equalToSuperview().offset(-5)
            make.width.equalTo(xButton.intrinsicContentSize.width)
        }
        
        label.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.lessThanOrEqualTo(xButton.snp.leading).offset(-5)
        }
        
        self.xButton.addTarget(self, action: #selector(removeTagPressed(_:)), for: .touchUpInside)
    }
    
    @objc func removeTagPressed(_ sender: UIButton) {
        self.postQuestionViewController.tags.remove(at: indexPath.row)
        self.postQuestionViewController.collectionView.reloadData()
    }
    
//    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
//        guard isUserInteractionEnabled else { return nil }
//        guard !isHidden else { return nil }
//        guard alpha >= 0.01 else { return nil }
//        guard self.point(inside: point, with: event) else { return nil }
//
//        if self.xButton.point(inside: convert(point, to: self.xButton), with: event) {
//            return self.xButton
//        }
//
//        return super.hitTest(point, with: event)
//    }
}
