//
//  SearchViewTableViewCell.swift
//  Reef
//
//  Created by Ira Einbinder on 3/9/23.
//

import UIKit
import SnapKit

class SearchViewTableViewCell: UITableViewCell {
        
    var searchLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        return label
    }()
    
        
    struct Props {
        var index: Int
        var searchText: String
    }
    
    var props: Props!
    
    convenience init(index: Int, searchText: String) {
        self.init()
        props = Props(index: index, searchText: searchText)
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
        searchLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func populateView() {
        searchLabel.text = props.searchText
    }
}
