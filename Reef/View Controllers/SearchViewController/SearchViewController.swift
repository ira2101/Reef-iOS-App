//
//  SearchViewController.swift
//  Reef
//
//  Created by Ira Einbinder on 2/16/23.
//

import UIKit
import SnapKit

class SearchViewController: UIViewController, UISearchBarDelegate, UITextFieldDelegate {
        
    let searchBar = UISearchBar()
        
    let searchView = SearchView(chicken: "Quack")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        searchBar.searchTextField.delegate = self
        setupView()
        populateView()
    }
    
    let recentSearchesView = RecentSearchesView(chicken: "Duck")
    
    func setupView() {
        self.view.backgroundColor = .systemBackground
        
        let barButton = UIBarButtonItem(image: .init(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(backButtonPressed(_:)))
        self.navigationItem.leftBarButtonItems = [barButton]
        self.navigationItem.titleView = searchBar
        searchBar.becomeFirstResponder()
        
        self.view.addSubview(recentSearchesView)
        recentSearchesView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide.snp.edges)
        }
    }
    
    var recentSearches: [String] = []
    
    func populateView() {
    }
    
    @objc func backButtonPressed(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }

    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        recentSearchesView.searchBarSearchButtonClicked(searchBar)
        searchBar.resignFirstResponder()
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text else {
            return
        }
        
        searchView.searchFor(text: text)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            self.view.addSubview(searchView)
            searchView.snp.makeConstraints { make in
                make.edges.equalTo(self.view.safeAreaLayoutGuide.snp.edges)
            }
        } else {
            searchView.removeFromSuperview()
        }
    }
}
