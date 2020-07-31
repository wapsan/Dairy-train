import UIKit

extension UIColor {
    
    convenience init(red: CGFloat, green: CGFloat, blue: CGFloat) {
        self.init(red: red / 255, green: green / 255, blue: blue / 255, alpha: 1)
    }
    
    static let viewFlipsideBckgoundColor: UIColor = .init(red: 31 / 255,
                                                          green: 33 / 255,
                                                          blue: 36 / 255,
                                                          alpha: 1)
    static let shadowColorDarkTheme: UIColor = .init(red: 60 / 255,
                                                     green: 60 / 255,
                                                     blue: 60 / 255,
                                                     alpha: 1)
    static let systemRed: UIColor = .init(red: 220 / 255,
                                          green: 20 / 255,
                                          blue: 60 / 255,
                                          alpha: 1)
    static let darkBordoColor: UIColor = .init(red: 85 / 255,
                                               green: 13 / 255,
                                               blue: 12 / 255,
                                               alpha: 1)
}


