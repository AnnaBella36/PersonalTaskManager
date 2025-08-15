//
//  EmptyStateView.swift
//  PersonalTaskManager
//
//  Created by Olga Dragon on 07.07.2025.
//

import UIKit

final class EmptyStateView: UIView {
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "No Tasks"
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textAlignment = .center
        label.textColor = .gray
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        addSubview(messageLabel)
        NSLayoutConstraint.activate([
            messageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            messageLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: LayoutConstraints.horizontalPadding),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -LayoutConstraints.horizontalPadding)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
