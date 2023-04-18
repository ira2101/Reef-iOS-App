//
//  MyPageViewController.swift
//  Reef
//
//  Created by Ira Einbinder on 2/8/22.
//

import UIKit
import RealmSwift

class VotePageViewController: UIPageViewController {
    
    private var pages = [VoteViewController]()
    private var pageIndex: Int = 0
    private var controllerToTransitionTo: UIViewController? = nil
    var conversationParentViewController: ConversationViewController!
    
    convenience init(conversationParentViewController: ConversationViewController) {
        self.init(transitionStyle: .scroll, navigationOrientation: .vertical, options: nil)
        self.conversationParentViewController = conversationParentViewController
        
        do {
            let app = App(id: Constants.REALM_APP_ID)
            let user = app.currentUser!
            let realm = try Realm(configuration: user.configuration(partitionValue: Constants.GLOBAL_PARTITION))
            
            let questionID: ObjectId! = conversationParentViewController.props.questionID
            let conversationBubbleID: ObjectId? = conversationParentViewController.props.conversationBubbleID
            
            var reefBubbles = realm.objects(ReefBubble.self)
            if conversationBubbleID == nil { // This is the first level of conversation after the question
                reefBubbles = reefBubbles.where {
                    $0.parentID == nil && $0.questionID == questionID
                }
            } else { // This is the second, ... level of conversation after the question
                reefBubbles = reefBubbles.where {
                    $0.parentID == conversationBubbleID!
                }
            }
            
            
            for bubble in reefBubbles {
                let voteViewController = VoteViewController()
                voteViewController.configure(reefBubble: bubble)
                voteViewController.loadViewIfNeeded()
                self.pages.append(voteViewController)
            }
        } catch {
            print(error.localizedDescription)
        }
        
//        if pages.isEmpty {
//            self.navigationController!.popViewController(animated: false)
//        }
        
        self.setViewControllers([pages[0]], direction: .forward, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.dataSource = self
    }
}

extension VotePageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if self.pageIndex == 0 {
            return nil
        }
        
        return self.pages[self.pageIndex - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if self.pageIndex == self.pages.count - 1 {
            return nil
        }
        
        return self.pages[self.pageIndex + 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            self.pageIndex = self.pages.firstIndex(of: (self.controllerToTransitionTo! as! VoteViewController))!
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        self.controllerToTransitionTo = pendingViewControllers.first!
    }
}
