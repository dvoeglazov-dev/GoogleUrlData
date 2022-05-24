//
//  String+Parsing.swift
//
//  Created by Igor Dvoeglazov on 24.05.2022.
//  Copyright © 2021 Dvoeglazov Pro. All rights reserved.
//

import Foundation

public extension String {
    /// Find and return substring conforms to regular expression  pattern
    func substringFor(pattern: String, firstNotLast: Bool = true) -> String? {
        guard let regexp = pattern.makeRegexp(),
              let match = regexp.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)),
              match.numberOfRanges > 1,
              let range = firstNotLast ? Range(match.range(at: 1)) : Range(match.range(at: match.numberOfRanges - 1))
        else { return nil }
        
        let start = index(startIndex, offsetBy: range.startIndex)
        let end = index(startIndex, offsetBy: range.endIndex)
        return String(self[start..<end])
    }
    
    /// Make regular expression from string if possible.
    func makeRegexp() -> NSRegularExpression? {
        do {
            return try NSRegularExpression(pattern: self)
        } catch {
            assertionFailure("Regexp error: \(error)")
            return nil
        }
    }
}
