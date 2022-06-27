//
//  LocalFileManager.swift
//

import Foundation

protocol LocalFileManagerDelegate {
    func localFileCopied(atPath path: String)
    func localFileCopyFailed(withError error: String)
}

final class LocalFileManager {
    
    var delegate: LocalFileManagerDelegate?
    
    init(delegate: LocalFileManagerDelegate?) {
        self.delegate = delegate
    }
    
    func copyFile(name: String) {
        
        if let localURL = self.createFolder(name: "Files") {
            
            let fileURL = localURL.appendingPathComponent("\(name)", isDirectory: false)
            
            //  file already exists
            
            if FileManager.default.fileExists(atPath: fileURL.absoluteString.replacingOccurrences(of: "file://", with: "")) {
                self.delegate?.localFileCopied(atPath: fileURL.absoluteString)
                
                print(fileURL.absoluteString)
            }else{
                
                //  copy file to Documents
                
                let components = name.components(separatedBy: ".")
                
                if let location = Bundle.main.url(forResource: components.first ?? "",
                                                  withExtension: components.last ?? "") {
                    
                    do {
                        try FileManager.default.copyItem(at: location, to: fileURL)
                        
                        self.delegate?.localFileCopied(atPath: fileURL.absoluteString)
                        
                        print(fileURL.absoluteString)
                    }catch{
                        self.delegate?.localFileCopyFailed(withError: error.localizedDescription)
                    }
                }
            }
        }
    }
    
    private func createFolder(name: String) -> URL? {
        
        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        let folderURL = documentPath.appendingPathComponent(name, isDirectory: true)
        
        if !FileManager.default.fileExists(atPath: folderURL.absoluteString) {
            
            do {
                try FileManager.default.createDirectory(atPath: folderURL.path,
                                                        withIntermediateDirectories: true,
                                                        attributes: nil)
                
                print("LocalFileManager - Local path: \(folderURL)")
                
                return folderURL
                
            } catch let error as NSError {
                print(error.localizedDescription);
            }
        }else{
            return folderURL
        }
        
        return nil
    }
}
