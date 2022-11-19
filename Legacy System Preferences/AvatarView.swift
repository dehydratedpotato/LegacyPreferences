//
//  AvatarView.swift
//  Legacy System Preferences
//
//  Created by Taevon Turner on 11/17/22.
//

import SwiftUI

private struct VisualEffectView: NSViewRepresentable
{
    let material: NSVisualEffectView.Material
    let blendingMode: NSVisualEffectView.BlendingMode
    
    func makeNSView(context: Context) -> NSVisualEffectView
    {
        let visualEffectView = NSVisualEffectView()
        visualEffectView.material = material
        visualEffectView.blendingMode = blendingMode
        visualEffectView.state = NSVisualEffectView.State.active
        return visualEffectView
    }

    func updateNSView(_ visualEffectView: NSVisualEffectView, context: Context)
    {
        visualEffectView.material = material
        visualEffectView.blendingMode = blendingMode
    }
}

struct DefaultImage: Identifiable {
    var image: NSImage
    var name: String
    var path: String
    var id = UUID()
}
class AvatarHandler: ObservableObject {
    @Published var defaults: [DefaultImage] = [DefaultImage]()
    @Published var selected: String = ""
    let defaultLocal  = "/Library/User Pictures"
    
    init() {
        update()
        if defaults.count > 0 {
            selected = defaults[0].name
        }
    }
    
    func update() {
        defaults = [DefaultImage]()

        let fileManager = FileManager()
        do {
            let dirs = try fileManager.contentsOfDirectory(atPath: defaultLocal)
            for dir in dirs {
                let folder = try fileManager.contentsOfDirectory(atPath: "\(defaultLocal)/\(dir)")
                for file in folder {
                    if file.contains(".heic") {
                        if let img = NSImage(contentsOf: URL(filePath: "\(defaultLocal)/\(dir)/\(file)")) {
                            defaults.append(
                                DefaultImage(image:img, name: file, path: "\(defaultLocal)/\(dir)/\(file)")
                            )
                        }
                    } else {
                        print("No default with .heic")
                    }
                }
            }
        } catch {
            print(error)
        }
    }
}

struct AvatarView: View {
    @Binding var visible: Bool
    @Binding var avatar: Image
    @Binding var pane: Int
    
    @ObservedObject var defaults = AvatarHandler()
    let opts = ["Current", "Defaults"]
    
    var body: some View {
        VStack(spacing:0) {
            HStack(spacing:0) {
                List(0..<2, selection: $pane) { i in
                    Text(opts[i])
                        .offset(x: 10, y:0)
                }
                .listStyle(.sidebar)
                .frame(width: 175)
                
                if pane == 0 {
                    ZStack {
                        avatar
                            .resizable()
                            .overlay(
                                ZStack {
                                    Color.black.opacity(0.5)
                                    Circle()
                                        .blendMode(.destinationOut)
                                }.compositingGroup()
                            )
                    }
                } else if pane == 1 {
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.fixed(64)),
                                            GridItem(.fixed(64)),
                                            GridItem(.fixed(64)),
                                            GridItem(.fixed(64)),]) {
                            ForEach(defaults.defaults) { img in
                                Image(nsImage: img.image)
                                    .resizable()
                                    .frame(width:64, height:64)
                                    .border(Color.accentColor, width: defaults.selected == img.name ? 2 : 0)
                                    .onTapGesture {
                                        defaults.selected = img.name
                                    }
                            }
                            
                        }
                        .padding(10)
                    }
                    
                }
            }
            HStack(spacing:10) {
                Spacer()
                
                Button("Cancel") {
                    visible.toggle()
                }
                
//                .buttonStyle(.plain)
                Button("Save") {
                    
                    if pane == 0{
                        
                    } else if pane == 1 {
                        
                    }
                    
                    visible.toggle()
                }
                .buttonStyle(.borderedProminent)
                .disabled(true)
            }
            .padding([.top, .bottom], 10)
            .padding(.trailing, 20)
            .background(VisualEffectView(material: .windowBackground, blendingMode: .withinWindow))
        }
        .frame(width: 475, height: 340)
    }
}
