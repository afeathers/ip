//
//  UploadImages.swift
//  IP INDEX
//
//  Created by Alex Jacobs on 9/10/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class UploadImages: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet var imagePreview: UIImageView!
    
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    
    func displayAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction((UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        })))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func chooseImage(sender: AnyObject) {
    
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        image.allowsEditing = false
        
        self.presentViewController(image, animated: true, completion: nil)
        print("selectImage tapped")

        
    }
    
    @IBAction func addImage(sender: AnyObject) {
        
        activityIndicator = UIActivityIndicatorView(frame: self.view.frame)
        activityIndicator.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        var post = PFObject(className: "Product")
        
        
        
        
        post["userId"] = PFUser.currentUser()?.objectId!
        
        let imageData = UIImagePNGRepresentation(imagePreview.image!)
        
        let imageFile = PFFile(name: "image.png", data: imageData!)
        
        post["imageFile"] = imageFile
        
        post.saveInBackgroundWithBlock { (success, error) -> Void in
            
            self.activityIndicator.stopAnimating()
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            
            if error == nil {
                self.displayAlert("Upload Successful", message: "Your image has been uploaded successfully.")
                print("success")
            } else {
                
                self.displayAlert("Upload Failed", message: "Your upload has failed, please try again.")
                
            }
            
        }


    
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
        imagePreview.image = image
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController!.navigationBar.barTintColor = UIColor(red:0.12, green:0.45, blue:0.73, alpha:1.0)
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController!.navigationBar.translucent = false

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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
