//
//  SearchViewController.swift
//  Cluztr
//
//  Created by Franck LAPEYRE on 02/10/2015.
//  Copyright © 2015 Cluztr. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Locksmith
import MapKit

class SearchViewController: UIViewController, CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate  {

    @IBOutlet weak var MapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    
    var listGroups: JSON?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.setMapView()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func logout(sender: AnyObject) {
        FBSDKLoginManager().logOut()
        if let _ = Locksmith.loadDataForUserAccount("access_token") {
            do {
                try Locksmith.deleteDataForUserAccount("access_token")
                try Locksmith.deleteDataForUserAccount("email")
            } catch _ {
                print("Error delete access token from keychain")
            }
        }
        let rootViewController = self.storyboard?.instantiateViewControllerWithIdentifier("rootViewController") as? WalkthroughViewController
        self.presentViewController(rootViewController!, animated: true, completion: nil)
//        self.view.window?.rootViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func searchMode(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.setMapView()
        case 1:
            self.setListView()
        default:
            break
        }
    }
    
    func setListView() {
        MapView.hidden = true
        tableView.hidden = false
        HttpHelper().request(GroupRouter.GetGroups(),
            success: {json in
                // User Login
                self.listGroups = json["data"]
                self.tableView.reloadData()
            },
            errors: {error in
                print("Erreur HTTP get groups | \(error)")
                let alertController = UIAlertController(title: "Error Network", message: "\(error["message"])", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "OKAY", style: UIAlertActionStyle.Default, handler: nil ))
                
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        )
    }
    
    func setMapView() {
        MapView.hidden = false
        tableView.hidden = true
    }
    
    let regionRadius: CLLocationDistance = 1000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        MapView.setRegion(coordinateRegion, animated: true)
    }
    
    // MARK: - location manager to authorize user location for Maps app
    var locationManager = CLLocationManager()
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
            MapView.showsUserLocation = true
            locationManager.delegate = self
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.startUpdatingLocation()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationAuthorizationStatus()
    }

    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.first!
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 500, 500)
        MapView.setRegion(coordinateRegion, animated: true)
    }
    
    // MARK: - TableView Datasource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = self.listGroups?.count {
            return count
        }
        
        return 0
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("listGroupCell") as! ListGroupTableViewCell
        let group = self.listGroups![indexPath.row]
        cell.initUI(group)
        cell.tag = indexPath.row
        
        return cell
    }
    
    func tableView(tableView: UITableView,
        willDisplayCell cell: UITableViewCell,
        forRowAtIndexPath indexPath: NSIndexPath) {
            
            guard let tableViewCell = cell as? ListGroupTableViewCell else { return }
            
            tableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destinationVC = segue.destinationViewController as! OtherGroupViewController
        let group = self.listGroups![sender!.tag]
        destinationVC.group = group
    }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
            var group = listGroups![collectionView.tag]
            var groupInterests: [String] = []
            
            for (key, user) in group["usersId"] {
                for (key, interest) in user["interests"] {
                    if !(groupInterests.contains(interest["name"].string!)) {
                        groupInterests.append(interest["name"].string!)
                    }
                }
            }
            
            listGroups![collectionView.tag]["interests"] = JSON(groupInterests)

            return groupInterests.count
    }
    
    func collectionView(collectionView: UICollectionView,
        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
            
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("interestCell",
                forIndexPath: indexPath) as! InterestListCollectionViewCell
            var group = listGroups![collectionView.tag]
            
            cell.interestName.text = group["interests"][indexPath.row].string

            return cell
    }

   
    
    
}

