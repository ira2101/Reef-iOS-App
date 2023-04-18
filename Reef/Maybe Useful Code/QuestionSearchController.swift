////
////  QuestionSearchController.swift
////  Reef
////
////  Created by Ira Einbinder on 2/15/23.
////
//
//import UIKit
//import SnapKit
//import RealmSwift
//
//class QuestionSearchResultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
//        
//    var resultsTableView = UITableView()
//    
//    var searchText: String?
//    
//    var searchResults: Results<ReefUniqueTag>?
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        resultsTableView.delegate = self
//        resultsTableView.dataSource = self
//        setupView()
//    }
//    
//    func setupView() {
//        self.view.backgroundColor = .systemBackground
//        self.view.addSubview(resultsTableView)
//        resultsTableView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
//    }
//    
//    func searchFor(text: String) {
//        searchText = text
//        Task {
//            let app = App(id: Constants.REALM_APP_ID)
//            let user = app.currentUser!
//            do {
//                let realm = try await Realm(configuration: user.configuration(partitionValue: Constants.GLOBAL_PARTITION))
//                let tags = realm.objects(ReefUniqueTag.self).where {
//                    $0.tag.contains(text.lowercased())
//                }
//                
//                searchResults = tags
//                DispatchQueue.main.async {
//                    self.resultsTableView.reloadData()
//                }
//                
//            } catch {
//                print(error.localizedDescription)
//            }
//        }
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return searchResults?.count ?? 0
//
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = UITableViewCell()
//        var config = cell.defaultContentConfiguration()
//        let uniqueTag = searchResults![indexPath.row]
//        config.text = uniqueTag.tag
//        cell.contentConfiguration = config
//        return cell
//    }
//    
//    
//    
//}
//
//class QuestionSearchController: UIViewController, UISearchResultsUpdating, UISearchBarDelegate {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        setupView()
//    }
//    
//    var questionSearchController: UISearchController!
//    var questionSearchResultsViewController: QuestionSearchResultsViewController!
//    
//    func setupView() {
//        self.view.backgroundColor = .systemBackground
//                
//        questionSearchResultsViewController = QuestionSearchResultsViewController()
//        questionSearchController = UISearchController(searchResultsController: questionSearchResultsViewController)
//        questionSearchController.searchBar.delegate = self
//        questionSearchResultsViewController.view.snp.makeConstraints { make in
//            make.edges.equalTo(questionSearchController.view.safeAreaLayoutGuide.snp.edges)
//        }
//
//        self.navigationItem.searchController = questionSearchController
//        questionSearchController.searchResultsUpdater = self
//    }
//    
//    
////    override func viewDidAppear(_ animated: Bool) {
////        questionSearchController.searchBar.searchTextField.becomeFirstResponder()
////    }
//    
//    
//    func updateSearchResults(for searchController: UISearchController) {
//        guard let text = searchController.searchBar.text else {
//            return
//        }
//        
//        questionSearchResultsViewController.searchFor(text: text)
//    }
//    
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        let vc = UIViewController()
//        vc.view.backgroundColor = .systemYellow
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
//    
//    
//    
//    
//    
//
//}
//
//
