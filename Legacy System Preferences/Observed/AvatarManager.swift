//
//  AvatarManager.swift
//  Legacy System Preferences
//
//  Created by BitesPotatoBacks on 12/26/22.
//

import SwiftUI

struct DefaultImage: Identifiable {
    var image: NSImage
    let id:    String
    var path:  String
}

class AvatarManager: ObservableObject {
    @Published var defaults: [DefaultImage] = [DefaultImage]()
    @Published var selected: String = ""
    @Published var avatar:   Image  = Image(systemName:"person.circle.fill")
    
    let defaultLocal = "/Library/User Pictures"

    init() {
        loadAvatar()
        defaults = [DefaultImage]()

        let fileManager = FileManager()
        do {
            let dirs = try fileManager.contentsOfDirectory(atPath: defaultLocal)
            for dir in dirs {
                let folder = try fileManager.contentsOfDirectory(atPath: "\(defaultLocal)/\(dir)")
                for file in folder {
                    if file.contains(".heic") {
                        DispatchQueue.global(qos:.background).async {
                            if let img = NSImage(contentsOf: URL(filePath: "\(self.defaultLocal)/\(dir)/\(file)")) {
                                DispatchQueue.main.async {
                                    self.defaults.append(
                                        DefaultImage(image:img, id: file, path: "\(self.defaultLocal)/\(dir)/\(file)")
                                    )
                                }
                            }
                        }
                    } else {
                        print("No default with .heic")
                    }
                }
            }
        } catch {
            print(error)
        }
        
        defaults = defaults.sorted(by: {$0.id > $1.id})
        selected = defaults.first?.id ?? ""
    }
    
    func loadAvatar() {
        let task = Process()
        task.launchPath = "/bin/bash"
        task.arguments = ["-c", "dscl . read /Users/\(NSUserName()) JPEGPhoto | tail -1 | xxd -r -p "]
        
        let out = Pipe()
        task.standardOutput = out
        task.launch()
        let outData = out.fileHandleForReading.readDataToEndOfFile()

        if let img = NSImage(data: outData) {
            avatar = Image(nsImage: img)
        } else {
            avatar = Image(systemName:"person.circle.fill")
        }
    }
    
    func setAvatar(path p: String) {
//        if let path = Bundle.main.path(forResource: "setavatar", ofType: "sh") {
//            let path = path.replacing(" ", with: "\\ ")
//            let p    = p.replacing(" ", with: "\\ ")
//            let script = """
//                do shell script "\(path) \(NSUserName()) \(p)" with administrator privileges
//                """
//
//            let task = Process()
//            task.launchPath = "/bin/bash"
//            task.arguments = ["-c", "chmod 755 \(path) && osascript -e '\(script)'"]
//            print(task.arguments)
//            task.launch()
//        }
    }
}

