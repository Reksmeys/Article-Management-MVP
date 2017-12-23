//
//  ArticlePresenter.swift
//  AKNHomework
//
//  Created by Raksmey on 12/21/17.
//  Copyright © 2017 admin. All rights reserved.
//

import Foundation
class ArticlePresenter: ArticleServiceProtocol{
    var delegate: ArticlePresenterProtocol?
    var articleService: ArticleService?
    init(){
        self.articleService = ArticleService()
        self.articleService?.delegate = self
    }
    
    func didResponseArticle(articles: [Article]) {
        self.delegate?.didResponseArticle(articles: articles)
    }
    
    func didResponseMsg(msg: String) {
        self.delegate?.didResponseMsg(msg: msg)
    }
    
    //===========get article================
    
    func getArticle(page: Int, limit: Int){
        self.articleService?.getArticle(withPage: page, withLimitation: limit)
    }
    func deleteArticle(id: Int){
        self.articleService?.deleteArticle(id: id)
    }
    func insertUpdateArticle(article:Article, img:Data) {
        self.articleService?.insertUpdateArticle(article: article, img: img)
    }
    
    
}
