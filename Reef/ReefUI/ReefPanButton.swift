//
//  ReefPanButton.swift
//  Reef
//
//  Created by Ira Einbinder on 2/15/22.
//

import UIKit
import SnapKit

class ReefPanButton: UIButton {
     
    var popupScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        scrollView.layer.cornerRadius = 5
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isScrollEnabled = false
        scrollView.isHidden = true
        return scrollView
    }()
    
    var popupStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        return stackView
    }()
    
    var scrollMultiplier: CGFloat = 0.05
    
    var gestureLocation: CGPoint!
    
    var selectedButtonChanged: ((Int) -> Void)?
    var selectedButtonIndex: Int = 0
    
    convenience init(arrangedSubviews: [UIView], selectedButtonChanged: @escaping ((Int) -> Void)) {
        self.init(frame: .zero)
        arrangedSubviews.forEach {
            popupStackView.addArrangedSubview($0)
        }
        self.selectedButtonChanged = selectedButtonChanged
        setupView()
    }
    
    func setupView() {
        self.setTitleColor(.black, for: .normal)
        self.titleLabel?.font = .systemFont(ofSize: 12, weight: .semibold)
        
        self.addSubview(popupScrollView)
        popupScrollView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(5.0)
        }
        
        popupScrollView.addSubview(popupStackView)
        popupStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panning(_:)))
        panGesture.delaysTouchesBegan = false
        panGesture.delegate = self
        self.addGestureRecognizer(panGesture)
        
        let pressGesture = UILongPressGestureRecognizer(target: self, action: #selector(pressing(_:)))
        pressGesture.minimumPressDuration = 0
        pressGesture.delegate = self
        self.addGestureRecognizer(pressGesture)
    }
    
    @objc func pressing(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            popupScrollView.isHidden = false
        }
        if sender.state == .ended {
            popupScrollView.isHidden = true
        }
    }
    
    @objc func panning(_ sender: UIPanGestureRecognizer) {
        if sender.state == .began {
            popupScrollView.contentOffset.y = 0
            popupScrollView.isHidden = false
            gestureLocation = sender.location(in: popupScrollView)
        } else if sender.state == .changed {
            let currentGestureLocation = sender.location(in: popupScrollView)
            
            if currentGestureLocation.y < self.gestureLocation.y {
                popupScrollView.contentOffset.y = max(popupScrollView.contentOffset.y + scrollMultiplier * sender.velocity(in: popupScrollView).y, 0)
            } else {
                self.popupScrollView.contentOffset.y = min(popupScrollView.contentOffset.y + scrollMultiplier * sender.velocity(in: popupScrollView).y, popupStackView.bounds.maxY - popupScrollView.bounds.height)
            }
                        
            self.gestureLocation = currentGestureLocation
        }
        
        for i in 0..<popupStackView.arrangedSubviews.count {
            let label = popupStackView.arrangedSubviews[i]
            if sender.location(in: popupStackView).y >= label.frame.minY && sender.location(in: popupStackView).y <= label.frame.maxY {
                label.backgroundColor = .systemGreen
            } else {
                label.backgroundColor = .clear
            }
        }
        
        if sender.state == .ended {
            for i in 0..<popupStackView.arrangedSubviews.count {
                let label = popupStackView.arrangedSubviews[i]
                if sender.location(in: popupStackView).y >= label.frame.minY && sender.location(in: popupStackView).y <= label.frame.maxY {
                    self.setTitle((label as! UILabel).text!, for: .normal)
                    label.backgroundColor = .clear
                    self.selectedButtonIndex = i
                    if (self.selectedButtonChanged != nil) {
                        self.selectedButtonChanged!(self.selectedButtonIndex)
                    }
                }
            }
            self.popupScrollView.isHidden = true
            self.popupScrollView.contentOffset.y = 0
        }
    }
    
    func getOptionAt(yOffset: CGFloat) -> UILabel? {
        for i in 0..<popupStackView.arrangedSubviews.count {
            guard let label = popupStackView.arrangedSubviews[i] as? UILabel else {
                return nil
            }
            
            if yOffset >= label.frame.minY && yOffset <= label.frame.maxY {
                return label
            }
        }
        
        return nil
    }
    

}

extension ReefPanButton: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
