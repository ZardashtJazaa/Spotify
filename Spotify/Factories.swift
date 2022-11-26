//
//  Factories.swift
//  Spotify
//
//  Created by Zardasht on 11/23/22.
//

import UIKit

extension UIFont {
    
    func withTraits(traits: UIFontDescriptor.SymbolicTraits) -> UIFont {
        let descriptor = fontDescriptor.withSymbolicTraits(traits)
        return UIFont(descriptor: descriptor!, size: 0)
    }
    
    func bold() -> UIFont {
        return withTraits(traits: .traitBold)
    }
}

func makeLabel(withTitle title: String) -> UILabel {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = title
    label.textAlignment = .center
    label.textColor = .label
    label.numberOfLines = 0
    label.adjustsFontSizeToFitWidth = true
    return label
}

func makeStackView(axis: NSLayoutConstraint.Axis) -> UIStackView {
    let stack = UIStackView()
    stack.translatesAutoresizingMaskIntoConstraints = false
    stack.axis = axis
    stack.spacing = 8.0
    return stack
}

extension UIColor {
    
    static let spotifyGreen = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
    static let spotifyBlack = UIColor(red: 12/255, green: 12/255, blue: 12/255, alpha: 1.0)
    
}
