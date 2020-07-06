import UIKit

extension CAGradientLayer {
    
    static func getGradientFor<T: UIView>(_ view: T) -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.darkBordoColor.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.cornerRadius = 30
        gradientLayer.frame = view.bounds
        gradientLayer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMaxYCorner]
        gradientLayer.borderWidth = 1
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.shadowColor = UIColor.darkGray.cgColor
        gradientLayer.shadowOffset = .init(width: 0, height: 5)
        gradientLayer.shadowOpacity = 5
        return gradientLayer
    }
}
