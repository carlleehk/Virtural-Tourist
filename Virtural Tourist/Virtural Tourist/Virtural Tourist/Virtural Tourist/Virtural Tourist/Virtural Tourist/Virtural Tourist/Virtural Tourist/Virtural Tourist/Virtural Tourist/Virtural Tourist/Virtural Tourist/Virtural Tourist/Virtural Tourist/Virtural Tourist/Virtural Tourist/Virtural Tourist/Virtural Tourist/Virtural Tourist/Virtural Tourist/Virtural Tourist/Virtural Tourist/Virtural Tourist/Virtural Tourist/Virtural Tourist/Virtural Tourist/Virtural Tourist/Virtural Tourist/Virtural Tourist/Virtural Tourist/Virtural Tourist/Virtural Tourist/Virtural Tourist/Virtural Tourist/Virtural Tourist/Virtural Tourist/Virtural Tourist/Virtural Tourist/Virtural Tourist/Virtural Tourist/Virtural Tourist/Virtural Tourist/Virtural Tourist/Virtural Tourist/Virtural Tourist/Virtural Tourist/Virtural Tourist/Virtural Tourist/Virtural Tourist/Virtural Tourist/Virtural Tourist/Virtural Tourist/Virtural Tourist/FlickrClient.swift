//
//  FlickrClient.swift
//  Virtural Tourist
//
//  Created by Carl Lee on 12/14/16.
//  Copyright © 2016 Carl Lee. All rights reserved.
//

import Foundation

class FlickrClient: NSObject{
    
    var session = URLSession.shared
    
    override init(){
        super.init()
    }
    
    func taskForGetMethod(parameters: [String: String], completionHandlerForGET: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask{
        
        let request = NSMutableURLRequest(url: flickrURLFromParameters(parameters: parameters as [String : AnyObject]) as URL)
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(error: String) {
                print("the error is: \(error)")
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGET(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            guard (error == nil) else{
                sendError(error: (error?.localizedDescription)!)
                return
            }
            
            guard let statcode = (response as? HTTPURLResponse)?.statusCode, statcode >= 200 && statcode <= 299 else{
                sendError(error: "Your request returned a status code other than 2XX.")
                return
            }
            
            guard let data = data else{
                sendError(error: "No data was returned by the request")
                return
            }
            
            self.convertDataWithCompletionHandler(data: data, completionHandlerForConverData: completionHandlerForGET)
            
        }
        
        task.resume()
        return task
    }
    
    func convertDataWithCompletionHandler(data: Data, completionHandlerForConverData: (_ result:AnyObject?, _ error: NSError?) -> Void){
        
        
        let parseData: Any
        do{
            parseData = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            
        } catch {
            print("error")
            return
        }
        
        completionHandlerForConverData(parseData as AnyObject?, nil)
        
    }

    
    private func flickrURLFromParameters(parameters: [String:AnyObject]) -> NSURL {
        
        let components = NSURLComponents()
        components.scheme = Constants.Flickr.APIScheme
        components.host = Constants.Flickr.APIHost
        components.path = Constants.Flickr.APIPath
        components.queryItems = [NSURLQueryItem]() as [URLQueryItem]?
        
        for (key, value) in parameters {
            let queryItem = NSURLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem as URLQueryItem)
        }
        
        return components.url! as NSURL
    }
    
    func bbox(lat: Double, log: Double) ->  String{
        let minlat = max(Constants.Flickr.SearchLatRange.0,lat - Constants.Flickr.SearchBBoxHalfHeight)
        let maxlat = min(Constants.Flickr.SearchLatRange.1, lat + Constants.Flickr.SearchBBoxHalfHeight)
        let minlog = max(Constants.Flickr.SearchLonRange.0, log - Constants.Flickr.SearchBBoxHalfWidth)
        let maxlog = min(Constants.Flickr.SearchLonRange.1, log + Constants.Flickr.SearchBBoxHalfWidth)
        return ("\(minlog),\(minlat),\(maxlog),\(maxlat)")
    }


    class func sharedInstance() -> FlickrClient {
        struct Singleton {
            static var sharedInstance = FlickrClient()
        }
        return Singleton.sharedInstance
    }

}
