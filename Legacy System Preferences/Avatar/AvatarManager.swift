//
//  AvatarManager.swift
//  Legacy System Preferences
//
//  Created by BitesPotatoBacks on 12/26/22.
//

import SwiftUI

public class AvatarManager: ObservableObject {
    public static let shared: AvatarManager = AvatarManager()
    
    @Published public var defaults: [DefaultImage] = []
    @Published public var selected: String = ""
    @Published public var avatar:   Image = Image(systemName:"person.circle.fill")
    
    public struct DefaultImage: Identifiable {
        public var image: NSImage
        public var path: String
        public let id: String
    }
    
    public enum Pane: String, CaseIterable {
        case current = "Current"
        case defaults = "Defaults"
    }
    
    public static var defaultLocal = "/Library/User Pictures"
    
    // MARK: - Lifecycle

    init() {
        self.loadAvatar()
        
        let defaults: [DefaultImage] = []

        if let dirs = try? FileManager.default.contentsOfDirectory(atPath: AvatarManager.defaultLocal) {
            DispatchQueue.global(qos:.background).async {
                for dir in dirs {
                    guard let folder = try? FileManager.default.contentsOfDirectory(atPath: "\( AvatarManager.defaultLocal)/\(dir)") else {
                        break
                    }
                    
                    for file in folder where file.contains(".heic") {
                        if let img = NSImage(contentsOf: URL(filePath: "\(AvatarManager.defaultLocal)/\(dir)/\(file)")) {
                            let defaultImage = DefaultImage(image: img, path: "\(AvatarManager.defaultLocal)/\(dir)/\(file)", id: file)
                            
                            DispatchQueue.main.async {
                                self.defaults.append(defaultImage)
                            }
                        }
                    }
                }
            }
        }
        
        self.defaults = defaults.sorted(by: { $0.id > $1.id })
        self.selected = defaults.first?.id ?? ""
    }
    
    // MARK: - Methods
    
    private func loadAvatar() {
        let task = Process()
        task.launchPath = "/bin/bash"
        task.arguments = ["-c", "dscl . read /Users/\(NSUserName()) JPEGPhoto | tail -1 | xxd -r -p "]
        
        let out = Pipe()
        task.standardOutput = out
        task.launch()
        let outData = out.fileHandleForReading.readDataToEndOfFile()

        if let img = NSImage(data: outData) {
            self.avatar = Image(nsImage: img)
            return
        }
        
        self.avatar = Image(systemName:"person.circle.fill")
    }
    
    // currently unavailable
    public final func setAvatar(path p: String) {
        return
    }
}

