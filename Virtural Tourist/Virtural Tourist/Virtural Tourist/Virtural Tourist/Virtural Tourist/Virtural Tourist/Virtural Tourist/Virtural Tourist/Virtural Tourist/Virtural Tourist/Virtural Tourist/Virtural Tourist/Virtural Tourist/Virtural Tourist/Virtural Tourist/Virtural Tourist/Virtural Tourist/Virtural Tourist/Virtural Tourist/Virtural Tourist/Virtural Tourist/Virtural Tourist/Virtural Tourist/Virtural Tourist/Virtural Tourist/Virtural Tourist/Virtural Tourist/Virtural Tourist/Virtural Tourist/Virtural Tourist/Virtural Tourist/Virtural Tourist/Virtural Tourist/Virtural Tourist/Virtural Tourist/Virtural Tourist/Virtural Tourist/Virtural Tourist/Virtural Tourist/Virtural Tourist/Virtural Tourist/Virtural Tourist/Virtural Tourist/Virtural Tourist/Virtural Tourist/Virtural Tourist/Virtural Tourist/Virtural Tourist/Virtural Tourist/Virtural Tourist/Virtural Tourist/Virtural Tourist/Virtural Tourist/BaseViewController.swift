//
//  BaseViewController.swift
//  Virtural Tourist
//
//  Created by Carl Lee on 12/9/16.
//  Copyright © 2016 Carl Lee. All rights reserved.
//

import UIKit
import CoreData

class BaseViewController: UIViewController {
    
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>?
    let stack = (UIApplication.shared.delegate as! AppDelegate).stack
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

extension BaseViewController{
    
    /*func executeSearch(){
        
        if let fc = fetchedResultsController{
            
            do{
                try fc.performFetch()
            } catch let e as NSError{
                print("Error while trying to perform a search: \n\(e)\n\(fetchedResultsController)")
            }
        }
        
    }*/
    
}
