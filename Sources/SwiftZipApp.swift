// The Swift Programming Language
// https://docs.swift.org/swift-book
//
// Swift Argument Parser
// https://swiftpackageindex.com/apple/swift-argument-parser/documentation

import ArgumentParser
import Foundation
import Logging
import SwiftMiniZip

@main
struct SwiftZipApp: ParsableCommand {
    @Option var mode: ZipMode = .zip
    @Argument var inputFile: Path
    @Argument var outputFile: Path
    @Flag(help: "Enable verbose logging.")
    var verbose = false

    mutating func run() throws {
        if verbose {
            LoggingSystem.bootstrap { label in
                var handler = StreamLogHandler.standardOutput(label: label)
                handler.logLevel = .debug
                return handler
            }
        }

        if mode == .zip {
            try Zip(config: .init([inputFile.url], outputFile.url)).perform()
        } else {
            try Unzip(config: .init(inputFile.url, outputFile.url)).extract()
        }
    }
}

enum ZipMode: String, ExpressibleByArgument {
    case zip, unzip
}

struct Path: ExpressibleByArgument {
    var url: URL

    init?(argument: String) {
        guard let url = URL(string: argument) else {
            return nil
        }
        self.url = url
    }
}
