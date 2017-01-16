//
//  ViewController.swift
//  Virtural Tourist
//
//  Created by Carl Lee on 12/7/16.
//  Copyright © 2016 Carl Lee. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MapViewController: BaseViewController, MKMapViewDelegate {

    @IBOutlet weak var deleteLabel: UILabel!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    var isEdit = false
    let precision = 0.00005
    let fr1 = NSFetchRequest<NSFetchRequestResult>(entityName: "MapRegion")
    let fr2 = NSFetchRequest<NSFetchRequestResult>(entityName: "Location")

    
    override func viewWillAppear(_ animated: Bool) {
        viewDidLoad()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        map.delegate = self
        deleteLabel.isHidden = true
        
        var annotations = [MKPointAnnotation]()
        let uilgr = UILongPressGestureRecognizer(target: self, action: #selector(action(gestureRecognizer:)))
        uilgr.minimumPressDuration = 2.0
        map.addGestureRecognizer(uilgr)
        
        do{
            let fer = try stack.context.fetch(fr1) as NSArray!
            if fer?.count == 0{
                return
            }
            let mo = fer?[0] as! NSManagedObject
            let centerCoo = CLLocationCoordinate2DMake(mo.value(forKey: "centerLat") as! CLLocationDegrees, mo.value(forKey: "centerLong") as! CLLocationDegrees)
            let spanCoo = MKCoordinateSpanMake(mo.value(forKey: "spanLat") as! CLLocationDegrees, mo.value(forKey: "spanLong") as! CLLocationDegrees)
            print("\(centerCoo), \(spanCoo)")

            let viewRegion = MKCoordinateRegionMake(centerCoo, spanCoo)
            self.map.setRegion(viewRegion, animated: false)
            } catch{
            print("Failed to fetch \(error)")
        }

        
        
        
        do{
            let fer = try stack.context.fetch(fr2) as NSArray!
            print("the data consist: \(fer)")
            for item in fer!{
                let mo = item as! NSManagedObject
                let lat = mo.value(forKey: "lat") as! Double
                let long = mo.value(forKey: "long") as! Double
                print("\(lat), \(long)")
                let coor = CLLocationCoordinate2D(latitude: lat, longitude: long)
                let annotation = MKPointAnnotation()
                annotation.coordinate = coor
                annotations.append(annotation)
            }
            
        } catch{
            print("Failed to fetch \(error)")
        }
        

        self.map.addAnnotations(annotations)
        
    }

    
    func action(gestureRecognizer: UIGestureRecognizer){
        if isEdit{
            return
        }
        let touchPoint = gestureRecognizer.location(in: map)
        let newCoordinates = map.convert(touchPoint, toCoordinateFrom: map)
       
        let annotation = MKPointAnnotation()
        annotation.coordinate = newCoordinates
        switch gestureRecognizer.state{
        case UIGestureRecognizerState.began:
            map.addAnnotation(annotation)
            let nc = Location(lat: newCoordinates.latitude, long: newCoordinates.longitude, context: stack.context)
            print(nc)
        default: return
        }
       
        do{
            try stack.saveContext()
        } catch{
            print("Error while saving")
        }
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let region = mapView.region
        let centerCooridnate = region.center
        let span = region.span
        
        do{
            let fer = try stack.context.fetch(fr1) as NSArray!
            if fer?.count != 0{
                let mo = fer?[0] as! NSManagedObject
                mo.setValuesForKeys(["centerLat": centerCooridnate.latitude, "centerLong": centerCooridnate.longitude, "spanLat": span.latitudeDelta, "spanLong": span.longitudeDelta])
                print("the region data is: \(mo)")
            } else {
               let nr = MapRegion(centerlat: centerCooridnate.latitude, centerlong: centerCooridnate.longitude, spanlat: span.latitudeDelta, spanlong: span.longitudeDelta, context: stack.context)
                print("the initial data: \(nr)")
            }
            
        } catch{
            print("Failed to fetch \(error)")
        }

        do{
            try stack.saveContext()
        } catch{
            print("Error while saving")
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
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("Pin selected")
        let annotation = view.annotation
        let coordinate = annotation?.coordinate
        let lat = (coordinate?.latitude)! as Double
        let long = (coordinate?.longitude)! as Double
       
        fr2.predicate = NSPredicate(format: "lat >= \(lat - precision) AND lat <= \(lat + precision) AND long >= \(long - precision) AND long <= \(long + precision)")
        
        do {
            let fer = try stack.context.fetch(fr2) as NSArray!
            let item = fer?[0] as! NSManagedObject
            if isEdit{
                map.removeAnnotation(annotation!)
                stack.context.delete(item)
                print("item \(item) deleted")
                do{
                    try stack.saveContext()
                } catch{
                    print("Error while saving")
                }
            } else{
                let location = item as? Location
                let control = storyboard?.instantiateViewController(withIdentifier: "imageScreen") as! PictureViewController
                
                let fr = NSFetchRequest<NSFetchRequestResult>(entityName: "PictureURL")
                fr.sortDescriptors = []
                fr.predicate = NSPredicate(format: "location = %@", argumentArray: [location!])
                let fc = NSFetchedResultsController(fetchRequest: fr, managedObjectContext: stack.context, sectionNameKeyPath: nil, cacheName: nil)
                print(fc)
                
                control.fetchedResultsController = fc
                control.lat = lat
                control.long = long
                control.location = location
                navigationController?.pushViewController(control, animated: true)
            }

        } catch{
            print("Failed to fetch \(error)")
        }
    
    }

    @IBAction func deletePin(_ sender: Any) {
        
        if isEdit{
            editButton.title = "Edit"
            deleteLabel.isHidden = true
            isEdit = false
        } else{
            deleteLabel.isHidden = false
            editButton.title = "Done"
            isEdit = true
        }

    }
    
}

