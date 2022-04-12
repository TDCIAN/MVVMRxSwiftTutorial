//
//  RootViewModel.swift
//  MVVMRxSwiftTutorial
//
//  Created by JeongminKim on 2022/04/12.
//

import Foundation
import RxSwift

final class RootViewModel {
    let title = "News"
    
    private let articleService: ArticleServiceProtocol
    
    init(articleService: ArticleServiceProtocol) {
        self.articleService = articleService
    }
    
    func fetchArticles() -> Observable<[ArticleViewModel]> {
        return articleService.fetchNews().map {
            $0.map { ArticleViewModel(article: $0) }
        }
    }
}
