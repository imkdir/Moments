//
//  ImageGridView.swift
//  Moments
//
//  Created by Tung CHENG on 11/15/19.
//  Copyright © 2019 Objective-CHENG. All rights reserved.
//

import UIKit

final class ImageGridView: UIView {
    
    typealias Grid = (content: [[UIImage]], size: CGSize)
    
    var imageGrid: Grid = ([], .zero) {
        didSet {
            let vStack = UIStackView(arrangedSubviews: imageGrid.content.map({ images in
                let hStack = UIStackView(arrangedSubviews: images.map({
                    self.makeGridItemView(image: $0, size: imageGrid.size)
                }))
                hStack.axis = .horizontal
                hStack.spacing = 4
                return hStack
            }))
            vStack.axis = .vertical
            vStack.spacing = 4
            vStack.alignment = .leading
            self.stackView = vStack
        }
    }
    
    private var stackView: UIStackView! {
        didSet {
            guard let stackView = self.stackView else { return }
            oldValue?.removeFromSuperview()
            addSubview(stackView)
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor).isActive = true
            stackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        }
    }
    
    private func makeGridItemView(image: UIImage, size: CGSize) -> UIImageView {
        let imageView = UIImageView(image: image)
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: size.width).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: size.height).isActive = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }
}
