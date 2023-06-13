//
//  PaneView.swift
//  AppearancePane
//
//  Created by dehydratedpotato on 6/5/23.
//

import SwiftUI

public struct PaneView: View {
    @State private var sidebarSize: Int//PaneDefaults.SidebarSize
    @State private var showScrollbars: PaneDefaults.ShowScrollbarType
    @State private var tinting: Bool
    @State private var windowCloseQuit: Bool
    @State private var windowCloseConfirm: Bool
    @State private var tabbingMode: PaneDefaults.TabbingModeType
    @State private var jumpPage: Bool
    
//    @State private var jumpScrollbar: Int = 0
    
    @ObservedObject private var defaults: PaneDefaults = PaneDefaults()
    
    public init() {
        let defaults = PaneDefaults()
        self.defaults = defaults
        
        self.tinting = defaults.startWallpaperTinting
        self.sidebarSize = defaults.startSidebarSize
        self.showScrollbars = defaults.startShowScrollbars
        self.windowCloseQuit = defaults.startWindowQuit
        self.windowCloseConfirm = defaults.startcloseAlwaysConfirms
        self.tabbingMode = defaults.startTabbingMode
        self.jumpPage = defaults.startJumpPage
    }
    
    public var body: some View {
        VStack() {
            group1

            Divider().padding([.top, .bottom], 10)
            
            group2
            
            Divider().padding([.top, .bottom], 10)

            group3
            
            Divider().padding([.top, .bottom], 10)
            
            group4
            
            Spacer()
        }
        .frame(width: PaneConstants.paneWidth - (PaneConstants.panePadding * 2),
               height: PaneDefaults.paneHeight - (PaneConstants.panePadding * 2))
        .padding(PaneConstants.panePadding)
        .navigationTitle(PaneConstants.nameTable[PaneConstants.PaneType.appearance.rawValue])
    }
    
    @ViewBuilder private var group1: some View {
        HStack(alignment: .top) {
            VStack(alignment: .trailing) {
                Text("Appearance:")
                    .frame(height: 46, alignment: .bottom)
                Text("Accent Color:")
                    .frame(height: 38, alignment: .bottom)
                Text("Highlight color:")
                    .frame(height: 44, alignment: .bottom)
                Text("Sidebar icon size:")
                    .frame(height: 22, alignment: .bottom)
            }
            .frame(width: PaneDefaults.labelColumnWidth, alignment: .trailing)
            
            VStack(alignment: .leading) {
                ThemePicker(selection: defaults.startTheme)
                    .environmentObject(defaults)
                
                AccentPicker(selection: defaults.startAccentColor)
                    .environmentObject(defaults)
                
                HighlightPicker(selection: defaults.startHighlightColor)
                    .frame(width: PaneDefaults.maximumPickerWidth)
                    .padding(.bottom, 2)
                    .environmentObject(defaults)
                
                Picker(selection: .init(get: {
                    sidebarSize
                }, set: { value in
                    if defaults.setSidebarSize(toSize: value){
                        sidebarSize = value
                    }
                }), content: {
                    Text("Small").tag(1)
                    Text("Medium").tag(2)
                    Text("Large").tag(3)
                }, label: {
                    //
                })
                .frame(width: PaneDefaults.maximumPickerWidth)
                
                Toggle("Allow wallpaper tinting in windows", isOn: .init(get: {
                    tinting
                }, set: { value in
                    if defaults.setWallpaperTint(to: !value) {
                        tinting = value
                    }
                }))
            }
            
            Spacer()
        }
    }
    
