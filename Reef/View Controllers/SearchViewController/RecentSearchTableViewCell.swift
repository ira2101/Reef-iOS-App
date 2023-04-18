//
//  RecentlySearchedTableViewCell.swift
//  Reef
//
//  Created by Ira Einbinder on 2/16/23.
//

import UIKit
import SnapKit

class RecentSearchTableViewCell: UITableViewCell {
        
    var searchLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        return label
    }()
    
    var xButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .lightGray
        button.imageView!.contentMode = .scaleAspectFit
        return button
    }()
        
    struct Props {
        var index: Int
        var uniqueTag: ReefUniqueTag
        var deleteSearchCallback: ((Int) -> Void)
    }
    
    var props: Props!
    
    convenience init(index: Int, uniqueTag: ReefUniqueTag, deleteSearchCallback: @escaping (Int) -> Void) {
        self.init()
        props = Props(index: index, uniqueTag: uniqueTag, deleteSearchCallback: deleteSearchCallback)
        setupView()
        populateView()
    }
    
    func setupView() {
        let container = UIView()
        self.contentView.addSubview(container)
        container.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-5)
            make.top.equalToSuperview().offset(5)
            make.bottom.equalToSuperview().offset(-5)
        }
        
        container.addSubview(searchLabel)
        container.addSubview(xButton)
        searchLabel.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.trailing.lessThanOrEqualTo(xButton.snp.leading).offset(-5)
        }
        
        xButton.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview()
        }
        
        xButton.addTarget(self, action: #selector(xPressed(_:)), for: .touchUpInside)
    }
    
    func populateView() {
        searchLabel.text = props.uniqueTag.tag
    }
    
    @objc func xPressed(_ sender: UIButton) {
        props.deleteSearchCallback(props.index)
    }
}
