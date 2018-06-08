//
//  cleanup_sources.swift
//  PrivatePhotos
//
//  Created by Sebastian Bohmann on 08/06/2018.
//  Copyright © 2018 Sebastian Bohmann. All rights reserved.
//

import Foundation

class CleanupSources {
    let fs = FileManager.default
    
    func run() {
        if correctLocation() {
            walkDirectory(currentDirectory())
        } else {
            print("Launched in wrong location: [" + fs.currentDirectoryPath + "]")
        }
    }
    
    func currentDirectory() -> URL {
        return URL(fileURLWithPath: fs.currentDirectoryPath)
    }
    
    func correctLocation() -> Bool {
        return fs.fileExists(atPath: "cleanup_sources/main.swift")
    }
    
    func walkDirectory(_ path: URL) {
        if let subPaths = try? fs.contentsOfDirectory(at: path, includingPropertiesForKeys: nil, options: []) {
            subPaths.forEach({ subPath in handleSubPath(subPath) })
        }
    }

    func handleSubPath(_ path: URL) {
        if (path.lastPathComponent.starts(with: ".")) {
            return
        }
        if path.pathExtension == "swift" {
            handleSwiftFile(path)
        }
        walkDirectory(path)
    }
    
    func handleSwiftFile(_ path: URL) {
        print(path.path)
        do {
            let text = try String(contentsOf: path, encoding: .utf8)
            
        } catch {
            print(error.localizedDescription)
        }
    }
}

CleanupSources().run()
