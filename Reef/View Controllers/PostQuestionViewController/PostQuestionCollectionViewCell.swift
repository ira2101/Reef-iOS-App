//
//  PostQuestionCollectionViewCell.swift
//  Reef
//
//  Created by Ira Einbinder on 1/26/22.
//

import UIKit

class PostQuestionCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var tagLabel: UILabel!
    var indexPath: IndexPath!
    var postQuestionViewController: PostQuestionViewController!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(tag: String, indexPath: IndexPath, postQuestionViewController: PostQuestionViewController) {
        self.tagLabel.text = tag
        self.indexPath = indexPath
        self.postQuestionViewController = postQuestionViewController
    }
    
    @IBAction func removeTagPressed(_ sender: UIButton) {
        self.postQuestionViewController.tags.remove(at: indexPath.row)
        self.postQuestionViewController.collectionView.reloadData()
    }
}
