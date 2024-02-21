// The Swift Programming Language
// https://docs.swift.org/swift-book
// 
// Swift Argument Parser
// https://swiftpackageindex.com/apple/swift-argument-parser/documentation

import ArgumentParser
import Rainbow
import Foundation

@main
struct cleanutil: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "Utility for cleaning unwanted files",
        subcommands: [Bundles.self],
        defaultSubcommand: Bundles.self
    )
    
    struct Bundles: ParsableCommand {
        mutating func run() throws {
            print(try ApplicationManager().getApplications())
        }
    }
}
