//
//  PulseView.swift
//  SebbiaTask
//
//  Created by Александр Иванцов on 25.06.2025.
//

import Foundation
import UIKit

final class PulseView: UIView {
    
    // MARK: - Private properties
    
    private let animationDuration: TimeInterval = 0.5
    
    // MARK: - Life cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public methods
    
    func startAnimation() {
        if layer.animation(forKey: "pulsate") != nil { return }
        
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 1.0
        animation.toValue = 0.5
        animation.duration = animationDuration
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.autoreverses = true
        animation.repeatCount = .infinity
        layer.add(animation, forKey: "pulsate")
    }
    
    func stopAnimation() {
        layer.removeAnimation(forKey: "pulsate")
    }
    
    // MARK: - Private methods
    
    private func setupView() {
        backgroundColor = .systemGray4
        layer.cornerRadius = 8
        clipsToBounds = true
    }
    
}
