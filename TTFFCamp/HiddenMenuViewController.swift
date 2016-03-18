//
//  HiddenMenuViewController.swift
//  TTFFCamp
//
//  Created by yanze on 3/13/16.
//  Copyright © 2016 The Taylor Family Foundation. All rights reserved.
//

import UIKit
import Alamofire
import Foundation


class HiddenMenuViewController: UIViewController {
    
    @IBOutlet weak var userInputLabel: UITextField!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var testImage: UIImageView!
    @IBOutlet weak var passwordInput: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageLabel.hidden = true
        messageLabel.textColor = UIColor.redColor()
        userInputLabel.attributedPlaceholder = NSAttributedString(string:"Please enter your IP address",
            attributes:[NSForegroundColorAttributeName: UIColor.grayColor()])
        passwordInput.attributedPlaceholder = NSAttributedString(string:"Please enter your password",
            attributes:[NSForegroundColorAttributeName: UIColor.grayColor()])

        
    }
    
    @IBAction func clickToSynchronize(sender: UIButton) {
        
        let ipCheck = regExIpAddressCheck(userInputLabel.text!)

        if ipCheck && passwordInput.text == "ttff" {
            messageLabel.text = "Downloading..."
            messageLabel.textColor = UIColor.blueColor()
            messageLabel.hidden = false
            var successCheck = false
            
            Alamofire.request(.GET, "http://\(userInputLabel.text!):8001/getAllPlants")
                .responseJSON { response in
                    if let JSON = response.result.value {
                        var plantArray = [Plant]()
                    
                        // parse JSON data and create new Plant objs and Plant array
                        for anItem in JSON as! [Dictionary<String, AnyObject>] {
                            let plantObj = Plant()
                            if let newName = anItem["name"] {
                                plantObj.plantName = newName as! String
                            }
                            if let newLocation = anItem["location"] {
                                plantObj.location = newLocation as! String
                            }
                            if let newOrigin = anItem["origin"] {
                                plantObj.origin = newOrigin as! String
                            }
                            if let newDesc = anItem["description"] {
                                plantObj.plantDescription = newDesc as! String
                            }
                            if let newWTP = anItem["whenToPlant"] {
                                plantObj.whenToPlant = newWTP as! String
                            }
                            if let newCF = anItem["coolFact"] {
                                plantObj.coolFact = newCF as! String
                            }
                            if let newMF = anItem["moreFact"] {
                                plantObj.moreFacts = newMF as! String
                            }
                            if let newImage = anItem["imgStr"] {
                                plantObj.image = newImage as! String
                            }

                            plantArray.append(plantObj)
                                            
                        }
                        
                        print("new plant array", plantArray)
                                        
                        Database.save(plantArray, toSchema: Plant.schema, forKey: Plant.key) // save all to local storage
                        
                        successCheck = true
                    }
                    if successCheck {
                        self.messageLabel.text = "COMPLETE"
                        successCheck = false
                    } else {
                        self.messageLabel.text = "ERROR"
                        self.messageLabel.textColor = UIColor.redColor()
                    }
                }
        }
        else {
            messageLabel.text = "Wrong Entry"
            messageLabel.hidden = false
            messageLabel.textColor = UIColor.redColor()
        }
        
    }
    
    
    func regExIpAddressCheck(ipAddress: String) -> Bool {
        let validIpAddressRegex = "^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$"
        
        if ipAddress.rangeOfString(validIpAddressRegex, options: .RegularExpressionSearch) != nil {
            print("IP is valid")
            return true
        } else {
            print("IP is NOT valid")
            return false
        }
        
    }
    

    
    
}