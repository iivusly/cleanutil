// The Swift Programming Language
// https://docs.swift.org/swift-book
// 
// Swift Argument Parser
// https://swiftpackageindex.com/apple/swift-argument-parser/documentation

import ArgumentParser
import Rainbow

@main
struct cleanutil: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "Utility for cleaning unwanted files",
        subcommands: [Bundles.self]
    )
    
    struct Bundles: ParsableCommand {
        mutating func run() {
            print("Test".red)
        }
    }
}
