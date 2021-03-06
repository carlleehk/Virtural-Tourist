//
//  PictureViewController.swift
//  Virtural Tourist
//
//  Created by Carl Lee on 12/16/16.
//  Copyright © 2016 Carl Lee. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class PictureViewController: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegate, MKMapViewDelegate {
    
    
    var isEdit = false
    
    var long: Double?
    var lat: Double?
    var location: Location? = nil

    var insertedIndexPath: [NSIndexPath]!
    var deletedIndexPath: [NSIndexPath]!
    var updatedIndexPath: [NSIndexPath]!
    
    var image: UIImage?
    
    @IBOutlet weak var collectionFlow: UICollectionViewFlowLayout!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionLabel: UIButton!
    @IBOutlet weak var map: MKMapView!
    
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>?{
        didSet{
            fetchedResultsController?.delegate = self
            executeSearch()
            
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        flowLayOut()
        collectionView.dataSource = self
        collectionView.delegate = self
        let centerCoordinate = CLLocationCoordinate2D(latitude: lat!, longitude: long!)
        let viewRegion = MKCoordinateRegionMakeWithDistance(centerCoordinate, 5000, 5000)
        map.setRegion(viewRegion, animated: false)
        let annotation = MKPointAnnotation()
        annotation.coordinate = centerCoordinate
        map.addAnnotation(annotation)
        
        collectionView.allowsMultipleSelection = true
     

        if (location?.url?.count)! == 0{
            collectionLabel.isEnabled = false
            self.fetchNewImage()
            
        }
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let fc = fetchedResultsController{
            print("there is going to be \(fc.sections![section].numberOfObjects) cells")
            return fc.sections![section].numberOfObjects
        } else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let picDatas = fetchedResultsController?.object(at: indexPath) as! PictureData
        print(picDatas)
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "picture", for: indexPath) as! PictureCollectionViewCell
        
        
        if picDatas.photoData != nil{
            collectionLabel.isEnabled = true
            cell.activityIndicator.stopAnimating()
            image = UIImage(data: picDatas.photoData as! Data)
            cell.picture.image = image
        } else{
            cell.activityIndicator.startAnimating()
            let url = picDatas.picURL
            downloadImage(imagePath: url!) { (data, error) in
                if error != nil{
                    print(error!)
                } else{
                    
                    print("Downloading Image")
                    picDatas.photoData = data as NSData?
                    self.image = UIImage(data: data!)
                    cell.picture.image = self.image
                    do{
                        try self.stack.saveContext()
                    } catch{
                        print("Error while saving")
                    }
        
                }
            }
            
        }
        
        
        
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath)
        
        
        collectionLabel.setTitle("Removed Selected Pictures", for: .normal)
        
        isEdit = true
        
        if cell?.isSelected == true{
            
            cell?.alpha = 0.5
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if isEdit{
            let cell = collectionView.cellForItem(at: indexPath)
            cell?.alpha = 1.0
        }
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = false
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func fetchNewImage(){
        
        FlickrClient.sharedInstance().displayImageFromFlickrBySearch(lat: self.lat!, long: self.long!) { (result, error) in
            if error == nil{
                
                for items in result!{
                    let imageURLString = items[Constants.FlickrResponseKeys.MediumURL] as? String
                    print("URLs:\(imageURLString!)")
                    let picURL = PictureData(image: nil, url: imageURLString, context: self.stack.context)
                    picURL.location = self.location
                    do{
                        try self.stack.saveContext()
                    } catch{
                        print("Error while saving")
                    }
                }
            } else{
                print("some error")
                return
            }
        }
        
    }


    @IBAction func RenewCollection(_ sender: Any) {
        if !isEdit{
            
            collectionLabel.isEnabled = false
            for item in (fetchedResultsController?.fetchedObjects)!{
                stack.context.delete(item as! NSManagedObject)
            }
            fetchNewImage()
        } else{
            let indexPaths = collectionView.indexPathsForSelectedItems
            
            for index in indexPaths!{
                
                stack.context.delete(fetchedResultsController?.object(at: index) as! PictureData)
            }
            isEdit = false
             collectionLabel.setTitle("New Collection", for: .normal)
        }
        do{
            try stack.saveContext()
        } catch{
            print("Error while saving")
        }
    }

    
    func downloadImage( imagePath:String, completionHandler: @escaping (_ imageData: Data?, _ errorString: String?) -> Void){
        let session = URLSession.shared
        let imgURL = NSURL(string: imagePath)
        let request: NSURLRequest = NSURLRequest(url: imgURL! as URL)
        
        let task = session.dataTask(with: request as URLRequest) {data, response, downloadError in
            
            if downloadError != nil {
                completionHandler(nil, "Could not download image \(imagePath)")
            } else {
                
                completionHandler(data, nil)
            }
        }
        
        task.resume()
    }
    
    
    func executeSearch(){
     
     if let fc = fetchedResultsController{
     
        do{
            try fc.performFetch()
        } catch let e as NSError{
            print("Error while trying to perform a search: \n\(e)\n\(fetchedResultsController)")
        }
        }
     }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


extension PictureViewController: NSFetchedResultsControllerDelegate{
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        insertedIndexPath = []
        deletedIndexPath = []
        updatedIndexPath = []
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type{
            
        case .insert:
            insertedIndexPath.append(newIndexPath! as NSIndexPath)
        case .delete:
            deletedIndexPath.append(indexPath! as NSIndexPath)
        case .update:
            updatedIndexPath.append(indexPath! as NSIndexPath)
        default: break
        }
    }
    
    func flowLayOut(){
        let space: CGFloat = 1.5
        let dimension = view.frame.size.width >= view.frame.size.height ? (view.frame.size.width - (5 * space)) / 6.0 : (view.frame.size.width - (2*space))/3.0
        collectionFlow.minimumInteritemSpacing = space
        collectionFlow.minimumLineSpacing = space
        collectionFlow.itemSize = CGSize(width: dimension, height: dimension)
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        collectionView.performBatchUpdates({
            for indexPath in self.insertedIndexPath{
                self.collectionView.insertItems(at: [indexPath as IndexPath])
            }
            
            for indexPath in self.deletedIndexPath{
                self.collectionView.deleteItems(at: [indexPath as IndexPath])
            }
            
            for indexPath in self.updatedIndexPath{
                self.collectionView.reloadItems(at: [indexPath as IndexPath])
            }
        }, completion: nil)
    }
}
