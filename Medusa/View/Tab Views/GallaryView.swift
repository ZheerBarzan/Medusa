//
//  GallaryView.swift
//  Medusa
//
//  Created by zheer barzan on 7/2/25.
//

import SwiftUI

struct GallaryView: View {
    @Environment(AppDataModel.self) var appModel
    @Binding var showCaptures: Bool
    @State  var isFolderButton: Bool
    
    
    var body: some View {
        if let captureFolderURL{
            ScrollView{
                
                if isFolderButton{
                    ZStack{
                        HStack{
                            Button(LocalizedString.cancel){
                                withAnimation{
                                    showCaptures = false
                                }
                            }
                            .foregroundColor(.white)
                            Spacer()
                            
                        }
                        Text(LocalizedString.captures)
                            .foregroundColor(.white).bold()
                    }
                    Divider().padding(.vertical, 8)
                }else{
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: UIDevice.current.userInterfaceIdiom == .pad ? 4 : 2), spacing: 10){
                        let frameWidth = UIDevice.current.userInterfaceIdiom == .pad ? 400 : 200
                        
                        ForEach(captureFolderURL, id:\.self){ url in
                            ThumbnailView(captureFolderURL: url, frameSize:CGSize(width: frameWidth, height: frameWidth + 70))
                        }
                        
                    }
                }
            }.padding()
        }
    }
    
    private var captureFolderURL: [URL]? {
        guard let topFolder = appModel.captureFolderManager?.appDocumentFolder else { return nil}
        let folderURLs = try? FileManager.default.contentsOfDirectory(
            at: topFolder,
            includingPropertiesForKeys: nil,
            options: []
        )
            .filter { $0.hasDirectoryPath }
            .sorted(by:{ $0.path < $1.path })
        guard let folderURLs = folderURLs else { return nil }
        
        return folderURLs
        
    }
    
    struct LocalizedString {
        static let cancel = NSLocalizedString(
            "Cancel (Object Capture)",
            bundle: Bundle.main,
            value: "Cancel",
            comment: "Title for the Cancel button on the object capture on Folder view.")
        
        static let captures = NSLocalizedString(
            "Captures (Object Capture)",
            bundle: Bundle.main,
            value: "Captures",
            comment: "Title for the Captures button on the object capture on Folder view.")
        
    }
        
}

