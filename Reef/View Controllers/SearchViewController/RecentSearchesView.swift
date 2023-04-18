//
//  RecentSearchesView.swift
//  Reef
//
//  Created by Ira Einbinder on 2/17/23.
//

import UIKit
import SnapKit
import RealmSwift

class RecentSearchesView: UIView {
    
    let recentSearchesFileName = "recentSearches.txt"
        
    let recentSearchTableView = UITableView()
    
    let recentSearchesLabel: UILabel = {
        let label = UILabel()
        label.text = "Recent Searches"
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    let clearSearchesLabel: UILabel = {
        let label = UILabel()
        label.text = "Clear"
        label.textColor = .black
        return label
    }()
    
    convenience init(chicken: String) {
        self.init()
        recentSearchTableView.delegate = self
        recentSearchTableView.dataSource = self
        setupView()
        populateView()
    }
    
    func setupView() {
        self.backgroundColor = .systemBackground
        
        let container = UIView()
        container.addSubview(recentSearchesLabel)
        container.addSubview(clearSearchesLabel)
        recentSearchesLabel.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
        }
        clearSearchesLabel.snp.makeConstraints { make in
            make.trailing.top.bottom.equalToSuperview()
        }

        self.addSubview(container)
        self.addSubview(recentSearchTableView)

        container.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(self.safeAreaLayoutGuide.snp.leading).offset(10)
            make.trailing.equalTo(self.safeAreaLayoutGuide.snp.trailing).offset(-10)
            make.bottom.equalTo(recentSearchTableView.snp.top)
        }

        recentSearchTableView.snp.makeConstraints { make in
            make.leading.equalTo(self.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(self.safeAreaLayoutGuide.snp.trailing)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }

        let gesture = UITapGestureRecognizer(target: self, action: #selector(clearRecentSearchesPressed(_:)))
        clearSearchesLabel.isUserInteractionEnabled = true
        clearSearchesLabel.addGestureRecognizer(gesture)
    }
    
    var recentSearches: [String] = []
    
    func populateView() {
        recentSearches = readAllSearches()
        recentSearches.reverse()
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
    
    @objc func clearRecentSearchesPressed(_ sender: UILabel) {
        guard let recentSearchesFile = getRecentSearchesFile() else {
            return
        }
        
        let emptyString = ""
        try? emptyString.write(toFile: recentSearchesFile.path, atomically: false, encoding: .utf8)
        
        recentSearches = readAllSearches()
        recentSearchTableView.reloadData()
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
    
    func removeSearchEntry(at index: Int) {
        guard let recentSearchesFile = getRecentSearchesFile() else {
            return
        }
        
        var searches = readAllSearches()
        searches.remove(at: index)
        
        var updatedSearches = ""
        searches.forEach {
            updatedSearches += $0 + "\n"
        }
        
        try? updatedSearches.write(toFile: recentSearchesFile.path, atomically: false, encoding: .utf8)
        
        recentSearches = readAllSearches()
        recentSearches.reverse()
        recentSearchTableView.reloadData()
    }
}

extension RecentSearchesView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.recentSearches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let recentJson = self.recentSearches[indexPath.row].data(using: .utf8)
        let jsonDecoder = JSONDecoder()
        let uniqueTag = try! jsonDecoder.decode(ReefUniqueTag.self, from: recentJson!)
        
        return RecentSearchTableViewCell(index: indexPath.row, uniqueTag: uniqueTag) {
            self.removeSearchEntry(at: self.recentSearches.count - 1 - $0)
//            self.recentSearchTableView.beginUpdates()
//            self.recentSearchTableView.endUpdates()
        }
        
//        return RecentSearchTableViewCell(index: indexPath.row, searchText: self.recentSearches[indexPath.row]) {
//            self.removeSearchEntry(at: self.recentSearches.count - 1 - $0)
////            self.recentSearchTableView.beginUpdates()
////            self.recentSearchTableView.endUpdates()
//        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let recentJson = self.recentSearches[indexPath.row].data(using: .utf8)
        let jsonDecoder = JSONDecoder()
        let uniqueTag = try! jsonDecoder.decode(ReefUniqueTag.self, from: recentJson!)
        
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

}

//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        guard let recentSearchesFile = getRecentSearchesFile() else {
//            return
//        }
//
//        guard let text = searchBar.text else {
//            return
//        }
//
//        var searches = readAllSearches()
//        for i in 0..<searches.count {
//            if searches[i].lowercased() == text.lowercased() {
//                searches.remove(at: i)
//                break
//            }
//        }
//
//        var updatedSearches = ""
//        searches.forEach {
//            updatedSearches += $0 + "\n"
//        }
//        updatedSearches += searchBar.text! + "\n"
//
//        try? updatedSearches.write(toFile: recentSearchesFile.path, atomically: false, encoding: .utf8)
//
//        recentSearches = readAllSearches()
//        recentSearches.reverse()
//        recentSearchTableView.reloadData()
//
////        let newLine = "\n"
////        guard let text = searchBar.text, let data = (text + newLine).data(using: .utf8) else {
////            return
////        }
////
////        if let fileHandle = try? FileHandle(forWritingTo: recentSearchesFile) {
////            try! fileHandle.seekToEnd()
////            try! fileHandle.write(contentsOf: data)
////            try! fileHandle.close()
////        }
//
////        let fileContents = try! String(contentsOf: recentSearchesFile, encoding: .utf8)
////        try? text.write(toFile: recentSearchesFile.path, atomically: false, encoding: .utf8)
////        try! fileManager.contentsOfDirectory(atPath: path.path).forEach {
////            print("IRA = " + $0)
////        }
//    }