    @ViewBuilder private var group2: some View {
        HStack(alignment: .top) {
            VStack(alignment: .trailing) {
                Text("Show scroll bars:")
                Text("Click in the scroll bar to:")
                    .frame(height: 64, alignment: .bottom)
            }
            .frame(width: PaneDefaults.labelColumnWidth, alignment: .trailing)
            
            VStack(alignment: .leading) {

                Picker(selection: .init(get: {
                    showScrollbars
                }, set: { value in
                    if defaults.setShowScrollbars(to: value) {
                        showScrollbars = value
                    }
                }), content: {
                    Text("Automatically based on mouse or trackpad")
                        .tag(PaneDefaults.ShowScrollbarType.auto)
                    Text("When scrolling")
                        .tag(PaneDefaults.ShowScrollbarType.whenScrolling)
                    Text("Always")
                        .tag(PaneDefaults.ShowScrollbarType.always)
                }, label: {
                    //
                })
                .pickerStyle(.radioGroup)
                .padding(.bottom, 10)
                
                Picker(selection: .init(get: {
                    jumpPage
                }, set: { value in
                    if defaults.setBool(for: PaneDefaults.jumpPageKey, to: value) {
                        jumpPage = value
                    }
                }), content: {
                    Text("Jump to the next page").tag(false)
                    Text("Jump to the spot that's clicked").tag(true)
                }, label: {
                    //
                })
                .pickerStyle(.radioGroup)
            }
            
            Spacer()
        }
    }
    
    @ViewBuilder private var group3: some View {
        // TODO: Support setting default web browser
        HStack(alignment: .top) {
            VStack(alignment: .trailing) {
                Text("Default web browser:")
            }
            .frame(width: PaneDefaults.labelColumnWidth, alignment: .trailing)
            
            // TODO: Support setting default browser
            Picker(selection: .constant(0), content: {
//                Text("Safari.app").tag(0)
            }, label: {
                //
            })
            .frame(width: PaneDefaults.maximumPickerWidth)
            .disabled(true)
            
            Spacer()
        }
    }
    
    @ViewBuilder private var group4: some View {
        HStack(alignment: .top) {
            VStack(alignment: .trailing) {
                Text("Prefer tabs:")
                Text("Recent items:")
                    .frame(height: 88, alignment: .bottom)
            }
            .frame(width: PaneDefaults.labelColumnWidth, alignment: .trailing)
            
            VStack(alignment: .leading) {
                HStack {
                    Picker(selection: .init(get: {
                        tabbingMode
                    }, set: { value in
                        if defaults.setTabbingMode(to: value) {
                            tabbingMode = value
                        }
                    }), content: {
                        Text("in full screen").tag(PaneDefaults.TabbingModeType.fullscreen)
                        Text("always").tag(PaneDefaults.TabbingModeType.always)
                        Text("never").tag(PaneDefaults.TabbingModeType.never)
                    }, label: {
                        //
                    })
                    .frame(width: 106)
                    
                    Text("when opening documents")
                }
                
                Toggle("Ask to keep changes when closing documents", isOn: .init(get: {
                    windowCloseConfirm
                }, set: { value in
                    if defaults.setBool(for: PaneDefaults.closeAlwaysConfirms, to: value) {
                        windowCloseConfirm = value
                    }
                }))
                
                Toggle("Close windows when quitting an app", isOn: .init(get: {
                    windowCloseQuit
                }, set: { value in
                    if defaults.setBool(for: PaneDefaults.windowQuitKey, to: value) {
                        windowCloseQuit = value
                    }
                }))
                
                Text("When selected, open documents and windows will not be restored\nwhen you re-open an app.")
                    .font(.caption)
                    .padding(.leading, 20)
                
                // TODO: Add, use Apple Script
                // See https://github.com/joeyhoer/starter/blob/3f6fecfdea257b6a2db5228c5d445b742ed86f42/system/general.sh#L45-L47
                HStack {
                    Picker(selection: .constant(0), content: {
//                        Text("10").tag(0)
                    }, label: {
                        //
                    })
                    .frame(width: 65)
                    
                    Text("Document, Apps, and Servers")
                }
                .disabled(true)
                
                // TODO: Support toggling handoff
                Toggle("Allow Handoff between this Mac and your iCloud devices", isOn: .constant(true))
                    .disabled(true)
            }
            
            Spacer()
        }
    }
}

private struct ThemePicker: View {
    @State var selection: PaneDefaults.ThemeType
    @EnvironmentObject var defaults: PaneDefaults
    
    private let themes: [PaneDefaults.Theme] = [
        .init(id: .light, hint: "Use a light appearance for buttons, menus, and windows."),
        .init(id: .dark, hint:"Use a dark appearance for buttons, menus, and windows."),
        .init(id: .auto, hint: "Automatically adjusts the appearance of for buttons, menus, and windows throughout the day.")
    ]
    
