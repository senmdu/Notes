//
//  Mvmm Test
//
//  Created by Senthil Kumar on 19/04/18.
//  Copyright © 2018 Senthil Kumar. All rights reserved.
//  Developer : Senthil Kumar (@senmdu96) - senmdu96@gmail.com
//

import UIKit


extension UIButton {
    
    convenience public init(title: String, titleColor: UIColor, font: UIFont? = .systemFont(ofSize: 14), backgroundColor: UIColor = .clear, target: Any? = nil, action: Selector? = nil, animation: Bool = false) {
        self.init(type: .custom)
        setTitle(title, for: .normal)
        setTitleColor(titleColor, for: .normal)
        self.titleLabel?.font = font
        
        self.backgroundColor = backgroundColor
        if let action = action {
            addTarget(target, action: action, for: .touchUpInside)
        }
        self.translatesAutoresizingMaskIntoConstraints = false
        if animation {
            self.setupClickAnimation()
        }
    }
    
    convenience public init(image: UIImage?,backgroundColor: UIColor? = .clear, tintColor: UIColor? = nil, target: Any? = nil, action: Selector? = nil, animation: Bool = false) {
        self.init(type: .custom)
        self.backgroundColor = backgroundColor
        if tintColor == nil {
            setImage(image, for: .normal)
        } else {
            setImage(image?.withRenderingMode(.alwaysTemplate), for: .normal)
            self.tintColor = tintColor
        }
        
        if let action = action {
            addTarget(target, action: action, for: .touchUpInside)
        }
        self.translatesAutoresizingMaskIntoConstraints = false
        if animation {
            self.setupClickAnimation()
        }
    }
    
    
    func setupClickAnimation() {
        addTarget(self, action: #selector(animateDown), for: [.touchDown, .touchDragEnter])
        addTarget(self, action: #selector(animateUp), for: [.touchDragExit, .touchCancel, .touchUpInside, .touchUpOutside])
    }
    
    func setupAnimationForIcon() {
        addTarget(self, action: #selector(animateDownIcon), for: [.touchDown, .touchDragEnter])
        addTarget(self, action: #selector(animateUp), for: [.touchDragExit, .touchCancel, .touchUpInside, .touchUpOutside])
    }
    
    @objc private func animateDown(sender: UIButton) {
        animate(sender, transform: CGAffineTransform.identity.scaledBy(x: 0.95, y: 0.95))
    }
    
    @objc private func animateDownIcon(sender: UIButton) {
        animate(sender, transform: CGAffineTransform.identity.scaledBy(x: 1.5, y: 1.5))
    }

    @objc private func animateUp(sender: UIButton) {
        animate(sender, transform: .identity)
    }

    private func animate(_ button: UIButton, transform: CGAffineTransform) {
        UIView.animate(withDuration: 0.4,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 3,
                       options: [.curveEaseInOut],
                       animations: {
                        button.transform = transform
        }, completion: nil)
    }
    
    class func getRetryButton(frame: CGRect) -> UIButton{
        let button = UIButton(frame: frame)
        button.setTitle("Retry", for: .normal)
        button.setupClickAnimation()
        button.backgroundColor = App.Color.textPrimary
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return button
    }
}
