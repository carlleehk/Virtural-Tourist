//
//  FlickrConvenience.swift
//  Virtural Tourist
//
//  Created by Carl Lee on 12/14/16.
//  Copyright © 2016 Carl Lee. All rights reserved.
//

import Foundation
import UIKit

extension FlickrClient{
    
    func displayImageFromFlickrBySearch(lat: Double, long: Double, completionHandlerForDisplayImage:@escaping (_ result: [[String: Any]]?, _ error:NSError?) -> Void){
        
        let methodParameters: [String: String?] = [
            Constants.FlickrParameterKeys.Method: Constants.FlickrParameterValues.SearchMethod,
            Constants.FlickrParameterKeys.APIKey: Constants.FlickrParameterValues.APIKey,
            Constants.FlickrParameterKeys.Extras: Constants.FlickrParameterValues.MediumURL,
            Constants.FlickrParameterKeys.SafeSearch: Constants.FlickrParameterValues.UseSafeSearch,
            Constants.FlickrParameterKeys.BoundingBox: bbox(lat: lat, log: long),
            Constants.FlickrParameterKeys.Format: Constants.FlickrParameterValues.ResponseFormat,
            Constants.FlickrParameterKeys.NoJSONCallback: Constants.FlickrParameterValues.DisableJSONCallback
        ]
        
        getRandomPageNumber(parameter: methodParameters) { (suceccess, randomPage, error) in
            if suceccess{
                self.getPhotos(parameter: methodParameters, randomPage: randomPage!, completionHandlerForGetPhoto: { (suceccess, photoURL, error) in
                    if suceccess{
                        completionHandlerForDisplayImage(photoURL, nil)
                    } else{
                        completionHandlerForDisplayImage(nil, error)
                    }
                })
            } else{
                completionHandlerForDisplayImage(nil, error)
            }
        }
        
        
    }
    
    private func getRandomPageNumber(parameter: [String: String?], completionHandlerForRandomPageNumber: @escaping (_ success: Bool, _ pageNumber: Int?, _ error: NSError?) -> Void){
        
        taskForGetMethod(parameters: parameter as! [String : String]) { (result, error) in
            if let error = error{
                completionHandlerForRandomPageNumber(false, nil, error)
            } else{
                guard let photosDict = result?[Constants.FlickrResponseKeys.Photos] as? [String: AnyObject], let photoPage = photosDict[Constants.FlickrResponseKeys.Pages] as? Int else{
                    print("Parse data Error")
                    completionHandlerForRandomPageNumber(false, nil, error)
                    return
                }
                
                if photoPage == 0{
                    print("No photo returned")
                    completionHandlerForRandomPageNumber(false, nil, error)
                    return
                }
                
                let pageLimit = min(photoPage, 40)
                let randomPhotoPage = Int(arc4random_uniform(UInt32(pageLimit)))
                completionHandlerForRandomPageNumber(true, randomPhotoPage, nil)
            }
        }

    }
    
    
    private func getPhotos(parameter: [String: String?], randomPage: Int, completionHandlerForGetPhoto: @escaping (_ success: Bool, _ photoURL: [[String: Any]]?, _ error: NSError?) -> Void){
        
        var methodParameterWithPage = parameter
        methodParameterWithPage[Constants.FlickrParameterKeys.Page] = "\(randomPage)"
        methodParameterWithPage[Constants.FlickrParameterKeys.PerPage] = Constants.FlickrParameterValues.perPage
     
        taskForGetMethod(parameters: methodParameterWithPage as! [String : String]) { (result, error) in
            if let error = error{
                completionHandlerForGetPhoto(false, nil, error)
            } else{
                guard let photosDict = result?[Constants.FlickrResponseKeys.Photos] as? [String: AnyObject], let photoArray = photosDict[Constants.FlickrResponseKeys.Photo] as? [[String: AnyObject]] else{
                    print("Parse data Error")
                    completionHandlerForGetPhoto(false, nil, error)
                    return
                }
                completionHandlerForGetPhoto(true, photoArray, nil)
            }
        }
        
    }
    
}

