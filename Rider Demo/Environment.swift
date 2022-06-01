//
//  Environment.swift
//  Rider Demo
//
//  Copyright 2022 Ably Real-time Ltd (ably.com)
//

import Foundation

public enum EnvironmentHelper {
    private static let infoDictionary: [String: Any] = {
        guard let filePath = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
              let dictionary = NSDictionary(contentsOfFile: filePath) as? [String: Any]
        else {
            fatalError("Plist file not found")
        }
        return dictionary
    }()

    static let ablyKey: String = {
        guard let key = EnvironmentHelper.infoDictionary["ABLY_API_KEY"] as? String, !key.isEmpty else {
            fatalError("ABLY_API_KEY not set in plist for this environment")
        }
        return key
    }()

    static let mapboxAccessToken: String = {
        guard let token = EnvironmentHelper.infoDictionary["MAPBOX_ACCESS_TOKEN"] as? String, !token.isEmpty else {
            fatalError("MAPBOX_ACCESS_TOKEN not set in plist for this environment")
        }
        return token
    }()
}
