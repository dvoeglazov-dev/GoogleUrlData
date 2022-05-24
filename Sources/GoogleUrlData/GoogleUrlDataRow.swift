//
//  GoogleUrlDataRow.swift
//
//  Created by Igor Dvoeglazov on 07.05.2021.
//  Copyright © 2021 Dvoeglazov Pro. All rights reserved.
//

import Foundation

/// Struct matches the sigle element of GoogleUrlData started with '!' symbol
/// Each element has 3 parts: ident (index in a matrix), key and value. Value of matrix equal the subelements count.
public struct GoogleUrlDataRow {

    public enum Key: String {
        case matrix = "m"
        case enumerator = "e"
        case string = "s"
        case base64 = "z"
        case double = "d"
        case float = "f"
        case timestamp = "v"
        case integer = "i"
        case unknown = "u"
    }

    let ident: Int
    let key: Key
    let value: String
    
    public var description: String {
        return "\(ident) \(key.rawValue) \(value)"
    }
    
    init?(string: String) {
        let pattern = "(\\d+)([a-zA-Z]{1})(.+)"
        guard let regexp = pattern.makeRegexp() else { return nil }
        
        let matches = regexp.matches(in: string, options: [], range: NSRange(location: 0, length: string.count))
        guard matches.count > 0 else { return nil }
        let match = matches[0]
        
        let range1 = match.range(at: 1)
        let identStr = string.prefix(range1.length)
        guard let ident = Int(identStr) else { return nil }
        
        let range2 = match.range(at: 2)
        let start = string.index(string.startIndex, offsetBy: range2.location)
        let end = string.index(start, offsetBy: range2.length)
        let key = String(string[start..<end])
        
        let range3 = match.range(at: 3)
        let value = String(string.suffix(range3.length))
        
        self.ident = ident
        self.key = Key(rawValue: key) ?? .unknown
        self.value = value
    }
}

extension Array where Element == GoogleUrlDataRow {
    /// Sort array of UrlDataRows as hyerarhic dictionary recursively
    var dataDictionary: [Int: Any] {
        var dic: [Int: Any] = [:]
        var index = 0
        while index < self.count {
            let row = self[index]
            if row.key == .matrix, let length = Int(row.value) {
                if index + length < self.count {
                    let subarr = Array(self[(index + 1)...(index + length)])
                    dic[row.ident] = subarr.dataDictionary
                    index += length
                } else {
                    let subarr = Array(self.suffix(from: index))
                    dic[row.ident] = subarr.dataDictionary
                    index += subarr.count
                }
            } else {
                dic[row.ident] = row
            }
            index += 1
        }
        return dic
    }
}
