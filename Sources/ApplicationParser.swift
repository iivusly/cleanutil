//
//  ApplicationParser.swift
//
//
//  Created by iivusly on 2024-02-20.
//

import Foundation

struct Application {
    let applicationURL: URL
    let bundleIdentifier: String
}

class ApplicationParser {
    enum ApplicationParserError: Error {
        case noBundleIdentifier
    }
    
    func getURL(from: URL, component: String, isDirectory: Bool) -> URL {
        if #available(macOS 13.0, *) {
            return from.appending(component: component, directoryHint: isDirectory ? .isDirectory : .notDirectory)
        } else {
            return from.appendingPathComponent(component, isDirectory: isDirectory)
        }
    }
    
    func getContentsFromApplication(from applicationURL: URL) -> URL {
        return getURL(from: applicationURL, component: "Contents", isDirectory: true)
    }
    
    func getApplicationPlist(from contentsURL: URL) -> URL {
        return getURL(from: contentsURL, component: "Info.plist", isDirectory: false)
    }
    
    func readApplicationPlist(from applicationPlistURL: URL) throws -> [String : AnyObject] {
        let plistData = try Data(contentsOf: applicationPlistURL, options: .uncached)
        var format = PropertyListSerialization.PropertyListFormat.xml
        let plistDictonary = try PropertyListSerialization.propertyList(from: plistData, options: .mutableContainers, format: &format)
        return plistDictonary as! [String : AnyObject]
    }
    
    func parseApplication(from applicationURL: URL) throws -> Application {
        let contents = getContentsFromApplication(from: applicationURL)
        let plistFile = getApplicationPlist(from: contents)
        let plistDictonary = try readApplicationPlist(from: plistFile)
        guard let bundleIdentifier = plistDictonary["CFBundleIdentifier"] as? String else {
            throw ApplicationParserError.noBundleIdentifier
        }
        
        return Application(applicationURL: applicationURL, bundleIdentifier: bundleIdentifier)
    }
}

class ApplicationManager {
    func getApplications() throws -> [Application] {
        let applicationDirectories = FileManager.default.urls(for: .allApplicationsDirectory, in: .allDomainsMask)
        let applications = try applicationDirectories.compactMap { applicationDirectory in
            if FileManager.default.fileExists(atPath: applicationDirectory.path) {
                return try FileManager.default.contentsOfDirectory(at: applicationDirectory, includingPropertiesForKeys: [])
            } else {
                return nil
            }
        }.flatMap { $0 }
        
        return applications.compactMap {application in
            if (application.pathExtension == "app") {
                return try? ApplicationParser().parseApplication(from: application)
            } else {
                return nil
            }
        }
    }
}
