//
//  AppDelegate.swift
//  Rider Demo
//
//  Copyright 2022 Ably Real-time Ltd (ably.com)
//


import Foundation
import AblyAssetTrackingPublisher

class LocationLogger {
    
    private let timeFormatterPattern = "HH:mm:ss"
    private let fileNameFormatterPattern = "dd_MM_HH.mm.ss"
    private let logFileNameSuffix = "_location.log"
    private let historyFileNameSuffix = "_history.log"
    private let logsDirectory = "riderLogs"
    
    private var currentSessionURL: URL?
    
    func logLocationUpdate(locationUpdate: LocationUpdate, completion: ResultHandler<Void>) {
        writeToFile(locationUpdate: locationUpdate, completion: completion)
    }
    
    private func writeToFile(locationUpdate: LocationUpdate, completion: ResultHandler<Void>) {
        guard let logsDirectoryURL = getLogsDirectory()
        else {
            completion(.failure(ErrorInformation(type: .commonError(errorMessage: "Couldn't read the Logs Directory location"))))
            return
        }
        
        currentSessionURL = getCurrentSessionURL(locationUpdate: locationUpdate, logsDirectoryURL: logsDirectoryURL)
        guard let currentSessionURL = currentSessionURL
        else {
            completion(.failure(ErrorInformation(type: .commonError(errorMessage: "currentSessionURL is not set"))))
            return
        }
        
        let locationString = locationUpdateToString(locationUpdate: locationUpdate)
        
        do {
            try createDirIfNeeded()
            try locationString.appendLines(to: currentSessionURL)
        } catch let error {
            print(error)
            completion(.failure(ErrorInformation(type: .commonError(errorMessage: error.localizedDescription))))
        }
    }
    
    private func getCurrentSessionURL(locationUpdate: LocationUpdate, logsDirectoryURL: URL) -> URL {
        guard currentSessionURL == nil
        else { return currentSessionURL! }
                
        let filename = getFileName(locationUpdate: locationUpdate).appending(logFileNameSuffix)
        return logsDirectoryURL.appendingPathComponent(filename).absoluteURL
    }
    
    private func getFileName(locationUpdate: LocationUpdate) -> String {
        let sessionStartDate = Date(timeIntervalSince1970: locationUpdate.location.timestamp)
        return sessionStartDate.getFormattedDateString(format: fileNameFormatterPattern)
    }
    
    private func getLogsDirectory() -> URL? {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(logsDirectory)
    }
    
    private func createDirIfNeeded() throws {
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent(logsDirectory + "/")
        try FileManager.default.createDirectory(atPath: dir.path, withIntermediateDirectories: true, attributes: nil)
    }
    
    private func locationUpdateToString(locationUpdate: LocationUpdate) -> String {
        let location = locationUpdate.location
        let sessionStartDate = Date(timeIntervalSince1970: locationUpdate.location.timestamp)
        let startTimeString = sessionStartDate.getFormattedDateString(format: timeFormatterPattern)
        
        return ("\(startTimeString) - latitude: \(location.coordinate.latitude), longitude: \(location.coordinate.longitude), altitude: \(location.altitude), horizontalAccuracy: \(location.horizontalAccuracy), course: \(location.course), speed: \(location.speed)")
    }
}
