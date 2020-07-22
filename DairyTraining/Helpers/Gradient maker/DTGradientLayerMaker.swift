import UIKit

class DTGradientLayerMaker {
    
    //MARK: - Singletone propeties
    static let shared = DTGradientLayerMaker()
    
    //MARK: - Initialization
    private init() { }
    
    //MARK: - Publick nethods
    func makeDefaultGradient() -> CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.darkBordoColor.cgColor, UIColor.black.cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.cornerRadius = UIScreen.main.bounds.width / 20
//        gradient.cornerRadius = 20
//        gradient.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMaxYCorner]
        gradient.borderWidth = 1
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.shadowColor = UIColor.darkGray.cgColor
        gradient.shadowOffset = .init(width: 0, height: 5)
        gradient.shadowOpacity = 5
        return gradient
    }
    
    func makeSelectedGradient() -> CAGradientLayer {
        let gradient = self.makeDefaultGradient()
        gradient.colors = [UIColor.red.cgColor, UIColor.black.cgColor]
        return gradient
    }
}
