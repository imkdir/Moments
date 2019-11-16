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
            let vStack = UIStackView(arrangedSubviews: gridLayout.map(makeHStack(sizes:)))
            vStack.axis = .vertical
            vStack.spacing = stackSpacing
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
            stackView.edges(equal: self)
        }
    }
    
    private func makeHStack(sizes: [CGFloat]) -> UIStackView {
        let hStack = UIStackView(arrangedSubviews: sizes.map(makeImageView(size:)))
        hStack.axis = .horizontal
        hStack.spacing = stackSpacing
        return hStack
    }
    
    private func makeImageView(size: CGFloat) -> UIImageView {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor(white: 0, alpha: 0.1)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.set(.width, to: size).isActive = true
        imageView.aspect(ratio: 1, priority: .defaultHigh).isActive = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }
    
    private let stackSpacing: CGFloat = 4
}
