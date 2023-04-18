//
//  SearchView.swift
//  Reef
//
//  Created by Ira Einbinder on 2/17/23.
//

import UIKit
import SnapKit
import RealmSwift

class SearchView: UIView {
    
    let recentSearchesFileName = "recentSearches.txt"
    
    var searchTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemBlue
        return tableView
    }()
    
    var searchResults: Results<ReefUniqueTag>?
    
    var searchText: String?

    convenience init(chicken: String) {
        self.init()
        searchTableView.delegate = self
        searchTableView.dataSource = self
        setupView()
        populateView()
    }
    
    func setupView() {
        self.backgroundColor = .systemBackground

        self.addSubview(searchTableView)
        searchTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func populateView() {
        
    }
    
    func searchFor(text: String) {
        searchText = text
        Task {
            let app = App(id: Constants.REALM_APP_ID)
            let user = app.currentUser!
            do {
                let realm = try await Realm(configuration: user.configuration(partitionValue: Constants.GLOBAL_PARTITION))
                let tags = realm.objects(ReefUniqueTag.self).where {
                    $0.tag.contains(text.lowercased())
                }
                
                searchResults = tags
                DispatchQueue.main.async {
                    self.searchTableView.reloadData()
                }
                
            } catch {
                print(error.localizedDescription)
            }
        }
    }

}

extension SearchView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults?.count ?? 0

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let uniqueTag = searchResults![indexPath.row]
        return SearchViewTableViewCell(index: indexPath.row, searchText: uniqueTag.tag)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let uniqueTag = searchResults![indexPath.row]
        
        addToRecentSearch(uniqueTag: uniqueTag)
        
        let searchResultsViewController = SearchResultsViewController(uniqueTag: uniqueTag)
        searchResultsViewController.modalPresentationStyle = .fullScreen
        self.parentViewController?.navigationController?.pushViewController(searchResultsViewController, animated: true)
    }
    
    func addToRecentSearch(uniqueTag: ReefUniqueTag) {
        print("Stage 1")
        guard let recentSearchesFile = getRecentSearchesFile() else {
            return
        }
        print("Stage 2")
        var searches = readAllSearches()
        let jsonDecoder = JSONDecoder()
        for i in 0..<searches.count {
            let recentJson = searches[i].data(using: .utf8)
            let recent = try! jsonDecoder.decode(ReefUniqueTag.self, from: recentJson!)
            
            if recent._id == uniqueTag._id {
                searches.remove(at: i)
                break
            }
        }
        print("Stage 3")
        let jsonEncoder = JSONEncoder()
        let jsonData = try! jsonEncoder.encode(uniqueTag)
//        guard let jsonData = try? jsonEncoder.encode(uniqueTag) else  {
//            return
//        }
        
        let json = String(data: jsonData, encoding: String.Encoding.utf8)
        
        var updatedSearches = ""
        searches.forEach {
            updatedSearches += $0 + "\n"
        }
        updatedSearches += json! + "\n"
        print("Stage 4")
        try? updatedSearches.write(toFile: recentSearchesFile.path, atomically: false, encoding: .utf8)
        
        print("Stage Complete")
    }
    
    func getRecentSearchesFile() -> URL? {
        let fileManager = FileManager.default
        guard let documentDir = try? fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true) else {
            return nil
        }
        
        let recentSearchesFile = documentDir.appendingPathComponent(recentSearchesFileName)
        if !fileManager.fileExists(atPath: recentSearchesFile.path) {
            // exit if we are unable to make the file
            if !fileManager.createFile(atPath: recentSearchesFile.path, contents: nil) {
                return nil
            }
        }
        
        return recentSearchesFile
    }
    
    func readAllSearches() -> [String] {
        if let recentSearchesFile = getRecentSearchesFile() {
            let text = try! String(contentsOf: recentSearchesFile, encoding: .utf8)
            var searches = text.components(separatedBy: .newlines)

            // The ending has \n which creates an empty entry
            searches.removeLast()
            return searches
        }
        
        return []
    }
}
