//
//  InterestViewController.swift
//  Cluztr
//
//  Created by Maxime Dumont on 02/12/15.
//  Copyright © 2015 Cluztr. All rights reserved.
//

import UIKit

class InterestViewController: UICollectionViewController {
    
    var groupId: String?
    var selectedInterest: Array<String> = []
    
    var footer: FooterReusableView?
    
    enum InterestIndex: Int {
        case SOIREE, JEUXVIDEO, SHOPPING, MUSIQUE, VOYAGE, SPORT, CUISINE, MODE, LITTERATURE, TECHNOLOGIE, RESTAURANT, CINEMA, ANIMAUX, CULTURE, DANCE, RENCONTRE
        
        static let interestNames = [
            SOIREE : "Soiree", JEUXVIDEO : "JeuxVideo", SHOPPING : "Shopping", MUSIQUE : "Musique", VOYAGE : "Voyage", SPORT : "Sport", CUISINE : "Cuisine", MODE : "Mode", LITTERATURE : "Litterature", TECHNOLOGIE : "Technologie", RESTAURANT : "Restaurant", CINEMA : "Cinema", ANIMAUX : "Animaux", CULTURE : "Culture", DANCE : "Dance", RENCONTRE : "Rencontre"]
        
        func interestName() -> String {
            if let interestName = InterestIndex.interestNames[self] {
                return interestName
            } else {
                return "default"
            }
        }
        
        func interestImage() -> UIImage {
            return UIImage(named: interestName())!
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBarHidden = true
        self.collectionView!.backgroundColor = UIColor(patternImage: UIImage(named: "bg")!)
        
        let view = UIView(frame:
            CGRect(x: 0.0, y: 0.0, width: UIScreen.mainScreen().bounds.size.width, height: 20.0)
        )
        view.backgroundColor = UIColor.whiteColor()
        
        self.view.addSubview(view)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 16
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! InterestViewCell
        
        if let interestIndex = InterestIndex(rawValue: indexPath.row) {
            cell.interestImage.image = interestIndex.interestImage()
            cell.interestTitle.text = interestIndex.interestName()
        }
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // handle tap events
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! InterestViewCell
        
        let footerView: FooterReusableView?
        
        if #available(iOS 9.0, *) {
            let footerViewIndexPath = collectionView.indexPathsForVisibleSupplementaryElementsOfKind(UICollectionElementKindSectionFooter)
            footerView = collectionView.supplementaryViewForElementKind(UICollectionElementKindSectionFooter, atIndexPath: footerViewIndexPath[0]) as? FooterReusableView
        } else {
            footerView = self.footer
        }
        
        if selectedInterest.contains(cell.interestTitle.text!) {
            if let deletedIndex = selectedInterest.indexOf(cell.interestTitle.text!) {
                selectedInterest.removeAtIndex(deletedIndex)
                cell.interestImage.tintColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
                cell.interestTitle.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
                footerView!.buttonLabel.enabled = false
                footerView!.buttonLabel.backgroundColor = UIColor.clearColor()
            }
        } else {
            if self.selectedInterest.count != 3 {
                self.selectedInterest.append(cell.interestTitle.text!)
                cell.interestImage.tintColor = UIColor.whiteColor()
                cell.interestTitle.textColor = UIColor.whiteColor()
                if self.selectedInterest.count == 3 {
                    footerView!.buttonLabel.enabled = true
                    footerView!.buttonLabel.backgroundColor = UIColor.whiteColor()
                }
            }
        }
    }
    
    override func collectionView(collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        atIndexPath indexPath: NSIndexPath)
        -> UICollectionReusableView {
            switch kind {
                
            case UICollectionElementKindSectionHeader:
                let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "HeaderInterest", forIndexPath: indexPath) as! HeaderReusableView
                
                return headerView
                
            case UICollectionElementKindSectionFooter:
                let footerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "FooterInterest", forIndexPath: indexPath) as! FooterReusableView
                
                if #available(*, iOS 8.0) {
                    self.footer = footerView
                }
                
                footerView.buttonLabel.addTarget(self, action: "saveInterest:", forControlEvents: .TouchUpInside)
                
                return footerView
                
            default:
                
                assert(false, "Unexpected element kind")
            }
    }
    
    func saveInterest(sender: UIButton!) {
        HttpHelper().request(UserRouter.PutInterests(self.selectedInterest),
            success: {json in
                print("----------- Retour JSON save interests ------------")
                print(json)
                print(self.groupId)
                if (self.groupId != nil) {
                    // Join Group
                    HttpHelper().request(GroupRouter.Join(self.groupId!),
                        success: {json in
                            let startViewController = self.storyboard?.instantiateViewControllerWithIdentifier("Start") as? TabBarViewController
                            print(json)
                            startViewController?.user = json["user"]
                            self.presentViewController(startViewController!, animated: true, completion: nil)
                        },
                        errors: {json in
                            var errorMessage = "Une erreur est survenue"
                            
                            if (json["message"].string != nil) {
                                errorMessage = json["message"].string!
                            }
                            
                            let alertController = UIAlertController(title: "Erreur", message: "\(errorMessage)", preferredStyle: UIAlertControllerStyle.Alert)
                            alertController.addAction(UIAlertAction(title: "OKAY", style: UIAlertActionStyle.Default, handler: nil ))
                            
                            self.presentViewController(alertController, animated: true, completion: nil)
                        }
                    )
                } else {
                    // Create Group
                    HttpHelper().request(GroupRouter.CreateGroup(),
                        success: { json in
                            if json["status"] == 201 {
                                let startViewController = self.storyboard?.instantiateViewControllerWithIdentifier("Start") as? TabBarViewController
                                startViewController?.user = json["user"]
                                self.presentViewController(startViewController!, animated: true, completion: nil)
                            }
                        },
                        errors: { json in
                            let alertController = UIAlertController(title: "Erreur", message: "Une erreur est survenue", preferredStyle: UIAlertControllerStyle.Alert)
                            alertController.addAction(UIAlertAction(title: "OKAY", style: UIAlertActionStyle.Default, handler: nil ))
                            
                            self.presentViewController(alertController, animated: true, completion: nil)
                    })
                }
            },
            errors: {error in
                let alertController = UIAlertController(title: "Error Network", message: "\(error["message"])", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "OKAY", style: UIAlertActionStyle.Default, handler: nil ))
                
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        )
    }
}
