//
//  PaneView.swift
//  MissionControlPane
//
//  Created by dehydratedpotato on 6/7/23.
//

import SwiftUI

public struct PaneView: View {
    @State private var showHotCorners: Bool = false
    
    public init() {}
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Image("Mission Control Icon")
                    .resizable()
                    .frame(width: 46, height: 46)
                    .padding(.horizontal, 5)
                
                Text("Mission Control gives you an overview of all your open windows, thumbnails of your full-\nscreen applications, all arranged in a unified view.")
                
                Spacer()
            }
            .padding(.bottom, PaneConstants.panePadding - 10)
            
            group0
            
            group1
            
            Button("Hot Corners...") {
                showHotCorners.toggle()
            }
            .padding(.top, 8)
            
            Spacer()
        }
        .frame(width: PaneConstants.paneWidth - (PaneConstants.panePadding * 2),
               height: PaneDefaults.paneHeight - (PaneConstants.panePadding * 2))
        .padding(PaneConstants.panePadding)
        .navigationTitle(PaneConstants.nameTable[PaneConstants.PaneType.missionControl.rawValue])
        .sheet(isPresented: $showHotCorners) {
            hotcornerSheet
        }
    }
    
    @ViewBuilder var group0: some View {
        PreferenceWellView(subheadline: nil) {
            VStack(alignment: .leading, spacing: 11) {
                Toggle("Automatically rearrange Spaces based on most recent use", isOn: .constant(false))
                Toggle("When switching to an application, switch to a Space with open windows for the application", isOn: .constant(false))
                Toggle("Group windows by application", isOn: .constant(false))
                Toggle("Displays have separate Spaces", isOn: .constant(false))
            }
        }
        .frame(height: 120)
    }
    
    @ViewBuilder var group1: some View {
        PreferenceWellView(subheadline: "Keyboard and Mouse Shortcuts") {
            VStack(spacing: 11) {
                Text("With a single keystroke, view all open windows, windows of the current application, or hide windows to locate an item on the desktop that might be covered up.")
                    .font(.subheadline)
                
                VStack(alignment: .trailing, spacing: 10) {
                    HStack(spacing: 0) {
                        Text("Mission Control:")
                        
                        Picker("", selection: .constant(0)) {
                            
                        }
                        .frame(width: PaneDefaults.shortMaxPickerWidth)
                        .padding(.trailing, 20)
                        
                        Picker("", selection: .constant(0)) {
                            
                        }
                        .frame(width: PaneDefaults.longMaxPickerWidth)
                    }
                    HStack(spacing: 0) {
                        Text("Application windows:")
                        
                        Picker("", selection: .constant(0)) {
                            
                        }
                        .frame(width: PaneDefaults.shortMaxPickerWidth)
                        .padding(.trailing, 20)
                        
                        Picker("", selection: .constant(0)) {
                            
                        }
                        .frame(width: PaneDefaults.longMaxPickerWidth)
                    }
                    HStack(spacing: 0) {
                        Text("Show Desktop:")
                        
                        Picker("", selection: .constant(0)) {
                            
                        }
                        .frame(width: PaneDefaults.shortMaxPickerWidth)
                        .padding(.trailing, 20)
                        
                        Picker("", selection: .constant(0)) {
                            
                        }
                        .frame(width: PaneDefaults.longMaxPickerWidth)
                    }
                }
                .disabled(true)
                
                Text("(for additional choices press Shift, Control, Option, or Command)")
                    .font(.subheadline)
            }
        }
        .frame(height: 195)
    }
    
    @ViewBuilder var hotcornerSheet: some View {
        VStack(alignment: .trailing, spacing: 20) {
            PreferenceWellView(subheadline: "Active Screen Corners") {
                HStack(spacing: 0) {
                    VStack {
                        Picker(selection: .constant(0), content: {
                            
                        }, label: {
                            
                        })
                        .frame(width: PaneDefaults.hotcornerPickerWidth)
                        
                        Spacer()
                        
                        Picker(selection: .constant(0), content: {
                            
                        }, label: {
                            
                        })
                        .frame(width: PaneDefaults.hotcornerPickerWidth)
                    }
                    .padding(.vertical, 3)
                    
                    ZStack {
//                        Image("").resizable()
                        LinearGradient(colors:  [.cyan, .blue], startPoint: .top, endPoint: .bottom)
                        Image("corners", bundle: PaneDefaults.bundle).resizable()
                    }
                    .frame(width: 100, height: 70)
                    .padding(.horizontal, 14)
                    
                    VStack {
                        Picker(selection: .constant(0), content: {
                            
                        }, label: {
                            
                        })
                        .frame(width: PaneDefaults.hotcornerPickerWidth)
                        
                        Spacer()
                        
                        Picker(selection: .constant(0), content: {
                            
                        }, label: {
                            
                        })
                        .frame(width: PaneDefaults.hotcornerPickerWidth)
                    }
                    .padding(.vertical, 3)
                }
                .padding(.vertical, PaneConstants.panePadding)
            }
            
            Button(action: {
                showHotCorners = false
            }, label: {
                Text("OK")
                    .frame(width: 64)
            })
            .buttonStyle(.borderedProminent)
        }
        .frame(width: 592, height: 185)
        .padding([.horizontal, .bottom], PaneConstants.panePadding - 2)
    }
}

struct PaneView_Previews: PreviewProvider {
    static var previews: some View {
        PaneView()
    }
}
