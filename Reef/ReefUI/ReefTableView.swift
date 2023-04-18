//
//  ReefTableView.swift
//  Reef
//
//  Created by Ira Einbinder on 7/22/22.
//

import RealmSwift
import UIKit

protocol ReefTableViewDelegate: AnyObject {
    /// Create a data observable to  update the table when there are changes to its data
    func reefCreateDataObserver(_ tableView: ReefTableView) -> NotificationToken?
    
    /// Return the number of rows in a given section of the table view
    func reefNumberOfRowsInSection(_ tableView: UITableView, _ section: Int) -> Int
    
    /// Insert a cell at a particular index of the table view
    func reefInsertCellAtIndex(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell
    
    /// Called when a table view cell has been tapped/selected
    func reefDidSelectRowAtIndex(_ tableView: UITableView, _ indexPath: IndexPath) -> ()
}

extension ReefTableViewDelegate {
    func reefDidSelectRowAtIndex(_ tableView: UITableView, _ indexPath: IndexPath) -> () {}
}

class ReefTableView: UITableView, UITableViewDelegate, UITableViewDataSource {

    weak var reefDelegate: ReefTableViewDelegate?
    
    var dataObserver: NotificationToken?
        
    init() {
        super.init(frame: CGRect.zero, style: .plain)
        delegate = self
        dataSource = self
    }
    
    @available(*, unavailable) required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // One time create data observable
        if dataObserver == nil {
            dataObserver = reefDelegate?.reefCreateDataObserver(self)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reefDelegate!.reefNumberOfRowsInSection(tableView, section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return reefDelegate!.reefInsertCellAtIndex(tableView, indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        reefDelegate?.reefDidSelectRowAtIndex(tableView, indexPath)
    }

}
