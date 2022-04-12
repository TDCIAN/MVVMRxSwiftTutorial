//
//  ArticleCell.swift
//  MVVMRxSwiftTutorial
//
//  Created by JeongminKim on 2022/04/12.
//

import UIKit
import RxSwift
import SDWebImage

class ArticleCell: UITableViewCell {
    // MARK: Properties
    static let identifier = "ArticleCell"
    let disposeBag = DisposeBag()
    var viewModel = PublishSubject<ArticleViewModel>()
    
    lazy var articleImageView: UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = 8
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.widthAnchor.constraint(equalToConstant: 60).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 60).isActive = true
        iv.backgroundColor = .secondarySystemBackground
        return iv
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        return label
    }()
    
    // MARK: Lifecycles
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        subscribe()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func subscribe() {
        self.viewModel.subscribe(onNext: { articleViewModel in
            if let urlString = articleViewModel.imageUrl {
                self.articleImageView.sd_setImage(with: URL(string: urlString), completed: nil)
            }
            self.titleLabel.text = articleViewModel.title
            self.descriptionLabel.text = articleViewModel.description
        }).disposed(by: disposeBag)
    }
    
    // MARK: Configures
    func configureUI() {
        backgroundColor = .systemBackground
        
        addSubview(articleImageView)
        articleImageView.translatesAutoresizingMaskIntoConstraints = false
        articleImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        articleImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: articleImageView.topAnchor).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: articleImageView.rightAnchor, constant: 20).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -40).isActive = true
        
        addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        descriptionLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor).isActive = true
        descriptionLabel.rightAnchor.constraint(equalTo: titleLabel.rightAnchor).isActive = true
    }
}
