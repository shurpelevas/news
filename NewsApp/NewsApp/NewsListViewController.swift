//
//  ViewController.swift
//  NewsApp
//
//  Created by Alexandra Shurpeleva on 5.02.23.
//

import UIKit

class NewsListViewController: UIViewController {
    private var viewModel = NewsListViewModel()
    
    private lazy var tableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .singleLine
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var activityIndicator = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel.screenState.bind( { [weak self] state in
            guard let self = self else { return }
            switch state {
            case .loading:
                self.activityIndicator.startAnimating()
            case .loaded(_):
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.activityIndicator.stopAnimating()
                }
            case let .failed(error):
                self.showAlert(error)
                self.activityIndicator.stopAnimating()
            }
        })
        
        self.viewModel.getNewsList()
        self.configure()
    }
    
    private func configure() {
        self.view.backgroundColor = .white
        self.configureLoader()
        self.configureTableView()
    }

    private func configureLoader() {
        self.view.addSubview(self.activityIndicator)
        self.activityIndicator.center = self.view.center
    }
    
    private func configureTableView() {
        self.tableView.register(UINib.init(nibName: "NewsCell", bundle: nil), forCellReuseIdentifier: "NewsCell")
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.view.addSubview(self.tableView)
        self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    
    private func showAlert(_ error: Error) {
        let alertVC = UIAlertController(title: "Warning", message: error.localizedDescription, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Ok", style: .cancel))
        self.present(alertVC, animated: true)
    }
}

extension NewsListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.newsList.first?.articles?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let article = self.viewModel.newsList.first?.articles?[indexPath.row],
              let cell = self.tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath as IndexPath) as? NewsCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        cell.setup(article)
        cell.setImage(article)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let article = self.viewModel.newsList.first?.articles?[indexPath.row] else { return }
        let newsVC = NewsContentViewController(article)
        self.present(newsVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
