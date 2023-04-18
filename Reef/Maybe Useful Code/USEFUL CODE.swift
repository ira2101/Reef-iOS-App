//
//  USEFUL CODE.swift
//  Reef
//
//  Created by Ira Einbinder on 1/25/22.
//

import Foundation

//        DispatchQueue.global(qos: .background).async {
//            _ = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { _ in
//                self.reloadData()
//            }
//            _ = Timer.scheduledTimer(withTimeInterval: 10.01, repeats: true) { _ in
//                self.scheduledWrite()
//            }
//
//            RunLoop.current.run()
//        }

/* MAKES A POPUP MESSAGE */
//        let vc = UIViewController()
//        vc.view.backgroundColor = .systemBlue.withAlphaComponent(0.2)
//        vc.modalPresentationStyle = .overFullScreen
//
//        let container = UIView()
//        container.backgroundColor = .white
//        container.layer.cornerRadius = 10
//
//        vc.view.addSubview(container)
//        container.translatesAutoresizingMaskIntoConstraints = false
//        container.centerXAnchor.constraint(equalTo: vc.view.safeAreaLayoutGuide.centerXAnchor).isActive = true
//        container.centerYAnchor.constraint(equalTo: vc.view.safeAreaLayoutGuide.centerYAnchor).isActive = true
//        container.widthAnchor.constraint(equalTo: vc.view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.5).isActive = true
//        container.heightAnchor.constraint(equalTo: vc.view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.5).isActive = true
//
//        self.present(vc, animated: true)


/* MESSING WITH THE VIEW CONTROLLERS IN A NAVIGATION VIEW CONTROLLER */
//                let stackCout = self.navigationController!.viewControllers.count
//                self.navigationController!.viewControllers.insert(conversationParentViewController, at: stackCout - 1)



//        @State var cancellable: AnyCancellable? = nil
//        cancellable = app.login(credentials: .emailPassword(email: email, password: password))
//        .receive(on: DispatchQueue.main)
//        .sink(receiveCompletion: {
//            switch $0 {
//            case .finished:
//                print("Finished!")
//                backgroundColor = .yellow
//                break
//            case .failure(let error):
//                print("Error = " + error.localizedDescription)
//                backgroundColor = .red
//                break
//            }
//        }, receiveValue: { _ in
//            print("ReceiveValue")
//        })

// Important for Segueing with SwiftUI
// https://stackoverflow.com/questions/65868660/swiftui-how-to-present-a-fullscreencover-sideways

//        let blueView = UIView(frame: CGRect(origin: self.view.frame.origin, size: CGSize(width: 200, height: 100)))
//        blueView.backgroundColor = .blue
//
//        let greenView = UIView(frame: CGRect(origin: CGPoint(x: blueView.frame.origin.x + blueView.frame.size.width,
//                                                             y: blueView.frame.origin.y),
//                                             size: CGSize(width: 200, height: 100)))
//        greenView.backgroundColor = .green
//
//        let yellowView = UIView(frame: CGRect(origin: CGPoint(x: greenView.frame.origin.x + greenView.frame.size.width,
//                                                             y: greenView.frame.origin.y),
//                                             size: CGSize(width: 200, height: 100)))
//        yellowView.backgroundColor = .yellow
//
//        let redView = UIView(frame: CGRect(origin: CGPoint(x: yellowView.frame.origin.x + yellowView.frame.size.width,
//                                                             y: yellowView.frame.origin.y),
//                                             size: CGSize(width: 200, height: 100)))
//        redView.backgroundColor = .red
//
//
//        let horizontalCollectionView = ReefPageView(pageDirection: .horizontal)
//        .item(blueView)
//        .item(greenView)
//        .item(yellowView)
//        .item(redView)
//
//        self.view.addSubview(horizontalCollectionView)
//
//        horizontalCollectionView.translatesAutoresizingMaskIntoConstraints = false
//        horizontalCollectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
//        horizontalCollectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
//        horizontalCollectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
//        horizontalCollectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
//
//        horizontalCollectionView.layoutIfNeeded()
//
//        horizontalCollectionView.backgroundColor = .lightGray


//        let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
//        pageViewController.setViewControllers([conversationViewControllers[0]], direction: .forward, animated: true) { result in
//            print(result)
//        }
//
//        pageViewController.dataSource = self
//        pageViewController.delegate = self
//
//        self.addChild(pageViewController)
//        containerView.addSubview(pageViewController.view)
//        pageViewController.view.frame = containerView.frame

//
//extension ConversationParentViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
//    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
//        if self.pageIndex == 0 {
//            return nil
//        }
//
//        return conversationViewControllers[self.pageIndex - 1]
//    }
//
//    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
//        if self.pageIndex == self.conversationViewControllers.count - 1 {
//            return nil;
//        }
//
//        return conversationViewControllers[self.pageIndex + 1]
//    }
//
//    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
//        if completed {
//            self.pageIndex = self.conversationViewControllers.firstIndex(of: self.controllerToTransitionTo! as! ConversationViewController)!
//        } else {
//            print("Did not complete.")
//        }
//    }
//
//    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
//        self.controllerToTransitionTo = pendingViewControllers.first!
//    }
//
//}


/*
 Pokemon's leveling system
 
 function nextLevel(level)
     return round((4 * (level ^ 3)) / 5)
 end
 
 
 */


