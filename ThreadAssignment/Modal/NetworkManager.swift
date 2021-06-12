//
//  NetworkManager.swift
//  ThreadAssignment
//
//  Created by Mirajkar on 11/06/21.
//  Copyright © 2021 Mirajkar. All rights reserved.
//

import Foundation

class NetworkManager {
    //MARK: Global varibles
    static let shared = NetworkManager()
    
    private init() { }
    
    var defaultSession = URLSession(configuration: .default)
    var dataTask : URLSessionDataTask?
    var errorMessage = ""
    var albumArray : [[String : Any]] = []
    var albums : [Album] = []
    
    
    //MARK: API Call
    func photosAPICall(onCompletion: @escaping (String) -> Void) {
        dataTask?.cancel()
        
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/photos") else { return }
        
        dataTask = defaultSession.dataTask(with: url, completionHandler: { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let data  = data,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200 {
                self.getDataFromAPI(data: data)
                
                DispatchQueue.main.async {
                    onCompletion(self.errorMessage)
                }
            }
        })
        
        dataTask?.resume()
    }
    
    
    
    
    
    func getDataFromAPI(data: Data) {
        var response : [Any]?
        
        do {
            response =  try JSONSerialization.jsonObject(with: data, options: []) as? Array
        } catch let error as NSError {
            self.errorMessage = error.localizedDescription
        }
        
        guard let responseArray = response else { return }
        
        for responseDict in responseArray {
            if let trackDict = responseDict as? [String : Any],
                let title = trackDict["title"] as? String,
                let trackThumbnailUrl = trackDict["thumbnailUrl"] as? String {
                print("\(title)\n \(trackThumbnailUrl)")
                albums.append(Album(title: title, trackThumbnailUrl: URL(string: trackThumbnailUrl)!))
            }
            
        }
    }
    
    
    //MARK: Download Image
    func fetchCellImage(albumObj: Album, onCompletion: @escaping (Data, String) -> Void) {
        DispatchQueue.global().async {
            
            print("imageURL: \(albumObj.trackThumbnailUrl)")
            let defaultSession = URLSession(configuration: .default)
            var dataTask : URLSessionDataTask?
            
            dataTask?.cancel()
            dataTask = defaultSession.dataTask(with:albumObj.trackThumbnailUrl , completionHandler: { (imageData, response, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else if let data = imageData {
                    print("Did download image data")
                    DispatchQueue.main.async {
                        onCompletion(data, albumObj.title)
                    }
                }
            })
            
            dataTask?.resume()
        }
    }
}
