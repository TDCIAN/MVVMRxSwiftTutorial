//
//  ArticleService.swift
//  MVVMRxSwiftTutorial
//
//  Created by JeongminKim on 2022/04/12.
//

import Foundation
import Alamofire
import RxSwift

protocol ArticleServiceProtocol {
    func fetchNews() -> Observable<[Article]>
}
class ArticleService: ArticleServiceProtocol {
    func fetchNews() -> Observable<[Article]> {
        return Observable.create { (observer) -> Disposable in
            self.fetchNews { error, articles in
                if let error = error {
                    observer.onError(error)
                }
                if let articles = articles {
                    observer.onNext(articles)
                }
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    private func fetchNews(completion: @escaping((Error?, [Article]?) -> Void)) {
        let urlString = "https://newsapi.org/v2/everything?q=bitcoin&apiKey=6d61b0036eb24a718896dca571428bc2"
        guard let url = URL(string: urlString) else { return }
        AF.request(
            url, method: HTTPMethod.get
        ).responseDecodable(of: ArticleResponse.self) { response in
            if let error = response.error {
                return completion(error, nil)
            }
            if let articles = response.value?.articles {
                return completion(nil, articles)
            }
        }
        .resume()
    }
}
