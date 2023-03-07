//
//  SearchField.swift
//  Legacy System Preferences
//
//  Created by BitesPotatoBacks on 12/23/22.
//

import SwiftUI

public struct SearchField: NSViewRepresentable {
    @Binding public var text: String
    @State public var field: NSSearchField = NSSearchField() // we're doing this so we can set as first responder with cmd+f
    
    public let prompt: String

    init(_ prompt: String, text: Binding<String>) {
        self.prompt = prompt
        self._text = text
        self.field = NSSearchField(string: self.text)
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(binding: $text)
    }

    public func makeNSView(context: Context) -> NSSearchField {
        self.field.placeholderString = prompt
        self.field.delegate          = context.coordinator
        self.field.bezelStyle        = .roundedBezel
        self.field.focusRingType     = .default
        
        return self.field
    }

    public func updateNSView(_ nsView: NSSearchField, context: Context) {
        nsView.stringValue = self.text
    }

    public class Coordinator: NSObject, NSSearchFieldDelegate {
        public let binding: Binding<String>
        
        private var isAutoCompleting: Bool = false
        private var isBackspace: Bool = false

        init(binding: Binding<String>) {
            self.binding = binding
            super.init()
        }

        public func controlTextDidChange(_ obj: Notification) {
            guard let field = obj.object as? NSTextField else { return }
            
            binding.wrappedValue = field.stringValue
            
            if !isAutoCompleting {
                isAutoCompleting = true
                field.currentEditor()?.complete(nil)
                isAutoCompleting = false
            }
            
            if isBackspace {
                isBackspace = false
            }
        }
        
        public func control(_ control: NSControl, textView: NSTextView, completions words: [String], forPartialWordRange charRange: NSRange, indexOfSelectedItem index: UnsafeMutablePointer<Int>) -> [String] {
            
            let string = textView.string.lowercased()
            let words = PaneManager.shared.allKeywords
            
            var matchedWords: [String] = []

            for (key, value) in words {
                if key.lowercased().contains(string) {
                    matchedWords.append(key)
                } else {
                    for keyword in value where string.count > 1 && keyword.lowercased().contains(string) {
                        matchedWords.append(key)
                    }
                }
            }
            
            matchedWords = matchedWords.sorted(by: >)
            matchedWords = Array(Set(matchedWords.map({ $0 })))
            
            if !matchedWords.isEmpty {
                matchedWords.insert("", at: 0) // this isnt the best but it prevents autocomplete and allows just the completion list
            }

            return matchedWords
        }

        public func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
            if commandSelector == #selector(NSResponder.deleteBackward(_:)) {
                isBackspace = true
            }

            return false
        }
    }
}

