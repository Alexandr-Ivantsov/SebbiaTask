//
//  SkeletonCell.swift
//  SebbiaTask
//
//  Created by Александр Иванцов on 25.06.2025.
//

import UIKit
import RxSwift
import RxCocoa
import Stevia

protocol SkeletonCellProtocol {
    var shimmering: Driver<Bool> { get }
    
    func setShimmering(isShimeering: Bool)
}

final class SkeletonCell: UICollectionViewCell, SkeletonCellProtocol {
    
    // MARK: - Public properties
    
    override var reuseIdentifier: String? {
        "SkeletonCell"
    }
    
    var shimmering: Driver<Bool> {
        _shimmering.asDriver(onErrorJustReturn: false)
    }
    
    // MARK: - Private properties
    
    private let _shimmering = BehaviorRelay<Bool>(value: false)
    
    
    static let reuseIdentifier = "SkeletonCell"
    
    // MARK: - Private properties
    
    private let pulseView = PulseView()
    private let bag = DisposeBag()
    
    // MARK: - Life cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(pulseView)
        pulseView.Top == Top
        pulseView.Bottom == Bottom
        pulseView.Leading == Leading
        pulseView.Trailing == Trailing
        
        setupAnimation()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        pulseView.frame = bounds
    }
    
    // MARK: - Public methods
    
    func setShimmering(isShimeering: Bool = true) {
        _shimmering.accept(isShimeering)
    }
    
    // MARK: - Private methods
    
    private func setupAnimation() {
        shimmering.drive(onNext: { [weak self] isShimmering in
            guard let self else { return }
            
            if isShimmering {
                self.pulseView.startAnimation()
            } else {
                self.pulseView.stopAnimation()
            }
        })
        .disposed(by: bag)
    }
    
}
