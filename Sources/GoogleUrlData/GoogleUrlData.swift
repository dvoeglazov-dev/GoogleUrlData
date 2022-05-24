//
//  GoogleUrlData.swift
//
//  Created by Igor Dvoeglazov on 07.05.2021.
//  Copyright © 2021 Dvoeglazov Pro. All rights reserved.
//

import Foundation

/// Struct mapped the `data` form Google Maps URLs
public struct GoogleUrlData {
    
    /// Pathes for parts of 360-photo URLs
    public enum Path: String {
        case panoramaId = "3.3.1"
        case userContent = "3.3.6"
        case userContentWidth = "3.3.7"
        case userContentHeight = "3.3.8"
        case latitude = "4.3.8.3"
        case longitude = "4.3.8.4"
    }
    
    let rows: [GoogleUrlDataRow]
    let dict: [Int: Any]
    
    public init(url: URL) {
        if let data = url.googleWebData {
            rows = data.compactMap { GoogleUrlDataRow(string: $0) }
            dict = rows.dataDictionary
        } else {
            rows = []
            dict = [:]
        }
    }
    
    // Public
    
    public var panoramaId: String? {
        guard let row = row(forPath: .panoramaId),
              case GoogleUrlDataRow.Key.string = row.key
        else { return nil }
        return row.value
    }
    
    public var userContent: String? {
        guard let row = row(forPath: .userContent),
              case GoogleUrlDataRow.Key.string = row.key,
              row.value.range(of: "googleusercontent") != nil
        else { return nil }
        return row.value
    }
    
    public var userContentSize: (Int, Int)? {
        guard let widthRow = row(forPath: .userContentWidth),
              case GoogleUrlDataRow.Key.integer = widthRow.key,
              let width = Int(widthRow.value),
              let heightRow = row(forPath: .userContentHeight),
              case GoogleUrlDataRow.Key.integer = heightRow.key,
              let height = Int(heightRow.value)
        else { return nil }
        return (width, height)
    }
    
    public var coordinates: (Double, Double)? {
        guard let latRow = row(forPath: .latitude),
              case GoogleUrlDataRow.Key.double = latRow.key,
              let lat = Double(latRow.value),
              let lngRow = row(forPath: .longitude),
              case GoogleUrlDataRow.Key.double = lngRow.key,
              let lng = Double(lngRow.value)
        else { return nil }
        return (lat, lng)
    }
    
    public func row(forPath path: Path) -> GoogleUrlDataRow? {
        urlDataRow(forPath: path.rawValue)
    }
    
    // Utilities
    
    /// Value at path like "3.3.1"
    public func urlDataRow(forPath path: String) -> GoogleUrlDataRow? {
        let indexes = path.components(separatedBy: ".").compactMap { Int($0) }
        guard indexes.count > 0 else { return nil }
        var dic: [Int: Any] = dict
        for index in indexes.dropLast() {
            if let dic1 = dic[index] as? [Int: Any] {
                dic = dic1
            } else {
                return nil
            }
        }
        return dic[indexes.last!] as? GoogleUrlDataRow
    }
}

private extension URL {
    var googleWebData: [String]? {
        guard let data = path.substringFor(pattern: "data=(.+)") else { return nil }
        return data.components(separatedBy: "!").map { $0.removingPercentEncoding ?? $0 }
    }
}
