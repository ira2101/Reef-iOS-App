//
//  SearchResultsViewController.swift
//  Reef
//
//  Created by Ira Einbinder on 3/9/23.
//

import UIKit
import SnapKit

class SearchResultsViewController: UIViewController {
    
    struct Props {
        var uniqueTag: ReefUniqueTag
    }
    
    var props: Props!
    
    var searchResultsTableView: UITableView!
    
    convenience init(uniqueTag: ReefUniqueTag) {
        self.init()
        props = Props(uniqueTag: uniqueTag)
        searchResultsTableView = SearchResultsTableView(uniqueTag: uniqueTag)
        setupView()
        populateView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = props.uniqueTag.tag

        self.view.backgroundColor = .systemGray
    }
    
    func setupView() {
        self.view.addSubview(searchResultsTableView)
        searchResultsTableView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide.snp.edges)
        }
    }
    
    func populateView() {
        
    }

}