/*
 var disagreeButton: UIButton = {
     let button = UIButton()
     button.backgroundColor = .red
     button.setTitle("Disagree", for: .normal)
     button.setTitleColor(.white, for: .normal)
     button.titleLabel?.font = .systemFont(ofSize: 12, weight: .semibold)
     button.clipsToBounds = true
     button.layer.cornerRadius = 5
     button.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
     button.addTarget(self, action: #selector(disagreePressed(_:)), for: .touchUpInside)
     return button
 }()
 
 var neutralButton: UIButton = {
     let button = UIButton()
     button.backgroundColor = .orange
     button.setTitle("Neutral", for: .normal)
     button.setTitleColor(.white, for: .normal)
     button.titleLabel?.font = .systemFont(ofSize: 12, weight: .semibold)
     button.addTarget(self, action: #selector(neutralPressed(_:)), for: .touchUpInside)
     return button
 }()
 
 var agreeButton: UIButton = {
     let button = UIButton()
     button.setTitle("Agree", for: .normal)
     button.setTitleColor(.white, for: .normal)
     button.titleLabel?.font = .systemFont(ofSize: 12, weight: .semibold)
     button.clipsToBounds = true
     button.layer.cornerRadius = 5
     button.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
     button.addTarget(self, action: #selector(agreePressed(_:)), for: .touchUpInside)
     return button
 }()
 
 var disagreeGradient: CAGradientLayer = {
     let gradient = CAGradientLayer()
     let myred = UIColor(red: 219 / 255, green: 64 / 255, blue: 64 / 255, alpha: 1)
     gradient.colors = [UIColor.red.cgColor, myred.cgColor, UIColor.red.cgColor]
     gradient.type = .axial
     gradient.startPoint = CGPoint(x: 0, y: 0)
     gradient.endPoint = CGPoint(x: 0, y: 1)
     return gradient
 }()
 
 var neutralGradient: CAGradientLayer = {
     let gradient = CAGradientLayer()
     let myorange = UIColor(red: 240 / 255, green: 189 / 255, blue: 113 / 255, alpha: 1)
     gradient.colors = [UIColor.orange.cgColor, myorange.cgColor, UIColor.orange.cgColor]
     gradient.type = .axial
     gradient.startPoint = CGPoint(x: 0, y: 0)
     gradient.endPoint = CGPoint(x: 0, y: 1)
     return gradient
 }()
 
 var agreeGradient: CAGradientLayer = {
     let gradient = CAGradientLayer()
     let mygreen = UIColor(red: 42 / 255, green: 156 / 255, blue: 65 / 255, alpha: 1)
     gradient.colors = [UIColor.green.cgColor, mygreen.cgColor, UIColor.green.cgColor]
     gradient.type = .axial
     gradient.startPoint = CGPoint(x: 0, y: 0)
     gradient.endPoint = CGPoint(x: 0, y: 1)
     return gradient
 }()
 
 disagreeButton.layer.insertSublayer(disagreeGradient, at: 0)
 neutralButton.layer.insertSublayer(neutralGradient, at: 0)
 agreeButton.layer.insertSublayer(agreeGradient, at: 0)
 
 override func layoutSubviews() {
     disagreeGradient.frame = disagreeButton.bounds
     neutralGradient.frame = neutralButton.bounds
     agreeGradient.frame = agreeButton.bounds
 }
 */

//    @objc func topBubblesPressed(_ sender : UIButton) {
//        conversationPageView.setContentOffset(CGPoint(x: conversationPageView.frame.size.width * 0, y: 0), animated: true)
//    }
//
//    @objc func recentBubblesPressed(_ sender : UIButton) {
//        conversationPageView.setContentOffset(CGPoint(x: conversationPageView.frame.size.width * 1, y: 0), animated: true)
//    }
//
//    @objc func myBubblesPressed(_ sender : UIButton) {
//        conversationPageView.setContentOffset(CGPoint(x: conversationPageView.frame.size.width * 2, y: 0), animated: true)
//    }

//        responseContainer.addSubview(reefResponseLabel)
//        reefResponseLabel.text = self.props.reefBubble.bubble
//        reefResponseLabel.translatesAutoresizingMaskIntoConstraints = false
//        reefResponseLabel.topAnchor.constraint(equalTo: responseContainer.topAnchor).isActive = true
//        reefResponseLabel.leadingAnchor.constraint(equalTo: responseContainer.leadingAnchor).isActive = true
//        reefResponseLabel.widthAnchor.constraint(equalTo: responseContainer.widthAnchor).isActive = true
//        reefResponseLabel.layoutIfNeeded()
//        responseContainer.layoutIfNeeded()
//        responseContainer.contentSize = reefResponseLabel.bounds.size


//func prepareBackgroundView(){
//    let blurEffect = UIBlurEffect.init(style: .Dark)
//    let visualEffect = UIVisualEffectView.init(effect: blurEffect)
//    let bluredView = UIVisualEffectView.init(effect: blurEffect)
//    bluredView.contentView.addSubview(visualEffect)
//
//    visualEffect.frame = UIScreen.mainScreen().bounds
//    bluredView.frame = UIScreen.mainScreen().bounds
//
//    view.insertSubview(bluredView, atIndex: 0)
//}
