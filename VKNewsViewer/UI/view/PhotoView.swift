//
//  PhotoView.swift
//  VKNewsViewer
//
//  Copyright © 2018 NIKO. All rights reserved.
//

import UIKit

class PhotoView: UIImageView {
    
    init() {
        super.init(frame: CGRect.zero)
        clipsToBounds = true
        contentMode = ContentMode.scaleAspectFill        
    }
    
    var constrainedSize: CGSize? {
        didSet {
            self.invalidateIntrinsicContentSize()
        }
    }
    
    
    
    override var intrinsicContentSize: CGSize {
        if let size = constrainedSize {
            return size
        } else {
            return super.intrinsicContentSize
        }
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
