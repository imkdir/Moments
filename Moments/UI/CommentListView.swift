//
//  CommentListView.swift
//  Moments
//
//  Created by Tung CHENG on 11/14/19.
//  Copyright © 2019 Objective-CHENG. All rights reserved.
//

import UIKit

final class CommentListView: UIView {
    
    typealias Comment = (content: String, nickname: String)
    
    var comments: [Comment] = [] {
        didSet {
            let vStack = UIStackView(arrangedSubviews: comments.map({
                let label = UILabel()
                let attributed = NSMutableAttributedString(
                    string: $0.nickname,
                    attributes: [
                        .font: UIFont.systemFont(ofSize: 17, weight: .semibold),
                        .foregroundColor: UIColor(named: "tweet.nick.color")!])
                attributed.append(NSAttributedString(
                    string: ": \($0.content)",
                    attributes: [.font: UIFont.systemFont(ofSize: 17)]))
                label.attributedText = attributed
                label.numberOfLines = 0
                label.translatesAutoresizingMaskIntoConstraints = false
                return label
            }))
            vStack.axis = .vertical
            self.stackView = vStack
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        clipsToBounds = false
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let fillColor = UIColor(named: "comment.background")
        var path = UIBezierPath(
            rect: CGRect(
                x: rect.minX,
                y: rect.minY + offsetY,
                width: rect.width,
                height: rect.height - offsetY))
        fillColor?.setFill()
        path.fill()
        path = UIBezierPath()
        path.move(to: CGPoint(x: rect.minX + offsetX * 2, y: rect.minY + offsetY))
        path.addLine(to: CGPoint(x: rect.minX + offsetX * 3, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX + offsetX * 4, y: rect.minY + offsetY))
        path.close()
        fillColor?.setFill()
        path.fill()
    }
    
    private var stackView: UIStackView! {
        didSet {
            guard let stackView = self.stackView else { return }
            oldValue?.removeFromSuperview()
            addSubview(stackView)
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8).isActive = true
            stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8 + offsetY).isActive = true
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8).isActive = true
        }
    }
    
    private let offsetY: CGFloat = 4
    private let offsetX: CGFloat = 4
}