    var body: some View {
        HStack(spacing: 14) {
            ForEach(themes) { theme in
                let id = theme.id
                let selected = selection == id
                
                VStack(spacing: 4) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 7, style: .continuous)
                            .frame(width: 71, height: 48)
                            .foregroundColor(selected ? .accentColor : .clear)
                        
                        Image("Appearance\(id.rawValue)_Normal", bundle: PaneDefaults.bundle)
                            .frame(width: 67, height: 44)
                            .shadow(color: selected ? .clear : .black.opacity(0.4), radius: 1, y: 1)
                        
                        
                        if (id != .auto) {
                            Color.accentColor
                                .frame(width: 67, height: 44)
                                .mask(
                                    Image("selectionColor_mask_Normal", bundle: PaneDefaults.bundle)
                                        .frame(width: 67, height: 44)
                                )
                                
                        } else {
                            Color.accentColor
                                .frame(width: 67, height: 44)
                                .mask(
                                    Image("selectionColor_mask-auto_Normal", bundle: PaneDefaults.bundle)
                                        .frame(width: 67, height: 44)
                                )
                        }
                    }
                    
                    Text(id.rawValue)
                }
                .help(theme.hint)
                .onTapGesture {
                    selection = id
                    
                    defaults.setInterfaceStyle(isDark: id == .dark, isAuto: id == .auto)
                }
            }
        }
    }
}

private struct AccentPicker: View {
    @State var selection: PaneDefaults.AccentType
    @EnvironmentObject var defaults: PaneDefaults
    
    private let accents: [PaneDefaults.Accent] = [
        .init(id: .multicolor, color: .teal),
        .init(id: .blue, color: .blue),
        .init(id: .purple, color: .purple),
        .init(id: .pink, color: .pink),
        .init(id: .red, color: .red),
        .init(id: .orange, color: .orange),
        .init(id: .yellow, color: .yellow),
        .init(id: .green, color: .green),
        .init(id: .gray, color: .gray),
    ]
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 8) {
                ForEach(accents) { accent in
                    let id = accent.id
                    
                    ZStack {
                        if accent.id != .multicolor {
                            Circle()
                                .foregroundColor(accent.color)
                        } else {
                            Image("MuticolorAccentWheel", bundle: PaneDefaults.bundle)
                                .resizable()
                                .mask(Circle())
                        }
                        Circle()
                            .strokeBorder(Color.secondary.opacity(0.45), style: .init(lineWidth: 1))
                        
                        if selection == id {
                            Circle()
                                .foregroundColor(.white)
                                .padding(5)
                        }
                    }
                    .frame(width: 16, height: 16)
                    .help( PaneDefaults.accentTypeNameTable[ id.rawValue ])
                    .onTapGesture {
                        selection = id
                        
                        defaults.setAccentColor(toType: id)
                    }
                }
            }
            
            Text(PaneDefaults.accentTypeNameTable[ selection.rawValue ])
                .foregroundColor(.secondary.opacity(0.75))
        }
    }
}

private struct HighlightPicker: View {
    @State var selection: PaneDefaults.HighlightType
    @EnvironmentObject var defaults: PaneDefaults
    
    private let highlights: [PaneDefaults.HighlightType] = [
        .accentcolor,
        .blue,
        .purple,
        .pink,
        .red,
        .orange,
        .yellow,
        .green,
        .gray
    ]
    
    var body: some View {
        Picker(selection: .init(get: {
            selection
        }, set: { value in
            selection = value
            
            defaults.setHighlightColor(toType: value)
        }), content: {
            ForEach(highlights, id: \.self) { highlight in
                let raw = highlight.rawValue
                
                HStack {
                    Image("HighlightRect_\(raw)", bundle: PaneDefaults.bundle)
                        .opacity(0.7)
                    
                    Text(PaneDefaults.highlightTypeNameTable[raw])
                }
                .tag(raw)
            }
        }, label: {
            //
        })
    }
}

struct PaneView_Previews: PreviewProvider {
    static var previews: some View {
        PaneView()
    }
}
