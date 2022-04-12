//
//  ArticleViewModel.swift
//  MVVMRxSwiftTutorial
//
//  Created by JeongminKim on 2022/04/12.
//

import Foundation

struct ArticleViewModel {
    let article: Article
    
    var imageUrl: String? {
        return article.urlToImage
    }
    
    var title: String? {
        return article.title
    }
    
    var description: String? {
        return article.description
    }
}
