//
//  ProductDetails.swift
//  IP INDEX
//
//  Created by Alex Jacobs on 9/10/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class ProductDetails: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet var patentNumbers: UITextField!
    @IBOutlet var longDescription: UITextView!
    
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    @IBAction func nextUpload(sender: AnyObject) {
        
        let post = PFObject(className: "Product")
        
        post["userId"] = PFUser.currentUser()?.objectId!
        post["Patent_Numbers"] = patentNumbers.text
        post["Long_Description"] = longDescription.text
        
        post.saveInBackgroundWithBlock { (success, error) -> Void in
            
            //                self.activityIndicator.stopAnimating()
            //                UIApplication.sharedApplication().endIgnoringInteractionEvents()
            
            if error == nil {
                //                    self.displayAlert("Upload Successful", message: "Your image has been uploaded successfully.")
                print("success")
                self.performSegueWithIdentifier("imageUpload", sender: self)
            } else {
                
                self.displayAlert("Upload Failed", message: "Your upload has failed, please try again.")
                
            }
        }

        
    }
    
    func displayAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction((UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        })))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.patentNumbers.delegate = self
        self.longDescription.delegate = self
        
        self.navigationBar.barTintColor = UIColor(red:0.12, green:0.45, blue:0.73, alpha:1.0)
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationBar.translucent = false        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismiss() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
