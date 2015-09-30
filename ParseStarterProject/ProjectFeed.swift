//
//  ProjectFeed.swift
//  ParseStarterProject
//
//  Created by Alex Jacobs on 8/3/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit

class ProjectFeed: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var projectTableView: UITableView!
    
    let textCellIdentifier = "ProjectCell"
    
    let projectNames = ["Aegirine", "Agate", "Ajoite", "Alexandrite", "Amber", "Ambllygonite", "Anatase", "Andalusite", "Angelite", "Apache Tears", "Apatite", "Apophyllite", "Aquamarine", "Aragonite", "Atacamite", "Axinite"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

       projectTableView.delegate = self
        projectTableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projectNames.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath)
        
        let row = indexPath.row
        cell.textLabel?.text = projectNames[row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let row = indexPath.row
        print(projectNames[row])
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
