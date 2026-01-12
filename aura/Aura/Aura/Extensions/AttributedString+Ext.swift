//
//  AttributedString+Ext.swift
//  Aura
//
//  Created by Ezgi Özkan on 12.01.2026.
//

import SwiftUI

extension AttributedString {
    static func parseDescription(_ text: String) -> AttributedString {
        var attributedString = AttributedString(text)

        let pattern = "\\*\\*([^*]+)\\*\\*"
        if let regex = try? NSRegularExpression(pattern: pattern, options: []) {
            let nsString = text as NSString
            let matches = regex.matches(in: text, options: [], range: NSRange(location: 0, length: nsString.length))

            for match in matches.reversed() {
                if let range = Range(match.range(at: 1), in: text) {
                    let word = String(text[range])

                    if let fullRange = Range(match.range, in: text) {
                        if let attrRange = Range(fullRange, in: attributedString) {
                            var styledText = AttributedString(word)
                            styledText.foregroundColor = Color.purple
                            styledText.font = .system(size: 15, weight: .bold)
                            attributedString.replaceSubrange(attrRange, with: styledText)
                        }
                    }
                }
            }
        }
        return attributedString
    }
}
