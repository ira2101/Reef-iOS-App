//
//  ReefHorizontalCollectionView.swift
//  Reef
//
//  Created by Ira Einbinder on 7/23/22.
//

import UIKit

class ReefPageView: UIScrollView {
    enum PageDirection {
        case horizontal
        case vertical
    }
    
    var pageDirection: PageDirection
    var pages: [UIView]
    
    var contentView: UIView
    
    init(pageDirection: PageDirection) {
        self.pageDirection = pageDirection
        self.pages = []
        
        self.contentView = pageDirection == .vertical ? ReefVerticalStackView() : ReefHorizontalStackView()
        
        super.init(frame: CGRect.zero)
        super.isPagingEnabled = true
        super.isScrollEnabled = true
        super.translatesAutoresizingMaskIntoConstraints = false
    
//        super.bounc
//        super.alwaysBounceVertical = pageDirection == .vertical
//        super.alwaysBounceHorizontal = pageDirection == .horizontal
    }
    
    func item(_ view: UIView) -> ReefPageView {
        self.pages.append(view)
        return self
    }
    
    func items(_ views: [UIView]) ->ReefPageView {
        self.pages += views
        return self
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func layoutSubviews() {
        super.layoutSubviews()
        
        addSubview(contentView)
        contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        switch pageDirection {
        case .horizontal:
            let horizontalStackView = contentView as! ReefHorizontalStackView
            for i in 0 ..< pages.count {
                let _: ReefHorizontalStackView = horizontalStackView.addArrangedSubview(pages[i])

                pages[i].leadingAnchor.constraint(equalTo: i == 0 ? horizontalStackView.leadingAnchor : pages[i - 1].trailingAnchor).isActive = true
                pages[i].topAnchor.constraint(equalTo: horizontalStackView.topAnchor).isActive = true
                pages[i].bottomAnchor.constraint(equalTo: horizontalStackView.bottomAnchor).isActive = true
                pages[i].widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
                pages[i].heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true

                if (i == pages.count - 1) {
                    pages[i].trailingAnchor.constraint(equalTo: horizontalStackView.trailingAnchor).isActive = true
                }
            }
        case .vertical:
            let verticalContentView = contentView as! ReefVerticalStackView
            for i in 0 ..< pages.count {
                let _: ReefVerticalStackView = verticalContentView.addArrangedSubview(pages[i])

                pages[i].leadingAnchor.constraint(equalTo: verticalContentView.leadingAnchor).isActive = true
                pages[i].trailingAnchor.constraint(equalTo: verticalContentView.trailingAnchor).isActive = true
                pages[i].topAnchor.constraint(equalTo: i == 0 ? verticalContentView.topAnchor : pages[i - 1].bottomAnchor).isActive = true
                pages[i].widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
                pages[i].heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true

                if (i == pages.count - 1) {
                    pages[i].bottomAnchor.constraint(equalTo: verticalContentView.bottomAnchor).isActive = true
                }
            }
        }
    }
}
