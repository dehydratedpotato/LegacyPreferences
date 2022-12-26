//
//  RepresentableSearchField.swift
//  Legacy System Preferences
//
//  Created by BitesPotatoBacks on 12/23/22.
//

import SwiftUI

struct SearchField: NSViewRepresentable {
    @Binding var text:   String
             let prompt: String
    
    @State var field: NSSearchField = NSSearchField() // we're doing this so we can set as first responder with cmd+f

    init(_ prompt: String, text: Binding<String>) {
        self.prompt = prompt
        _text       = text
        self.field  = NSSearchField(string: self.text)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(binding: $text)
    }

    func makeNSView(context: Context) -> NSSearchField {
        field.placeholderString = prompt
        field.delegate          = context.coordinator
        field.bezelStyle        = .roundedBezel
        field.focusRingType     = .default
        
        return field
    }

    func updateNSView(_ nsView: NSSearchField, context: Context) {
        nsView.stringValue = text
    }

    class Coordinator: NSObject, NSSearchFieldDelegate {
        let binding: Binding<String>
        
        private var completePosting:  Bool = false
        private var completeHandling: Bool = false

        init(binding: Binding<String>) {
            self.binding = binding
            super.init()
        }

        func controlTextDidChange(_ obj: Notification) {
            guard let field = obj.object as? NSTextField else { return }
            binding.wrappedValue = field.stringValue
        }
    }
}

