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
        if articles.image == nil{
            self.profileImageView.image = UIImage(named: "http://api-ams.me:80/image-thumbnails/thumbnail-33101c96-b6f9-40db-b0ff-503c50792ae8.jpg")
        }else{
            if let url = URL(string: articles.image!) {
                self.profileImageView.kf.setImage(with: url)
            }
        }
       

    }
    @IBAction func savePhotoButton(_ sender: Any) {
        print("save button is clicked in homecell")
        saveImage(img: imageURL!)
    }
 
    func saveImage(img: String){
        if let url = URL(string: img){
            let resource = ImageResource(downloadURL: URL(string: img)!, cacheKey: "profile")
            self.profileImageView?.kf.setImage(with: resource)
        }
    }
    
}
