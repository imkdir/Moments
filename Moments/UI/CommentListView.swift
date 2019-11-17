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
            let vStack = UIStackView(arrangedSubviews: comments.map(makeLabel(comment:)))
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
        let fillColor: UIColor = .commentBackground
        let rectangle = UIBezierPath(
            rect: CGRect(
                x: rect.minX,
                y: rect.minY + offsetY,
                width: rect.width,
                height: rect.height - offsetY))
        fillColor.setFill()
        rectangle.fill()
        
        let triangle = UIBezierPath()
        triangle.move(to: CGPoint(x: rect.minX + offsetX * 2, y: rect.minY + offsetY))
        triangle.addLine(to: CGPoint(x: rect.minX + offsetX * 3, y: rect.minY))
        triangle.addLine(to: CGPoint(x: rect.minX + offsetX * 4, y: rect.minY + offsetY))
        triangle.close()
        fillColor.setFill()
        triangle.fill()
    }
    
    private var stackView: UIStackView! {
        didSet {
            guard let stackView = self.stackView else { return }
            oldValue?.removeFromSuperview()
            addSubview(stackView)
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.edges(equal: self, edgeInsets: edgeInsets)
        }
    }
    
    private func makeLabel(comment: Comment) -> UILabel {
        let label = UILabel()
        let attributed = NSMutableAttributedString(
            string: comment.nickname,
            attributes: [
                .font: UIFont.systemFont(ofSize: 15, weight: .semibold),
                .foregroundColor: UIColor.nicknameTextColor])
        attributed.append(NSAttributedString(
            string: ": \(comment.content)",
            attributes: [.font: UIFont.systemFont(ofSize: 15)]))
        label.attributedText = attributed
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private let offsetY: CGFloat = 5
    private let offsetX: CGFloat = 5
    private var edgeInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 8 + offsetY, left: 8, bottom: 8, right: 8)
    }
}
