//
//  String+Append.swift
//  Rider Demo
//
//  Copyright 2022 Ably Real-time Ltd (ably.com)
//


import Foundation

extension String {
    func appendLines(to url: URL) throws {
        try self.appending("\n\n").append(to: url)
    }
    func append(to url: URL) throws {
        let data = self.data(using: String.Encoding.utf8)
        try data?.append(to: url)
    }
}
