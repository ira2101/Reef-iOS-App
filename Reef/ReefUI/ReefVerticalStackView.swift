//
//  ReefVerticalStackView.swift
//  Reef
//
//  Created by Ira Einbinder on 7/19/22.
//

import UIKit

class ReefVerticalStackView: UIStackView {
    init() {
        super.init(frame: CGRect.zero)
        axis = .vertical;
        translatesAutoresizingMaskIntoConstraints = false
        isLayoutMarginsRelativeArrangement = true
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addArrangedSubview(_ view: UIView) -> ReefVerticalStackView {
        super.addArrangedSubview(view)
        return self
    }
    
    func addArrangedSubview(_ view : UIView, withSpacingAfter spacing: CGFloat) -> ReefVerticalStackView {
        super.addArrangedSubview(view)
        setCustomSpacing(spacing, after: view)
        return self
    }
    
    func addArrangedSubview(_ viewCallback : () -> UIView, onlyIf statement: Bool) -> ReefVerticalStackView {
        if (statement) {
            let view = viewCallback()
            super.addArrangedSubview(view)
        }
        return self
    }
    
    func addArrangedSubview(if statement: Bool, then viewCallback : () -> UIView) -> ReefVerticalStackView {
        if (statement) {
            let view = viewCallback()
            super.addArrangedSubview(view)
        }
        return self
    }
    
    func addArrangedSubview(_ viewCallback: () -> UIView, withSpacingAfter spacing: CGFloat, onlyIf statement: Bool) -> ReefVerticalStackView {
        if (statement) {
            let view = viewCallback()
            super.addArrangedSubview(view)
            setCustomSpacing(spacing, after: view)
        }
        return self
    }
    
    func setSpacing(_ spacing: CGFloat) -> ReefVerticalStackView {
        self.spacing = spacing
        return self
    }
    
    func setDistribution(_ distribution: UIStackView.Distribution) -> ReefVerticalStackView {
        self.distribution = distribution
        return self
    }
    
    func setAlignment(_ distribution: UIStackView.Alignment) -> ReefVerticalStackView {
        self.alignment = alignment
        return self
    }
    
    func setPaddingLeading(_ padding: CGFloat) -> ReefVerticalStackView {
        directionalLayoutMargins.leading = padding
        return self
    }
    
    func setPaddingTrailing(_ padding: CGFloat) -> ReefVerticalStackView {
        directionalLayoutMargins.trailing = padding
        return self
    }
    
    func setPaddingTop(_ padding: CGFloat) -> ReefVerticalStackView {
        directionalLayoutMargins.top = padding
        return self
    }
    
    func setPaddingBottom(_ padding: CGFloat) -> ReefVerticalStackView {
        directionalLayoutMargins.bottom = padding
        return self
    }
    
    func setPadding(_ padding: NSDirectionalEdgeInsets) -> ReefVerticalStackView {
        directionalLayoutMargins = padding
        return self
    }
    
    func setPadding(_ padding: CGFloat) -> ReefVerticalStackView {
        directionalLayoutMargins = NSDirectionalEdgeInsets(top: padding, leading: padding, bottom: padding, trailing: padding)
        return self
    }
}
