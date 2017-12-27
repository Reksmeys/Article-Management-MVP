//
//  DetailViewController.swift
//  AKNHomework
//
//  Created by Raksmey on 12/22/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import Kingfisher
import Photos

class DetailViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var titleArticle: String?
    var articleDatail: String?
    var profile: String?
    var detailArticle: Article?
    var status: String?
    var articlePresenter:ArticlePresenter?
    
    @IBOutlet weak var saveButtton: UIBarButtonItem!
    @IBOutlet weak var articleDetailTextView: UITextView!
    
   
    @IBOutlet weak var titleDetailTextView: UITextView!
    
    @IBOutlet weak var profileDetailImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
    
        articlePresenter = ArticlePresenter()
        self.articlePresenter?.delegate = self
        self.articleDetailTextView.delegate = self
//      navigationController?.navigationBar.prefersLargeTitles = true
        articleDetailTextView.isScrollEnabled = true
        //articleDetailTextView.isEditable = false
        //articleDetailTextView.showsVerticalScrollIndicator = true
        navigationItem.title = "Detail"
        
        
        if status == "viewDetail" {
            print("when view detail: \(titleArticle!)")
            titleDetailTextView.text = titleArticle!
            print("title article: \(titleArticle)")
            articleDetailTextView.text = articleDatail
            if let url = URL(string: (profile!)) {
                self.profileDetailImageView.kf.setImage(with: url)
            }
           // articleDetailTextView.isUserInteractionEnabled = false
            articleDetailTextView.isScrollEnabled = true
            saveButtton.isEnabled = false
        }else{
            if detailArticle != nil{
                print("when edit: \(titleArticle)")
                titleDetailTextView.text = titleArticle
                articleDetailTextView.text = articleDatail
                if let url = URL(string: (detailArticle?.image)!) {
                    self.profileDetailImageView.kf.setImage(with: url)
                }
                print("edit is clicked")
            }else{
               
                self.articleDetailTextView.textColor = UIColor.lightGray
            }
        }
    
       
    }

 
    
    @IBAction func actionSaveButton(_ sender: Any) {
        let image = UIImageJPEGRepresentation(self.profileDetailImageView.image!, 0.5)
        let article = Article()
        if detailArticle != nil {
            article.id = detailArticle?.id
        }else{
            article.id = 0
        }
        article.title = self.titleDetailTextView.text
        article.description = self.articleDetailTextView.text
        
        self.articlePresenter?.insertUpdateArticle(article: article, img: image!)
        
       // self.navigationController?.popViewController(animated: true)
    }
    //guesture for browse image
    @IBAction func browseImage(_ sender: UITapGestureRecognizer){
    
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
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        })
        let saveAction = UIAlertAction(title: "Save Photo", style: .default, handler:
        {
            (alert: UIAlertAction!) -> Void in
            print("save")
             let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
             switch photoAuthorizationStatus {
             case .authorized :
             UIImageWriteToSavedPhotosAlbum(self.profileDetailImageView.image!, nil, nil, nil)
             self.didResponseSave()
             print("save photo")
             break
             case .notDetermined:
             PHPhotoLibrary.requestAuthorization({ (newStatus) in
             if newStatus == PHAuthorizationStatus.authorized {
             UIImageWriteToSavedPhotosAlbum(self.profileDetailImageView.image!, nil, nil, nil)
             self.didResponseSave()
            print("save photo")
             }
             })
             case .restricted: break
             case .denied: break
             }
            
            
        })
        
        optionMenu.addAction(cancelAction)
        optionMenu.addAction(selectPhotoAction)
        optionMenu.addAction(saveAction)
   
        self.present(optionMenu, animated: true, completion: nil)
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image:UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        DispatchQueue.main.async {
            self.profileDetailImageView.image = image
        }
        self.dismiss(animated: true, completion: nil)
    }
    

}
extension DetailViewController:ArticlePresenterProtocol {
    func didResponseArticle(articles: [Article]) {
        
    }
    
    func didResponseMsg(msg: String) {
        print(msg)
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Success", message: msg, preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default) { (action) in
                self.dismiss(animated: true, completion: nil)
            }
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
    }
   
}
extension DetailViewController: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if articleDetailTextView.textColor == UIColor.lightGray{
            articleDetailTextView.text = ""
            articleDetailTextView.textColor = UIColor.black
        }
    }
    func didResponseSave(){
        let alert = UIAlertController(title: "Save Successully", message: "Success", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
}
