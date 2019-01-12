//
//  PostCell.swift
//  VKNewsViewer
//
//  Copyright © 2018 NIKO. All rights reserved.
//

import UIKit

class PostCell: UICollectionViewCell {
    
    //MARK: - static constants
    private static let nameLabelFont = UIFont.init(name: "AvenirNext-Medium", size: 17)
    private static let timeLabelFont = UIFont.init(name: "AvenirNext-Medium", size: 14)
    private static let descriptionLabelFont = UIFont.init(name: "AvenirNext-Regular", size: 16)
    
    // MARK: - Headers
    private let avatarImageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor("909499")
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
        imageView.contentMode = ContentMode.scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = PostCell.nameLabelFont
        label.textColor = UIColor("45678f")
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = timeLabelFont
        label.textColor = UIColor("909499")
        return label
    }()
    
    
    // MARK: - Content
    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let photosStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        for _ in 0...9 {
            let photoView = PhotoView()
            photoView.isHidden = true
            stackView.addArrangedSubview(photoView)
        }

        return stackView
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = PostCell.descriptionLabelFont
        label.textColor = UIColor("000000")
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Footer
    private let likesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.alpha = 0.5
        label.font = UIFont.init(name: "AvenirNext-Medium", size: 14)
        label.textColor = UIColor("000000")
        return label
    }()
    
    private let viewedLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.alpha = 0.5
        label.textAlignment = .right
        label.font = UIFont.init(name: "AvenirNext-Medium", size: 14)
        label.textColor = UIColor("000000")
        return label
    }()
    
    // MARK: - update
    var post: Post? {
        didSet{
            nameLabel.text = post!.name
            timeLabel.text = post!.time
            
            if let avatarURL = post?.avatarURL {
                self.avatarImageView.imageWithURL(url: avatarURL)
            }else{
                self.avatarImageView.image = nil
            }
            likesLabel.text = "🖤 \(post!.likes)"
            viewedLabel.text = "👁 \(post!.viewes)"
            
            //Optional
            if post!.photos.count > 0 {
                photosStackView.isHidden = false
                for ind in 0...9 {
                    let photoView = photosStackView.subviews[ind] as! PhotoView
                    if ind < post!.photos.count {
                        photoView.isHidden = false
                        photoView.imageWithURL(url: post!.photos[ind].url)
                    } else {
                        photoView.isHidden = true
                    }
                }
            }else{
                photosStackView.isHidden = true
            }
            
            if let desc = post?.text {
                descriptionLabel.isHidden = false
                descriptionLabel.text = desc
            }else{
                descriptionLabel.isHidden = true
            }
            
        }
    }
    
    // MARK: - init cell
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    private func setupView() {
        
        backgroundColor = UIColor("ffffff")
        
        //Header
        addSubview(avatarImageView)
        addSubview(nameLabel)
        addSubview(timeLabel)
        
        //Content
        addSubview(contentStackView)
        contentStackView.addArrangedSubview(self.descriptionLabel)
        contentStackView.addArrangedSubview(self.photosStackView)
        
        //Footer
        addSubview(likesLabel)
        addSubview(viewedLabel)
        
        
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            avatarImageView.leadingAnchor.constraint(equalTo:  safeAreaLayoutGuide.leadingAnchor, constant: 20),
            avatarImageView.widthAnchor.constraint(equalToConstant: 50),
            avatarImageView.heightAnchor.constraint(equalToConstant: 50),
            
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
            nameLabel.heightAnchor.constraint(equalToConstant: 25),
            
            timeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            timeLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 20),
            timeLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
            timeLabel.heightAnchor.constraint(equalToConstant: 25),
            
            likesLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            likesLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            likesLabel.heightAnchor.constraint(equalToConstant: 25),
            likesLabel.widthAnchor.constraint(equalToConstant: 100),
            
            viewedLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            viewedLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
            viewedLabel.heightAnchor.constraint(equalToConstant: 25),
            viewedLabel.widthAnchor.constraint(equalToConstant: 100),
            
            contentStackView.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 10),
            contentStackView.bottomAnchor.constraint(equalTo: likesLabel.topAnchor, constant: -10),
            contentStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            contentStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20)
            ]);
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - static methods
    
    static func calculateTextHeight(text: String, width:CGFloat) -> CGFloat {
        
        let rect = NSString(string: text).boundingRect(with: CGSize(width: width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font: descriptionLabelFont!], context: nil)
        
        return rect.height
    }
    
    override func layoutSubviews() {
        for ind in 0..<post!.photos.count {
            let photoView = photosStackView.subviews[ind] as! PhotoView
            let contentWidth = frame.width - 40 - safeAreaInsets.left - safeAreaInsets.right            
            photoView.constrainedSize = CGSize(width: contentWidth, height: CGFloat(post!.photos[ind].height) * contentWidth / CGFloat(post!.photos[ind].width))
        }
    }
}
