//
//  CollectionViewCell.swift
//  Cookie-Health
//
//  Created by Acoffer on 2022/5/19.
//

import UIKit
import Anchorage

class CollectionViewCell: UICollectionViewCell {
    var imageView = UIImageView(image: UIImage(named: "位图"))
    var nameLabel = UILabel()
    var timeLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.imageView)
        self.addSubview(self.nameLabel)
        self.addSubview(self.timeLabel)
        self.imageView.clipsToBounds = true
        self.imageView.layer.cornerRadius = 20
        self.imageView.centerAnchors == self.centerAnchors
        self.imageView.widthAnchor == 150
        self.imageView.heightAnchor == 150
        self.imageView.contentMode = .scaleAspectFill
        self.nameLabel.topAnchor == self.imageView.bottomAnchor + 2
        self.nameLabel.leftAnchor == self.imageView.leftAnchor + 2
        self.nameLabel.text = "一段文字"
        self.timeLabel.topAnchor == self.nameLabel.bottomAnchor
        self.timeLabel.leftAnchor == self.nameLabel.leftAnchor
        self.timeLabel.text = "2022/05/20"
        self.nameLabel.font = UIFont.boldSystemFont(ofSize: 20)
        self.timeLabel.font = UIFont.systemFont(ofSize: 15)
        self.timeLabel.textColor = .gray
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
