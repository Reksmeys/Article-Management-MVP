//
//  ArticleService.swift
//  AKNHomework
//
//  Created by Raksmey on 12/21/17.
//  Copyright © 2017 admin. All rights reserved.
//

import Foundation
import Alamofire
class ArticleService{
    var delegate: ArticleServiceProtocol?
    
    var article_get_url = "http://api-ams.me/v1/api/articles"
    var articel_post_url = "http://api-ams.me/v1/api/articles"
    var article_delete_url = "http://api-ams.me/v1/api/articles"
    var upload_image_url = "http://api-ams.me/v1/api/uploadfile/single"
    var article_put_url = "http://api-ams.me/v1/api/articles/"
    
    //============with alamofire==============
    let headers = [
        "Content-Type":"application/json",
        "Accept":"application/json",
        "Authorization":"Basic QU1TQVBJQURNSU46QU1TQVBJUEBTU1dPUkQ="
    ]
    func getArticle(withPage: Int, withLimitation: Int){
        var articles = [Article]()
        Alamofire.request("\(article_get_url)?page=\(withPage)&limit=\(withLimitation)", method: .get, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            if response.result.isSuccess {
                if let json = try? JSONSerialization.jsonObject(with: response.data!, options: .allowFragments) as! [String:Any] {
                    let objects = json["DATA"] as! NSArray
                    for obj in objects {
                        articles.append(Article(JSON: obj as! [String:Any])!)
                    }
                    self.delegate?.didResponseArticle(articles: articles)
                }
            }else if response.result.isFailure{
                print("failed to get articles")
            }
        }
    }
    //------- delete article ------------
    func deleteArticle(id:Int) {
       
        // ---- With Alamofire ------------
        
        Alamofire.request("\(article_delete_url)/\(id)", method: .delete,
                          encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
                            print("method delete")
                            if response.result.isSuccess {
                                self.delegate?.didResponseMsg(msg: "Delete Successfully!")
                            }else if response.result.isFailure {
                                print("can't delete")
                            }
        }
        
    }
    //-----------------insert article-------------------
    func insertArticle(articles:Article) {
        let newArticle:[String:Any] = [
            "TITLE": articles.title!,
            "DESCRIPTION": articles.description!,
            "AUTHOR": 1,
            "CATEGORY_ID": 1,
            "STATUS": "1",
            "IMAGE": articles.image!
        ]
        
        // ------ With Alamofire --------
        Alamofire.request(articel_post_url, method: .post, parameters: newArticle, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            if response.result.isSuccess {
                self.delegate?.didResponseMsg(msg: "Insert Successfully!")
            }
        }
    }
    //---------------update article----------------------
    
    //------- update article ------------
    func updateArticle(articles:Article) {
        let newData:[String:Any] = [
            "TITLE": articles.title!,
            "DESCRIPTION": articles.description!,
            "AUTHOR": 1,
            "CATEGORY_ID": 1,
            "STATUS": "1",
            "IMAGE": articles.image!
        ]
       
        
        // ---- With Alamofire ------------
        Alamofire.request("\(article_put_url)\(articles.id!)", method: .put, parameters: newData, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            if response.result.isSuccess {
                self.delegate?.didResponseMsg(msg: "Update Successfully!")
            }
        }
        
    }
    //-----------------insert and update article with upload image--------------------------
  
    func insertUpdateArticle(article:Article, img:Data) {
        Alamofire.upload(multipartFormData: { (multipart) in
            multipart.append(img, withName: "FILE", fileName: ".jpg", mimeType: "image/jpeg")
        }, to: upload_image_url,method:.post,headers:headers) { (encodingResult) in
            switch encodingResult {
            case .success(request: let upload, streamingFromDisk: _ , streamFileURL: _):
                upload.responseJSON(completionHandler: { (response) in
                    if let data = try? JSONSerialization.jsonObject(with: response.data!, options: .allowFragments) as! [String:Any] {
                        let image_url = data["DATA"] as! String
                        article.image = image_url
                        if article.id == 0 {
                            self.insertArticle(articles: article)
                        }else {
                            self.updateArticle(articles: article)
                        }
                    }
                })
            case .failure(let error):
                print("failed to upload : \(error)")
            }
        }
        
    }
    
}
