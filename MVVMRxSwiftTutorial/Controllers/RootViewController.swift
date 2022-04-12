//
//  ViewController.swift
//  MVVMRxSwiftTutorial
//
//  Created by JeongminKim on 2022/04/12.
//

import UIKit
import RxSwift
import RxRelay
import RxCocoa

class RootViewController: UIViewController {
    
    // MARK: Properties
    let disposeBag = DisposeBag()
    let viewModel: RootViewModel
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ArticleCell.self, forCellReuseIdentifier: ArticleCell.identifier)
        tableView.rowHeight = 120.0
        return tableView
    }()
    
    private var articleViewModel = BehaviorRelay<[ArticleViewModel]>(value: [])
    var articleViewModelObserver: Observable<[ArticleViewModel]> {
        return articleViewModel.asObservable()
    }
    
    // MARK: Lifecycles
    init(viewModel: RootViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureUI()
        fetchArticles()
        subscribe()
    }
    
    func configureUI() {
        title = self.viewModel.title
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    // MARK: Helpers
    func fetchArticles() {
        viewModel.fetchArticles().subscribe(onNext: { articleViewModels in
            self.articleViewModel.accept(articleViewModels)
        }).disposed(by: disposeBag)
    }
    
    func subscribe() {
        self.articleViewModelObserver.subscribe(onNext: { articles in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }).disposed(by: disposeBag)
    }
}

extension RootViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.articleViewModel.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ArticleCell.identifier, for: indexPath) as? ArticleCell else { return UITableViewCell() }
        cell.articleImageView.image = nil
        let articleViewModel = self.articleViewModel.value[indexPath.row]
        cell.viewModel.onNext(articleViewModel)
        return cell
    }
}
