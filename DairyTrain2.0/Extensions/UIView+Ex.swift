import UIKit

extension UIView {
  static var nibName: String {
    return String(describing: Self.self)
  }
  static var nib: UINib {
    let bundle = Bundle(for: Self.self)
    return UINib(nibName: Self.nibName, bundle: bundle)
  }
  func loadFromNib() {
    guard let view = Self.nib.instantiate(withOwner: self, options: nil).first as? UIView else {
      fatalError("Error loading \(self) from nib")
    }
    self.addSubview(view)
    view.translatesAutoresizingMaskIntoConstraints = false
    view.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
    view.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
    view.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
    view.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
  }
}

