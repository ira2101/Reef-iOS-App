//
//  ReefHorizontalStackView.swift
//  Reef
//
//  Created by Ira Einbinder on 7/19/22.
//

import UIKit

class ReefHorizontalStackView: UIStackView {
    init() {
        super.init(frame: CGRect.zero)
        axis = .horizontal;
        translatesAutoresizingMaskIntoConstraints = false
        isLayoutMarginsRelativeArrangement = true
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addArrangedSubview(_ view: UIView) -> ReefHorizontalStackView {
        super.addArrangedSubview(view)
        return self
    }
    
    func addArrangedSubview(_ view : UIView, withSpacingAfter spacing: CGFloat) -> ReefHorizontalStackView {
        super.addArrangedSubview(view)
        setCustomSpacing(spacing, after: view)
        return self
    }
    
    func addArrangedSubview(_ viewCallback : () -> UIView, onlyIf statement: Bool) -> ReefHorizontalStackView {
        if (statement) {
            let view = viewCallback()
            super.addArrangedSubview(view)
        }
        return self
    }
    
    func addArrangedSubview(_ viewCallback: () -> UIView, withSpacingAfter spacing: CGFloat, onlyIf statement: Bool) -> ReefHorizontalStackView {
        if (statement) {
            let view = viewCallback()
            super.addArrangedSubview(view)
            setCustomSpacing(spacing, after: view)
        }
        return self
    }
        
    func setSpacing(_ spacing: CGFloat) -> ReefHorizontalStackView {
        self.spacing = spacing
        return self
    }
    
    func setDistribution(_ distribution: UIStackView.Distribution) -> ReefHorizontalStackView {
        self.distribution = distribution
        return self
    }
    
    func setAlignment(_ distribution: UIStackView.Alignment) -> ReefHorizontalStackView {
        self.alignment = alignment
        return self
    }
    
    func setPaddingLeading(_ padding: CGFloat) -> ReefHorizontalStackView {
        directionalLayoutMargins.leading = padding
        return self
    }
    
    func setPaddingTrailing(_ padding: CGFloat) -> ReefHorizontalStackView {
        directionalLayoutMargins.trailing = padding
        return self
    }
    
    func setPaddingTop(_ padding: CGFloat) -> ReefHorizontalStackView {
        directionalLayoutMargins.top = padding
        return self
    }
    
    func setPaddingBottom(_ padding: CGFloat) -> ReefHorizontalStackView {
        directionalLayoutMargins.bottom = padding
        return self
    }
    
    func setPadding(_ padding: NSDirectionalEdgeInsets) -> ReefHorizontalStackView {
        directionalLayoutMargins = padding
        return self
    }
    
    func setPadding(_ padding: CGFloat) -> ReefHorizontalStackView {
        directionalLayoutMargins = NSDirectionalEdgeInsets(top: padding, leading: padding, bottom: padding, trailing: padding)
        return self
    }

}
