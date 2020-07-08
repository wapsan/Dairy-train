import UIKit

extension CALayer {

    func bringToFront() {
        guard let layer = superlayer else { return }
        self.removeFromSuperlayer()
        layer.insertSublayer(self, at: UInt32(layer.sublayers?.count ?? 0))
    }
}
