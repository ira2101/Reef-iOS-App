//
//  LoginViewController.swift
//  Reef
//
//  Created by Ira Einbinder on 1/5/22.
//

// MARK: INFO
// https://docs.mongodb.com/manual/tutorial/model-data-for-schema-versioning/
// https://docs.mongodb.com/realm/sdk/swift/examples/modify-an-object-schema/#std-label-ios-perform-a-schema-migration
// https://docs.mongodb.com/realm/sdk/swift/fundamentals/schema-versions-and-migrations/

// /Users/iraeinbinder/Library/Developer/CoreSimulator/Devices/28B6B375-1E44-420B-B149-1CE3A027658E/data/Containers/Data/Application/076074C8-256D-49AF-AB3B-D94CBD3B1584/Documents/mongodb-realm/reef-xiptp/61df463f6e75bb6560770220

import UIKit
import Foundation
import RealmSwift
import Combine
import SnapKit
import AuthenticationServices


class LoginViewController : UIViewController {
    let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "Email"
        return label
    }()
    
    let passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "Password"
        return label
    }()
    
    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .systemBlue.withAlphaComponent(0.5)
        textField.textContentType = .emailAddress
        return textField
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .systemBlue.withAlphaComponent(0.5)
        textField.textContentType = .password
        return textField
    }()
    
    let signInButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGray
        button.isUserInteractionEnabled = false
        button.setTitle("Sign In", for: .normal)
        button.addTarget(self, action: #selector(loginPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    let seenButton: UIButton = {
        let button = UIButton()
        let messageIcon = UIImage(systemName: "eye.slash.fill")
        button.setImage(messageIcon, for: .normal)
        button.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(scale: .small), forImageIn: .normal)
        button.tintColor = UIColor(red: 95 / 255, green: 95 / 255, blue: 95 / 255, alpha: 1)
        button.addTarget(self, action: #selector(seenPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    let createAccountButton: UIButton = {
        let button = UIButton()
        button.setTitle("create account", for: .normal)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(createAccountPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    let validationLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .systemRed
        label.numberOfLines = 0
        return label
    }()
    
    var isSeen = false
    
    
    override func viewDidLoad() {
        self.view.backgroundColor = .systemBackground
        
        passwordTextField.isSecureTextEntry = true
        
        let vstack: ReefVerticalStackView =
        ReefVerticalStackView()
        .addArrangedSubview(
            ReefVerticalStackView()
            .addArrangedSubview(emailLabel)
            .addArrangedSubview(emailTextField)
            .setSpacing(5)
        )
        .addArrangedSubview(
            ReefVerticalStackView()
            .addArrangedSubview(passwordLabel)
            .addArrangedSubview(passwordTextField)
            .addArrangedSubview(validationLabel)
            .setSpacing(5)
        )
        .setSpacing(10)
        .setPaddingLeading(10)
        .setPaddingTrailing(10)
        
        self.view.addSubview(vstack)
        vstack.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
        }
        
        self.view.addSubview(signInButton)
        signInButton.snp.makeConstraints { make in
            make.top.equalTo(vstack.snp.bottom).offset(10)
            make.centerX.equalTo(vstack.snp.centerX)
        }
        
        self.view.addSubview(createAccountButton)
        createAccountButton.snp.makeConstraints { make in
            make.top.equalTo(signInButton.snp.bottom).offset(5)
            make.centerX.equalTo(signInButton.snp.centerX)
        }
                
        passwordTextField.rightViewMode = .always
        passwordTextField.rightView = seenButton
        passwordTextField.delegate = self
        emailTextField.delegate = self
        emailTextField.tag = 0
        passwordTextField.tag = 1
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(screenTapped(_:)))
        self.view.addGestureRecognizer(gesture)
        
        super.viewDidLoad()
    }
            
    /*
     * Writes the new user's information to the database
     */
    
    func pushUserInformation() async throws {
        let app = App(id: Constants.REALM_APP_ID);
        guard let user = app.currentUser else {
            throw LoginError.userNotLoggedIn
        }
                
        let reefUser = ReefUser(userId: (try! ObjectId(string: user.id)), fullName: "Ira Einbinder", email: Constants.EMAIL, age: 20)
        try await ReefIO.writeToDatabase(objs: [reefUser], partition: Constants.GLOBAL_PARTITION)
    }
    
    @objc func loginPressed(_ sender: UIButton) {
        let query = [
                kSecClass: kSecClassGenericPassword,
                kSecAttrService: "com.reef",
                kSecAttrAccount: emailTextField.text!,
                kSecValueData: passwordTextField.text!.data(using: String.Encoding.utf8)!
            ] as CFDictionary
        
        let saveStatus = SecItemAdd(query, nil)        
        
        Task {
            do {
                
                
                let app = App(id: Constants.REALM_APP_ID);
                
//                static let EMAIL = "iraeinbinder7511111511@gmail.com";
//                static let PASSWORD = "Cat1235!";
                let email = emailTextField.text!
                let password = passwordTextField.text!
                _ = try await app.login(credentials: Credentials.emailPassword(email: email, password: password));
                
                let tabBarController = createReefTabBarController()
                tabBarController.modalPresentationStyle = .fullScreen
                self.present(tabBarController, animated: true)
            } catch {
                print(error.localizedDescription)
                validationLabel.text = error.localizedDescription
            }
        }
    }
    
    @objc func createAccountPressed(_ sender: UIButton) {
        let registerViewController = RegisterViewController()
        registerViewController.modalPresentationStyle = .fullScreen
        self.present(registerViewController, animated: true)
    }
    
    @objc func seenPressed(_ sender: UIButton) {
        self.isSeen = !self.isSeen
        if self.isSeen {
            seenButton.setImage(UIImage(systemName: "eye.fill"), for: .normal)
            passwordTextField.isSecureTextEntry = false
        } else {
            seenButton.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
            passwordTextField.isSecureTextEntry = true
        }
    }
    
    @objc func screenTapped(_ sender: UIButton) {
        self.view.endEditing(true)
    }
    
    func createReefTabBarController() -> UITabBarController {
        let questionNavBar = UINavigationController(rootViewController: QuestionViewController())
        let profileNavBar = UINavigationController(rootViewController: ProfileViewController())
        questionNavBar.tabBarItem = UITabBarItem(title: "Questions", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        profileNavBar.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person.fill"))

        let tabBarViewController: UITabBarController = UITabBarController()
        tabBarViewController.setViewControllers([questionNavBar, profileNavBar], animated: true)
        tabBarViewController.modalPresentationStyle = .fullScreen
        tabBarViewController.tabBar.isTranslucent = true
        tabBarViewController.tabBar.backgroundColor = UIColor.clear
        tabBarViewController.view.backgroundColor = UIColor.systemBackground
        return tabBarViewController
    }
    
    func allowSignIn(_ isAllowed: Bool) {
        if isAllowed {
            signInButton.backgroundColor = .systemBlue
            signInButton.isUserInteractionEnabled = true
        } else {
            signInButton.backgroundColor = .systemGray
            signInButton.isUserInteractionEnabled = false
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if let emailText = self.emailTextField.text, let passwordText = self.passwordTextField.text,
            !emailText.isEmpty && !passwordText.isEmpty {
            self.allowSignIn(true)
        } else {
            self.allowSignIn(false)
        }
    }
}
