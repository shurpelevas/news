//
//  NewsContentViewController.swift
//  NewsApp
//
//  Created by Alexandra Shurpeleva on 5.02.23.
//

import UIKit

class NewsContentViewController: UIViewController {
    private lazy var iconView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.heightAnchor.constraint(equalToConstant: 200).isActive = true
        return image
    }()
    
    private lazy var authorLabel = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 0
        label.contentMode = .center
        label.font = UIFont(name: "Helvetica Neue", size: 12)
        return label
    }()
    
    private lazy var titleLabel = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 0
        label.contentMode = .center
        label.font = UIFont(name: "Helvetica Neue", size: 18)
        return label
    }()
    
    private lazy var descriptionLabel = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 0
        label.contentMode = .center
        label.font = UIFont(name: "Helvetica Neue", size: 16)
        return label
    }()
    
    private lazy var dateLabel = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 0
        label.font = UIFont(name: "Helvetica Neue", size: 14)
        return label
    }()
    
    private lazy var linkLabel = {
        let label = UILabel()
        label.textColor = .link
        label.numberOfLines = 0
        label.font = UIFont(name: "Helvetica Neue", size: 12)
        return label
    }()
    
    init(_ article: Article) {
        super.init(nibName: nil, bundle: nil)
        self.setImage(article)
        self.authorLabel.text = article.author ?? String()
        self.titleLabel.text = article.title ?? String()
        self.descriptionLabel.text = article.description ?? String()
        self.dateLabel.text = article.publishedAT ?? String()
        self.linkLabel.text = article.url ?? String()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
    }
    
    private func configure() {
        self.view.backgroundColor = .white
        self.setLayout()
        self.configureLink()
    }
    
    private func configureLink() {
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(self.linkTapped(sender:)))
        self.linkLabel.isUserInteractionEnabled = true
        self.linkLabel.addGestureRecognizer(tap)
    }
    
    @objc
    func linkTapped(sender: UITapGestureRecognizer) {
        self.openUrl(self.linkLabel.text ?? String())
    }

    private func openUrl(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    private func setLayout() {
        let stack = UIStackView(arrangedSubviews: [self.iconView, self.authorLabel, self.titleLabel, self.descriptionLabel, self.dateLabel, linkLabel])
        stack.alignment = .center
        stack.axis = .vertical
        stack.spacing = 14
        stack.distribution = .equalCentering
        stack.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(stack)
        stack.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 60).isActive = true
        stack.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
        stack.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16).isActive = true
        stack.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -40).isActive = true
        
        self.iconView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 40).isActive = true
        self.iconView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -40).isActive = true
    }
    
    private func setImage(_ article: Article) {
        if let url = URL(string: article.urlToImage ?? String()) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let imageData = data else { return }
                DispatchQueue.main.async {
                    self.iconView.image = UIImage(data: imageData)
                }
            }.resume()
        }
    }
}
