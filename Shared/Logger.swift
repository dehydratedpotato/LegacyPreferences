//
//  Logger.swift
//  AppearancePane
//
//  Created by dehydratedpotato on 6/12/23.
//

import Foundation

struct Logger {
    static func log(_ message: String, isError: Bool = false, class className: AnyClass? = nil, function: String = #function, line: Int = #line) {
#if DEBUG
        let stringStub = isError ? " (ERROR) " : " "
        
        if let className = className {
            print("***\(stringStub)[\(line):\(NSStringFromClass(className)).\(function)] \(message) ***")
            return
        }
        
        print("***\(stringStub)[\(line):\(function)] \(message) ***")
        return
#endif
    }
}
