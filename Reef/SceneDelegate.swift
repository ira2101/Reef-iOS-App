//
//  SceneDelegate.swift
//  Reef
//
//  Created by Ira Einbinder on 1/1/22.
//

import UIKit
import SwiftUI
import RealmSwift

class SceneDelegate: UIResponder, UIWindowSceneDelegate, UITabBarControllerDelegate {

    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else {
            return
        }
                                
        // reefapp://question?id=12345
        // scheme = reefapp
        // host = question
        // parameters = [id : 12345]
        
        let scheme = url.scheme
        let host = url.host
        var parameters: [String: String] = [:]
        URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems?.forEach({
            parameters[$0.name] = $0.value
        })
        
        guard let rootViewController = window?.rootViewController else {
            if host == "question" {
                self.linkWasOpened = LinkWasOpened(questionID: try! ObjectId(string: parameters["questionid"]!),
                                                   conversationBubbleID: nil,
                                                   conversationText: "Hello ooshie")
            } else if host == "bubble" {
                self.linkWasOpened = LinkWasOpened(questionID: try! ObjectId(string: parameters["questionid"]!),
                                                   conversationBubbleID: try! ObjectId(string: parameters["bubbleid"]!),
                                                   conversationText: "Hello ooshie")
            }
            return
        }
        
        // App navigation = ProfileViewController -> UITabBarController -> [UINavigationController, UINavigationController]
        var furthestViewController: UIViewController = rootViewController
        while let presentedViewController = furthestViewController.presentedViewController {
            furthestViewController = presentedViewController
        }
        let tabBarController = (furthestViewController as? UITabBarController) ?? furthestViewController.tabBarController
        let navigationController = tabBarController?.selectedViewController as? UINavigationController
        
        if host == "question" {
            navigationController?.pushViewController(
                ConversationViewController(questionID: try! ObjectId(string: parameters["questionid"]!),
                                           conversationBubbleID: nil,
                                           conversationText: "Hello ooshie"),
                animated: true)
        } else if host == "bubble" {
            navigationController?.pushViewController(
                ConversationViewController(questionID: try! ObjectId(string: parameters["questionid"]!),
                                           conversationBubbleID: try! ObjectId(string: parameters["bubbleid"]!),
                                           conversationText: "Hello ooshie"),
                animated: true)
        } else if host == "register" {
            print("Registering")
        }
    }
    
    struct LinkWasOpened {
        var questionID: ObjectId
        var conversationBubbleID: ObjectId?
        var conversationText: String
    }
    
    var linkWasOpened: LinkWasOpened?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            let app = App(id: Constants.REALM_APP_ID);
            if let user = app.currentUser {
                print("User is logged in: \(user.id)")
                do {
                    let realmGlobal = try Realm(configuration: user.configuration(partitionValue: Constants.GLOBAL_PARTITION))
                    let realmUser = try Realm(configuration: user.configuration(partitionValue: user.id))
                    if realmGlobal.syncSession != nil && realmUser.syncSession != nil {
                        let tabBarController = createReefTabBarController()
                        window.rootViewController = tabBarController
                        self.window = window
                        window.makeKeyAndVisible()
                        
                        if let url = connectionOptions.urlContexts.first?.url {
                            let scheme = url.scheme
                            let host = url.host
                            var parameters: [String: String] = [:]
                            URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems?.forEach({
                                parameters[$0.name] = $0.value
                            })
                            if host == "question" {
                                (tabBarController.selectedViewController as! UINavigationController).pushViewController(
                                    ConversationViewController(questionID: try! ObjectId(string: parameters["questionid"]!),
                                                               conversationBubbleID: nil,
                                                               conversationText: "Hello ooshie"),
                                    animated: true)
                            } else if host == "bubble" {
                                (tabBarController.selectedViewController as! UINavigationController).pushViewController(
                                    ConversationViewController(questionID: try! ObjectId(string: parameters["questionid"]!),
                                                               conversationBubbleID: try! ObjectId(string: parameters["bubbleid"]!),
                                                               conversationText: "Hello ooshie"),
                                    animated: true)
                            }
                        }
                        
//                        if let linkWasOpened = self.linkWasOpened {
//                            (tabBarController.selectedViewController as! UINavigationController).pushViewController(
//                                ConversationViewController(questionID: linkWasOpened.questionID,
//                                                           conversationBubbleID: linkWasOpened.conversationBubbleID,
//                                                           conversationText: linkWasOpened.conversationText), animated: true)
//                        }
                        return
                    }
                } catch {
                    print(error.localizedDescription)
                }
                
                Realm.asyncOpen(configuration: user.configuration(partitionValue: Constants.GLOBAL_PARTITION), callbackQueue: .main) { result in
                    switch result {
                    case .success(_):
                        Realm.asyncOpen(configuration: user.configuration(partitionValue: user.id), callbackQueue: .main) { result in
                            switch result {
                            case .success(_):
                                let tabBarController = self.createReefTabBarController()
                                window.rootViewController = tabBarController
                                self.window = window
                                window.makeKeyAndVisible()
                                
                                if let url = connectionOptions.urlContexts.first?.url {
                                    let scheme = url.scheme
                                    let host = url.host
                                    var parameters: [String: String] = [:]
                                    URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems?.forEach({
                                        parameters[$0.name] = $0.value
                                    })
                                    if host == "question" {
                                        (tabBarController.selectedViewController as! UINavigationController).pushViewController(
                                            ConversationViewController(questionID: try! ObjectId(string: parameters["questionid"]!),
                                                                       conversationBubbleID: nil,
                                                                       conversationText: "Hello ooshie"),
                                            animated: true)
                                    } else if host == "bubble" {
                                        (tabBarController.selectedViewController as! UINavigationController).pushViewController(
                                            ConversationViewController(questionID: try! ObjectId(string: parameters["questionid"]!),
                                                                       conversationBubbleID: try! ObjectId(string: parameters["bubbleid"]!),
                                                                       conversationText: "Hello ooshie"),
                                            animated: true)
                                    }
                                }
                                
//                                if let linkWasOpened = self.linkWasOpened {
//                                    (tabBarController.selectedViewController as? UINavigationController)?.pushViewController(
//                                        ConversationViewController(questionID: linkWasOpened.questionID,
//                                                                   conversationBubbleID: linkWasOpened.conversationBubbleID,
//                                                                   conversationText: linkWasOpened.conversationText), animated: true)
//                                }
                                break
                            case .failure(let error):
                                print(error.localizedDescription)
                                break
                            }
                        }
                        break
                    case .failure(let error):
                        print(error.localizedDescription)
                        break
                    }
                }
            } else {
                window.rootViewController = LoginViewController()
                self.window = window
                window.makeKeyAndVisible()
            }
        }
        
        
        
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        
//        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    func createReefTabBarController() -> UITabBarController {
        let questionNavBar = UINavigationController(rootViewController: QuestionViewController())
        let profileNavBar = UINavigationController(rootViewController: ProfileViewController())
        questionNavBar.tabBarItem = UITabBarItem(title: "Questions", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        profileNavBar.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person.fill"))

        let tabBarViewController: UITabBarController = UITabBarController()
        tabBarViewController.setViewControllers([questionNavBar, profileNavBar], animated: true)
        tabBarViewController.modalPresentationStyle = .fullScreen
        tabBarViewController.delegate = self
        tabBarViewController.tabBar.isTranslucent = true
        tabBarViewController.tabBar.backgroundColor = UIColor.clear
        tabBarViewController.view.backgroundColor = UIColor.systemBackground
        return tabBarViewController
    }


}

