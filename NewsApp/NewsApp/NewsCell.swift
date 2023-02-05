//
//  NewsCell.swift
//  NewsApp
//
//  Created by Alexandra Shurpeleva on 5.02.23.
//

import UIKit

class NewsCell: UITableViewCell {
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var viewLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.iconView.image = nil
        self.titleLabel.text = nil
        self.viewLabel.text = nil
    }
    
    func setup(_ article: Article) {
        self.titleLabel.text = article.title ?? String()
        self.viewLabel.text = article.publishedAT ?? String()
    }
    
    func setImage(_ article: Article) {
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
