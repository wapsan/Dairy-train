import UIKit

extension CAGradientLayer {
    
    static func getDefaultGradientFor<T: UIView>(_ view: T,
                                          with firstColor: UIColor,
                                          and secondColor: UIColor) -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [firstColor.cgColor, secondColor.cgColor]
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
    
    static func getSelectedGradientFor<T: UIView>(_ view: T,
                                             with firstColor: UIColor,
                                             and secondColor: UIColor) -> CAGradientLayer {
           let gradientLayer = CAGradientLayer()
           gradientLayer.colors = [firstColor.cgColor, secondColor.cgColor]
           gradientLayer.locations = [0.0, 1.0]
           gradientLayer.cornerRadius = 30
           gradientLayer.frame = view.bounds
           gradientLayer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMaxYCorner]
           gradientLayer.borderWidth = 1
           gradientLayer.startPoint = CGPoint(x: 0, y: 0)
           gradientLayer.endPoint = CGPoint(x: 1, y: 1)
           return gradientLayer
       }
}
