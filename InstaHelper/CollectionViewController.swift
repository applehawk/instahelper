//
//  ViewController.swift
//  InstaHelper
//
//  Created by Hawk on 20/01/16.
//  Copyright © 2016 Hawk. All rights reserved.
//

import UIKit

class InstaCell : UICollectionViewCell {
    var imageView : UIImageView!

    override init(frame : CGRect) {
        super.init(frame: frame)
        
        imageView = UIImageView()
        self.frame.size = CGSize(width: 64, height: 64)
        contentView.addSubview(imageView)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
}

protocol ChangeTitleAuthButtonDelegate {
    func changeTitle(title:String)
}


class CollectionViewController : UICollectionViewController
{
    @IBOutlet weak var buttonRight: UIButton!
    let engine : InstagramEngine = InstagramEngine.sharedEngine()
    var media : [InstagramMedia]?
    
    var delegate: ChangeTitleAuthButtonDelegate?
    
    var selectedItem : Int = -1
    
    private let reuseIdentifier = "InstaCell"
    
    @IBAction func logoutPressed(sender : UIButton) {
        engine.logout()
        
        delegate?.changeTitle("Authorize")
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        selectedItem = indexPath.row
        performSegueWithIdentifier("detailSegue", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "detailSegue" {
            let destinationDetailView : InstaDetailViewController = (segue.destinationViewController as! InstaDetailViewController)
            destinationDetailView.media = media![selectedItem]
        }
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        collectionView!.registerClass(InstaCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.view.backgroundColor = UIColor.blueColor()
        
        collectionView!.contentInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
       
        engine.getSelfRecentMediaWithSuccess(
        { (media:[InstagramMedia], InstagramPaginationInfo) -> Void in
            self.media = media
            self.collectionView?.reloadData()
        }, failure:
        { (error:NSError, Int) -> Void in
                print( "Error of getMediaWithTagName: \(error)")
        })
            /*
        engine.getMediaWithTagName("moscow", withSuccess: { (media:[InstagramMedia], InstagramPaginationInfo) -> Void in
            self.media = media
            self.collectionView?.reloadData()
            print(media)
            }) { (error: NSError, Int) -> Void in
                print( "Error of getMediaWithTagName: \(error)");
        }*/

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

extension CollectionViewController : UICollectionViewDelegateFlowLayout {
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if (media != nil ) {
            return media!.count
        }
        else {
            return 0
        }
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            if(media != nil) {
                return CGSize(width: 64,
                    height:  64)
            }
            return CGSize(width: 16, height: 16)
    }
    
    func getImageByRow( row : Int ) -> UIImage? {
        let instaMedia = media![row]
        let dataURL = NSData(contentsOfURL: instaMedia.thumbnailURL)
        return UIImage(data: dataURL!)
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell : InstaCell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! InstaCell
        if(media != nil) {
            cell.imageView.image = getImageByRow(indexPath.row)
            cell.imageView.frame.size = CGSize(width: 64, height: 64)
        }
        cell.backgroundColor = UIColor.redColor()
        
        return cell
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

}

extension CollectionViewController : UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // 1
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        textField.addSubview(activityIndicator)
        
        activityIndicator.frame = textField.bounds
        activityIndicator.startAnimating()
        
        
        engine.getMediaWithTagName(textField.text!, withSuccess: { (media:[InstagramMedia], InstagramPaginationInfo) -> Void in
            
            activityIndicator.removeFromSuperview()
            
            self.media = media
            self.collectionView?.reloadData()
            print(media)
            }) { (error: NSError, Int) -> Void in
                print( "Error of getMediaWithTagName: \(error)");
        }
      
        
        textField.text = nil
        textField.resignFirstResponder()
        return true
    }
}
