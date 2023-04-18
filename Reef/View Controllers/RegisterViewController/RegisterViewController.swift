//
//  RegisterViewController.swift
//  Reef
//
//  Created by Ira Einbinder on 2/1/23.
//

import UIKit
import Foundation
import RealmSwift
import Combine
import SnapKit

// https://www.mongodb.com/docs/atlas/app-services/authentication/email-password/#std-label-auth-run-a-confirmation-function

// https://abhimuralidharan.medium.com/universal-links-in-ios-79c4ee038272

// Twilio Auth Token: 068644b88120083d0a76e86df9caa0e2

//func validate(YourEMailAddress: String) -> Bool {
//    let REGEX: String
//    REGEX = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
//    return NSPredicate(format: "SELF MATCHES %@", REGEX).evaluateWithObject(YourEMailAddress)
//}

//var isValidEmail: Bool {
//   let regularExpressionForEmail = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,64}"
//   let testEmail = NSPredicate(format:"SELF MATCHES %@", regularExpressionForEmail)
//   return testEmail.evaluate(with: self)
//}
//var isValidPhone: Bool {
//   let regularExpressionForPhone = "^\d{3}-\d{3}-\d{4}$"
//   let testPhone = NSPredicate(format:"SELF MATCHES %@", regularExpressionForPhone)
//   return testPhone.evaluate(with: self)
//}

class RegisterViewController: UIViewController {
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
    
    let registerButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGray
        button.isUserInteractionEnabled = false
        button.setTitle("Register", for: .normal)
        button.addTarget(self, action: #selector(registerPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    let goToLoginButton: UIButton = {
        let button = UIButton()
        button.setTitle("sign in", for: .normal)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(goToLoginPressed(_:)), for: .touchUpInside)
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
    
    let eightCharactersOrMoreLabel: UILabel = {
        let label = UILabel()
        label.text = "Make sure your password has 8 characters or more"
        label.numberOfLines = 0
        return label
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
            .addArrangedSubview(eightCharactersOrMoreLabel)
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
        
        self.view.addSubview(registerButton)
        registerButton.snp.makeConstraints { make in
            make.top.equalTo(vstack.snp.bottom).offset(10)
            make.centerX.equalTo(vstack.snp.centerX)
        }
        
        self.view.addSubview(goToLoginButton)
        goToLoginButton.snp.makeConstraints { make in
            make.top.equalTo(registerButton.snp.bottom).offset(5)
            make.centerX.equalTo(registerButton.snp.centerX)
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
    
    @objc func registerPressed(_ sender: UIButton) {
        Task {
            do {
                let app = App(id: Constants.REALM_APP_ID);
                
                let email = emailTextField.text!
                let password = passwordTextField.text!
                
                /* Register the new user */
                try await app.emailPasswordAuth.registerUser(email: email, password: password)
                
//                app.emailPasswordAuth.resendConfirmationEmail(<#T##email: String##String#>)
                
                /* Log the new user in */
                _ = try await app.login(credentials: Credentials.emailPassword(email: email, password: password));
                
                /* Add the new user's information to the database */
                try await self.pushUserInformation();
                
                
//                DispatchQueue.main.async {
//                    let confirmEmailViewController = ConfirmEmailViewController(email: email)
//                    confirmEmailViewController.view.backgroundColor = .systemBackground
//                    confirmEmailViewController.modalPresentationStyle = .fullScreen
//                    self.present(confirmEmailViewController, animated: false)
//                }
                
                
                /* Segue to the main app */
                let tabBarController = createReefTabBarController()
                tabBarController.modalPresentationStyle = .fullScreen
                self.present(tabBarController, animated: true)
            } catch LoginError.loginFailed(let localizedDescription) {
                print(localizedDescription)
                return;
            } catch {
                print(error.localizedDescription);
                validationLabel.text = error.localizedDescription
                return;
            }
        }
    }
    
    
    @objc func seenPressed(_ sender: UIButton) {
        print("Here")
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
    
    @objc func goToLoginPressed(_ sender: UIButton) {
        let loginViewController = LoginViewController()
        loginViewController.modalPresentationStyle = .fullScreen
        self.present(loginViewController, animated: true)
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
    
    func allowRegister(_ isAllowed: Bool) {
        if isAllowed {
            registerButton.backgroundColor = .systemBlue
            registerButton.isUserInteractionEnabled = true
        } else {
            registerButton.backgroundColor = .systemGray
            registerButton.isUserInteractionEnabled = false
        }
    }    
}

extension RegisterViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField == self.emailTextField {
            if let emailText = textField.text, !emailText.isEmpty, let passwordText = self.passwordTextField.text, passwordText.count >= 8 {
                self.allowRegister(true)
            } else {
                self.allowRegister(false)
            }
        } else {
            if let text = textField.text, text.count >= 8 {
                self.eightCharactersOrMoreLabel.textColor = .systemGreen
                if let emailText = self.emailTextField.text, !emailText.isEmpty {
                    self.allowRegister(true)
                } else {
                    self.allowRegister(false)
                }
            } else {
                self.eightCharactersOrMoreLabel.textColor = .black
                self.allowRegister(false)
            }
        }
    }
}
