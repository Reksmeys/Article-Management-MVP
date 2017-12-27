//
//  HomeViewController.swift
//  AKNHomework
//
//  Created by Raksmey on 12/21/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import SVProgressHUD

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ArticlePresenterProtocol {
    var refresh: UIRefreshControl?
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var slideScrollView: UIScrollView!
    @IBOutlet weak var articleTableView: UITableView!
    var articlePresenter: ArticlePresenter?
    var articles: [Article]?
    var contentWidth: CGFloat = 0.0
    var page: Int = 1
    //pull to get more article
    var newArticle = 0
    var indicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)

    override func viewWillAppear(_ animated: Bool) {
         self.articlePresenter?.getArticle(page: page, limit: 15)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.show(withStatus: "Loading..")
        articles = [Article]()
        articlePresenter = ArticlePresenter()
        refresh = UIRefreshControl()
        self.slideScrollView.delegate = self
        navigationController?.navigationBar.prefersLargeTitles = true
        self.articlePresenter?.delegate = self
       
        self.articleTableView.reloadData()
        self.articleTableView.addSubview(refresh!)
        refresh?.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresh?.tintColor = UIColor.purple
        refresh?.addTarget(self, action: #selector(didRefreshData), for: .valueChanged)
       //---------------scroll view--------------
       

       
    }



    @objc func didRefreshData(){
        page = 1
        self.articlePresenter?.getArticle(page: page, limit: 15)
    }
    //=================pagination==========================
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        newArticle = 0
        print("will display cell")
    }
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        newArticle = newArticle + 1
        print("did end display cell")
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if decelerate && newArticle >= 1 && scrollView.contentOffset.y >= 0 {
            articleTableView.layoutIfNeeded()
            page = page + 1
            self.articleTableView.tableFooterView = indicatorView
            self.articleTableView.tableFooterView?.isHidden = false
            self.articleTableView.tableFooterView?.center = indicatorView.center
            self.indicatorView.startAnimating()
            self.articlePresenter?.getArticle(page: self.page, limit: 15)
            newArticle = 0
            print("loading more image")
        }else if !decelerate {
            newArticle = 0
        }
    }
 
    //==========CONFORM TO ArticlePresenterProtocol====================
    func didResponseArticle(articles: [Article]) {
        if page == 1 {
            self.articles = []
            self.refresh?.endRefreshing()
        }
        self.articles = self.articles! + articles
        DispatchQueue.main.async {
            self.articleTableView.reloadData()
        }
        SVProgressHUD.dismiss()
    }
    
    func didResponseMsg(msg: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Success", message: msg, preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default) { (action) in
                self.dismiss(animated: true, completion: nil)
            }
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
    }
    // ==================== conform to tableview===========================
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       // print("number of array \(articles?.count)")
        return (articles?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! HomeTableViewCell
       // print("image url: \(articles?[indexPath.row].image)")
        
        if articles?[indexPath.row].image == nil {
            cell.imageURL = "http://api-ams.me:80/image-thumbnails/thumbnail-33101c96-b6f9-40db-b0ff-503c50792ae8.jpg"
        }else{
            cell.imageURL = articles?[indexPath.row].image!
            cell.configureCellHomePage(articles: articles![indexPath.row])
        }
     
   
        return cell
    }
    //when table cell is clicked
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detail = storyboard?.instantiateViewController(withIdentifier: "detailStoryBoard") as! DetailViewController
       // print("when click cell: \(articles?[indexPath.row].title)")
        detail.titleArticle = articles?[indexPath.row].title!
        print("did select row: \(articles?[indexPath.row].description)")
        if articles?[indexPath.row].description == nil{
            detail.articleDatail = "អត់មានទិន្នន័យទេល្មមៗបានហើយ"
        }else{
             detail.articleDatail = articles?[indexPath.row].description!
        }
       
        if articles?[indexPath.row].image == nil{
            detail.profile = "http://api-ams.me:80/image-thumbnails/thumbnail-33101c96-b6f9-40db-b0ff-503c50792ae8.jpg"
        }else{
            detail.profile = articles?[indexPath.row].image!
        }
        //detail.profile = articles?[indexPath.row].image!
        
        detail.status = "viewDetail"
        navigationController?.pushViewController(detail, animated: true)
    }
    //swap on table view
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let edit = UITableViewRowAction(style: .normal, title: "edit") { (action, indexPath) in
            let article = self.articles?[indexPath.row]
           // print("article for edit\(article)")
            let edits = self.storyboard?.instantiateViewController(withIdentifier: "detailStoryBoard") as! DetailViewController
            edits.articleDatail = self.articles?[indexPath.row].description
            edits.titleArticle = self.articles?[indexPath.row].title!
            if self.articles?[indexPath.row].image == nil{
                self.articles?[indexPath.row].image = "http://api-ams.me:80/image-thumbnails/thumbnail-33101c96-b6f9-40db-b0ff-503c50792ae8.jpg"
            }else{
                 edits.detailArticle = article
            }
            self.navigationController?.pushViewController(edits, animated: true)
            
        }
        let delete = UITableViewRowAction(style: .default, title: "Delete") { (action, indexPath) in
         
           // print("id :\(self.articles?[indexPath.row].id)")
            self.articlePresenter?.deleteArticle(id: (self.articles?[indexPath.row].id)!)
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Success", message: "Delete Successully", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default) { (action) in
                    self.dismiss(animated: true, completion: nil)
                }
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
                self.articleTableView.reloadData()
            }
            
        }
        return [edit, delete]
    }
    

}
extension HomeViewController: UIScrollViewDelegate{
   
        
    
}
