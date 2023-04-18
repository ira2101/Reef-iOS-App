//
//  SourcesViewController.swift
//  Reef
//
//  Created by Ira Einbinder on 2/17/22.
//

import UIKit
import SnapKit

enum SourceViewingType {
    case viewing
    case posting
}

class SourcesViewController: UIViewController {
    var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Sources"
        label.textColor = .black
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    var xImage: UIImageView = {
        var image = UIImage(systemName: "xmark")
        let imageView = UIImageView(image: image)
        imageView.tintColor = .lightGray
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    var websiteTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Source goes here"
        textField.returnKeyType = .default
        textField.backgroundColor = .lightGray.withAlphaComponent(0.1)
        textField.adjustsFontSizeToFitWidth = true
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    var sourcesTableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    var sources: [String] = [] {
        didSet {
            self.sourcesTableView.reloadData()
        }
    }
    
    var viewingType: SourceViewingType = .posting
    
    convenience init(viewingType: SourceViewingType, sources: [String] = []) {
        self.init()
        self.viewingType = viewingType
        self.sources = sources
    }
    
    @objc func xPressed(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        sourcesTableView.delegate = self
        sourcesTableView.dataSource = self
        websiteTextField.delegate = self
        setupView()
    }
    
    func setupView() {
        self.view.backgroundColor = .white
        
        xImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(xPressed(_:))))
        self.view.addSubview(xImage)
        xImage.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(5)
            make.trailing.equalToSuperview().offset(-5)
            make.width.equalTo(xImage.intrinsicContentSize.width)
        }
        
        self.view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(5)
            make.leading.equalToSuperview().offset(5)
            make.trailing.equalTo(xImage.snp.leading).offset(-5)
        }
                
        if self.viewingType == .posting {
            self.view.addSubview(websiteTextField)
            websiteTextField.snp.makeConstraints { make in
                make.top.equalTo(titleLabel.snp.bottom).offset(10)
                make.leading.equalToSuperview().offset(5)
                make.trailing.equalToSuperview().offset(-5)
            }
                        
            self.view.addSubview(sourcesTableView)
            sourcesTableView.snp.makeConstraints { make in
                make.top.equalTo(websiteTextField.snp.bottom).offset(10)
                make.leading.equalToSuperview().offset(5)
                make.trailing.equalToSuperview().offset(-5)
                make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            }
        } else { // else just viewing the sources
            self.view.addSubview(sourcesTableView)
            sourcesTableView.snp.makeConstraints { make in
                make.top.equalTo(titleLabel.snp.bottom).offset(10)
                make.leading.equalToSuperview().offset(5)
                make.trailing.equalToSuperview().offset(-5)
                make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            }
        }
    }
}

extension SourcesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Section = \(section)")
        return self.sources.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var config = cell.defaultContentConfiguration()
        config.text = self.sources[indexPath.row]
        cell.contentConfiguration = config
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return self.viewingType == .posting
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {        
        if editingStyle == .delete {
            self.sources.remove(at: indexPath.row)
            tableView.reloadData()
//            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

extension SourcesViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if !textField.hasText {
            return true
        }
        
        let urls = textField.text!.split(separator: " ")
        urls.forEach {
            self.sources.append(String($0))
        }
        self.sourcesTableView.reloadData()
        textField.text = ""
        
        return true
    }
}
