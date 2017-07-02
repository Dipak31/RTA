//
//  SocialSharing.swift
//  Bhakti Radio
//
//  Created by System Administrator on 12/5/16.
//  Copyright © 2016 onehop. All rights reserved.
//

import UIKit


class File_Manager: NSObject,URLSessionDownloadDelegate{

    
    class var sharedInstance : File_Manager {
        struct Static {
            static let instance : File_Manager = File_Manager();
        }
        return Static.instance
    }
    
    //public var documentsDirectoryURL : URL!
    
    override init() {
        //print("init Manager");
    }
    
    class func isFileExist(videoLink:String) ->String? {
        
        guard let videoURL = URL(string: videoLink) else { return nil}
        
        let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

        let filePath = documentsDirectoryURL.appendingPathComponent(videoURL.lastPathComponent).path;
        //print(filePath)
        // check if the file already exist at the destination folder if you don't want to download it twice
        if FileManager.default.fileExists(atPath: filePath){
            return filePath;
        }
        return nil;
    }
    
    var completationHandler: ((_ destinationPath: String)->())?
    var dataTask:URLSessionDownloadTask?
    var buffer:NSMutableData = NSMutableData()
    var expectedContentLength = 0
    var videoURL:URL?
   // var theCell : VideoCell? = nil;
    var video:Video? = nil;

    func downloadVideo(_ videoLink: String) {
        
        if  File_Manager.isFileExist(videoLink: videoLink) == nil{
            
          //  SVProgressHUD.show(withStatus: "Downloading...");
            
            guard let videoURL = URL(string: videoLink) else { return}
            //print("start downloading")
            // set up your download task
            
            self.videoURL = videoURL;
            
            let configuration = URLSessionConfiguration.default
            let manqueue = OperationQueue.main
            let session = URLSession(configuration: configuration, delegate:self, delegateQueue: manqueue)
            dataTask = session.downloadTask(with: URLRequest(url:videoURL));
            dataTask?.resume()
            
        } else {
            //print("File already exists at destination url")
        }
        
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        //print(Float(totalBytesWritten)/Float(totalBytesExpectedToWrite))
        
      //  SVProgressHUD.showProgress(Float(totalBytesWritten)/Float(totalBytesExpectedToWrite), status: "Downloading...");
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
            do{
        
                let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

                    let destinationURL = documentsDirectoryURL.appendingPathComponent(self.videoURL!.lastPathComponent)
                    try FileManager.default.moveItem(at: location, to: destinationURL)
        
                    DispatchQueue.main.async {
        
                        //print(location);
                        //print(destinationURL)
                        self.video?.isDownloaded = true;
                        self.video?.saveContext();
                        //self.completationHandler?(destinationURL.lastPathComponent)
                    }
        
            }catch let error as NSError { print(error.localizedDescription)}

    }
}
