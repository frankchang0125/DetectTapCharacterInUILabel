//
//  ViewController.swift
//  DetectTapCharacterInUILabel
//
//  Created by Frank Chang on 01/02/2017.
//  Copyright © 2017 Frank Chang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var testLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelTapped(_:)))
        self.testLabel.addGestureRecognizer(tapGesture)
        self.testLabel.isUserInteractionEnabled = true
    }
    
    func labelTapped(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            guard let label = sender.view as? UILabel else {
                return
            }
            
            guard let labelText = label.text else {
                return
            }
            
            let tapLocation = sender.location(in: label)
            
            /* Note: We cannot assign UILabel's attributed string directly to NSTextStorage
             * Instead, we have to create another attributed string and apply the attributes
             * of UILabel, otherwise, the tap dection won't be correct
             */
            let attributedString = NSMutableAttributedString(string: labelText)
            let textRange = NSMakeRange(0, attributedString.length)
            attributedString.addAttributes([NSFontAttributeName: label.font], range: textRange)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = label.textAlignment
            attributedString.addAttributes([NSParagraphStyleAttributeName: paragraphStyle], range: textRange)
            
            /* UILabel unlike UITextView, doesn't have bulit-in NSTextStorage, NSLayoutManager and NSTextContainer
             * Thus, we have to create new ones and assign the attributes of tapped label to them
             * to get the index of tapped character in UILabel
             */
            let textStorage = NSTextStorage(attributedString: attributedString)
            let layoutManager = NSLayoutManager()
            let textContainer = NSTextContainer(size: label.bounds.size)
            
            textContainer.lineFragmentPadding = 0
            textContainer.lineBreakMode = label.lineBreakMode
            textContainer.maximumNumberOfLines = label.numberOfLines
            
            textStorage.addLayoutManager(layoutManager)
            layoutManager.addTextContainer(textContainer)
            
            /* Note: If no glyph is under tap location,
             * glyphIndex(for:in:fractionOfDistanceThroughGlyph:) returns the nearest glyph,
             * Thus, we have to call boundingRect(forGlyphRange:in:) to test if the tap location is within the returned glyph rect
             */
            let characterIndex = layoutManager.glyphIndex(for: tapLocation, in: textContainer,
                                                          fractionOfDistanceThroughGlyph: nil)
            let glyphRect = layoutManager.boundingRect(forGlyphRange: NSRange(location: characterIndex, length: 1),
                                                       in: textContainer)
            
            let index = labelText.index(labelText.startIndex, offsetBy: characterIndex)

            print("characterIndex = \(characterIndex)")
            
            if glyphRect.contains(tapLocation) {
                print("Tapped character = \(labelText[index])")
            } else {
                print("No character is tapped")
            }
        }
    }
}

