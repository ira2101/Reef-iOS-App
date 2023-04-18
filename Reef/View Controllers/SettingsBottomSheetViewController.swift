//
//  SettingsBottomSheetViewController.swift
//  Reef
//
//  Created by Ira Einbinder on 1/30/23.
//

import Foundation
import UIKit
import SnapKit
import RealmSwift

class SettingsBottomSheetViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        self.view.backgroundColor = .systemBackground
        
        
        let settings = createPanelItem(named: "Settings")
        self.view.addSubview(settings)
        settings.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(5)
            make.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing)
        }

        let logout = createPanelItem(named: "Logout")
        self.view.addSubview(logout)
        logout.snp.makeConstraints { make in
            make.top.equalTo(settings.snp.bottom).offset(5)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(logoutPressed(_:)))
        logout.addGestureRecognizer(gesture)
    }
    
    @objc func logoutPressed(_ sender: UIButton) {
        let app = App(id: Constants.REALM_APP_ID)
        let user = app.currentUser!
        user.logOut { error in
            if error == nil {
                DispatchQueue.main.async {
                    let loginViewController = LoginViewController()
                    loginViewController.modalPresentationStyle = .fullScreen
                    self.present(loginViewController, animated: true)
                }
            } else {
                print(error?.localizedDescription ?? "")
            }
        }
    }
    
    func createPanelItem(named name: String) -> UIView {
        let container = UIView()
        
        let label = UILabel()
        label.text = name
        
        container.addSubview(label)
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        return container
    }
}

