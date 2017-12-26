//
//  HomeTableViewCell.swift
//  AKNHomework
//
//  Created by Raksmey on 12/21/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import Kingfisher

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var eyeImageView: UIImageView!
    @IBOutlet weak var calenderImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    var imageURL: String?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configureCellHomePage(articles: Article){
        titleLabel.text = articles.title
        dateLabel.text = articles.createdDate
            if let url = URL(string: imageURL!) {
                self.profileImageView.kf.setImage(with: url)
            }
        
       

    }
    @IBAction func savePhotoButton(_ sender: Any) {
        print("save button is clicked in homecell")
       
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler:
        {
            (alert: UIAlertAction!) -> Void in
            print("Cancelled")
        })
        let selectPhotoAction = UIAlertAction(title: "Select Photo", style: .default, handler:
        {
            (alert: UIAlertAction!) -> Void in
            print("Select Photo")
            
        })
        
        optionMenu.addAction(cancelAction)
        optionMenu.addAction(selectPhotoAction)
        
        //self.present(optionMenu, animated: true, completion: nil)
    }
 
    func saveImage(img: String){
        if let url = URL(string: img){
            let resource = ImageResource(downloadURL: URL(string: img)!, cacheKey: "profile")
            self.profileImageView?.kf.setImage(with: resource)
        }
    }
    
}
