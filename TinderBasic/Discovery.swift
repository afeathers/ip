//
//  Discovery.swift
//  ParseStarterProject
//
//  Created by Alex Jacobs on 7/29/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit

class Discovery: UIViewController {
    
    var xFromCenter:CGFloat = 0
    var projectnames = [String]()
    var projectImages = [NSData]()
    var projectDescriptions = [String]()
    var currentProject = 0
    

    override func viewDidLoad() {
        super.viewDidLoad()

        let projectImage: UIImageView = UIImageView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height))
        
        projectImage.image = UIImage(named: "person-placeholder.jpg")
        projectImage.contentMode = UIViewContentMode.ScaleAspectFit
        self.view.addSubview(projectImage)
        
        let gesture = UIPanGestureRecognizer(target: self, action: Selector("wasDragged:"))
        projectImage.addGestureRecognizer(gesture)
        
        
        projectImage.userInteractionEnabled = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    func wasDragged(gesture: UIPanGestureRecognizer) {
        
        
        // create variables
        let translation = gesture.translationInView(self.view)
        let label = gesture.view!
        
        xFromCenter += translation.x
        
        let scale = min(200 / abs(xFromCenter), 1)
        
        label.center = CGPoint(x: label.center.x + translation.x, y: label.center.y + translation.y)
        
        gesture.setTranslation(CGPointZero, inView: self.view)
        
        let rotation:CGAffineTransform = CGAffineTransformMakeRotation(xFromCenter / 175)
        
        let stretch:CGAffineTransform = CGAffineTransformScale(rotation, scale, scale)
        
        
        label.transform = stretch
        
        // define whether or not project is liked or disliked
        
        if label.center.x < 100 {
            
            print("Not Chosen", appendNewline: false)
            
        } else if label.center.x > self.view.bounds.width - 100 {
            
            print("Chosen", appendNewline: false)
            
        }
        
        if gesture.state == UIGestureRecognizerState.Ended {
            
            label.removeFromSuperview()
            
            let projectImage: UIImageView = UIImageView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height))
            
            projectImage.image = UIImage(named: "person-placeholder.jpg")
            projectImage.contentMode = UIViewContentMode.ScaleAspectFit
            self.view.addSubview(projectImage)
            
            let gesture = UIPanGestureRecognizer(target: self, action: Selector("wasDragged:"))
            projectImage.addGestureRecognizer(gesture)
            
            
            projectImage.userInteractionEnabled = true
            
            xFromCenter = 0
            
        }

        
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
