//
//  ArticleServiceProtocol.swift
//  AKNHomework
//
//  Created by Raksmey on 12/21/17.
//  Copyright © 2017 admin. All rights reserved.
//

import Foundation

protocol ArticleServiceProtocol {
    func didResponseArticle(articles: [Article])
    func didResponseMsg(msg: String)
}
