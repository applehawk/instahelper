//
//  InstaDetailViewController.swift
//  InstaHelper
//
//  Created by Hawk on 22/01/16.
//  Copyright © 2016 Hawk. All rights reserved.
//

import UIKit

class InstaDetailViewController: UIViewController {

    @IBOutlet weak var captionText: UITextView!
    @IBOutlet weak var titleMedia: UILabel!
    @IBOutlet weak var thumbnailPhoto: UIImageView!
    
    @IBOutlet weak var tableComments: UITableView!
    var media: InstagramMedia!
    
    var comments : [InstagramComment]?
    var caption : String?
    
    let instaDetailCellIdentifier = "DETAILCELL"
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Comments"
        }
        return ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dataURL = NSData(contentsOfURL: media.thumbnailURL)
        self.thumbnailPhoto.image = UIImage(data: dataURL!)
        self.titleMedia.text = media.user.fullName
        self.comments = media.comments
        self.caption = media.caption?.text
        captionText.text = self.caption
        
        
        InstagramEngine.sharedEngine().getCommentsOnMedia(media.Id, withSuccess: { (comments:[InstagramComment], InstagramPaginationInfo) -> Void in
                self.comments = comments
                self.tableComments.reloadData()
            }) { (error:NSError, Int) -> Void in
                print(error)
        }
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments!.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(instaDetailCellIdentifier)
        if (cell == nil ) {
            cell = UITableViewCell(style: .Default, reuseIdentifier: instaDetailCellIdentifier)
        }
        cell?.textLabel?.text = comments![indexPath.row].text
        cell?.textLabel?.font = UIFont(name: "Arial", size: 14)
        cell?.detailTextLabel?.text = comments![indexPath.row].user.bio
        //cell = comments[indexPath.row].user.bio
        return cell!
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
