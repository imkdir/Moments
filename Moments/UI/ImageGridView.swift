//
//  ImageGridView.swift
//  Moments
//
//  Created by Tung CHENG on 11/15/19.
//  Copyright © 2019 Objective-CHENG. All rights reserved.
//

import UIKit

final class ImageGridView: UIView {
    
    var gridLayout: [[CGFloat]] = []  {
        didSet {
            let vStack = UIStackView(arrangedSubviews: gridLayout.map({ row in
                let hStack = UIStackView(arrangedSubviews: row.map(makeGridItemView(size:)))
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
    
    var imageGrid: [UIImage] = [] {
        didSet {
            let imageViews = stackView.arrangedSubviews
                .compactMap {
                    (($0 as? UIStackView)?.arrangedSubviews as? [UIImageView])
                }.reduce([], +)
            zip(imageViews, imageGrid).forEach {
                $0.image = $1
            }
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
    
    private func makeGridItemView(size: CGFloat) -> UIImageView {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: size).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: size).isActive = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }
}
