//
//  main.swift
//  Legacy System Preferences
//
//  Created by Taevon Turner on 11/11/22.
//

import Foundation

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate

_ = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)
