//
//  DownloadManager.swift
//

import Foundation

protocol DownloadManagerDelegate {
	
	func downloadFailed(error: Error?)
	func downloadFinished(path: String)
	func downloadProgress(url: URL, progress: Float)
}

final class DownloadManager: NSObject, URLSessionDownloadDelegate {
	
	static var shared = DownloadManager()
	
	var url: URL!
	var fileName: String = ""
	var delegate: DownloadManagerDelegate?
	
	//-----------------------------------------------------------------------
	//	MARK: - DownloadManager
	//-----------------------------------------------------------------------
	
	func download(delegate: DownloadManagerDelegate?, from url: URL, fileName: String) {
		
		self.url = url
		self.fileName = fileName
		self.delegate = delegate
		
		let sessionConfig = URLSessionConfiguration.default
		let session = URLSession(configuration: sessionConfig, delegate: self, delegateQueue: OperationQueue.main)
		let request = URLRequest(url: url, cachePolicy: .reloadIgnoringCacheData)
		
		let task = session.downloadTask(with: request)
		task.resume()
	}
	
	private func createFolder(name: String) -> URL? {
		
		let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
		
		let folderURL = documentPath.appendingPathComponent(name, isDirectory: true)
		
		if !FileManager.default.fileExists(atPath: folderURL.absoluteString) {
			
			do {
				try FileManager.default.createDirectory(atPath: folderURL.path,
														withIntermediateDirectories: true,
														attributes: nil)
				
				print("Download - Local path: \(folderURL)")
				
				return folderURL
				
			} catch let error as NSError {
				print(error.localizedDescription);
			}
		}else{
			return folderURL
		}
		
		return nil
	}
	
	//-----------------------------------------------------------------------
	//	MARK: - URLSessionDownload Delegate
	//-----------------------------------------------------------------------
	
	func urlSession(_ session: URLSession,
					downloadTask: URLSessionDownloadTask,
					didWriteData bytesWritten: Int64,
					totalBytesWritten: Int64,
					totalBytesExpectedToWrite: Int64) {
		
		let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
		
		DispatchQueue.main.async {
			self.delegate?.downloadProgress(url: self.url, progress: progress)
		}
	}
	
	func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
		
		if downloadTask.error == nil {
			
			if let localURL = self.createFolder(name: "Files") {
				
				let fileExtension = url.lastPathComponent.components(separatedBy: ".").last ?? ""
				let fileURL = localURL.appendingPathComponent("\(fileName).\(fileExtension)", isDirectory: false)
				do {
					try FileManager.default.moveItem(at: location, to: fileURL)
					
					if let path = fileURL.path.components(separatedBy: "Documents/").last {
						self.delegate?.downloadFinished(path: path)
					}
					return
				} catch (let writeError) {
					self.delegate?.downloadFailed(error: writeError)
				}
			}
		}else{
			self.delegate?.downloadFailed(error: downloadTask.error)
		}
	}
}
