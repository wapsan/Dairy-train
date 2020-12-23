import UIKit

final class InfoAlert: UIView {
    
    // MARK: - @IBOutlets
    @IBOutlet private var alertContainer: UIView!
    @IBOutlet private var descriptionLabel: UILabel!
    @IBOutlet private var titleLabel: UILabel!
    
    // MARK: - Initialization
    static func view() -> InfoAlert? {
        let nib = Bundle.main.loadNibNamed(String(describing: self), owner: nil, options: nil)
        return nib?.first as? InfoAlert
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    // MARK: - Setter
    private func setup() {
        alertContainer.layer.borderColor = DTColors.controllBorderColor.cgColor
        alertContainer.layer.borderWidth = 1
        alertContainer.layer.cornerRadius = 20
        alertContainer.layer.shadowColor = UIColor.white.cgColor
        alertContainer.layer.shadowOffset = .init(width: 0, height: 2)
        alertContainer.layer.shadowOpacity = 1
    }
    
    // MARK: - Publick methdods
    func show(with title: String, and description: String) {
        guard let topViewController = UIApplication.topViewController() else { return }
        topViewController.view.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: topViewController.view.topAnchor),
            self.leftAnchor.constraint(equalTo: topViewController.view.leftAnchor),
            self.rightAnchor.constraint(equalTo: topViewController.view.rightAnchor),
            self.bottomAnchor.constraint(equalTo: topViewController.view.bottomAnchor)
        ])
        titleLabel.text = title
        descriptionLabel.text = description
        animateInAlert()
    }
    
    // MARK: - Private methods
    private func animateInAlert() {
        alertContainer.transform = .init(translationX: 0, y: -alertContainer.frame.height - 44)
        UIView.animate(withDuration: 0.4,
                       animations: {
                        self.alertContainer.transform = .identity
                       },
                       completion: alertCompletion(_:))
    }
    
    private func alertCompletion(_ success: Bool) {
        guard success else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.animateOutAlert()
        }
    }
    
    private func animateOutAlert() {
        UIView.animate(withDuration: 0.4) {
            self.alertContainer.transform = .init(translationX: 0, y: -self.alertContainer.frame.height - 44)
        } completion: { (_) in
            self.removeFromSuperview()
        }
    }
    
    // MARK: - Actions
    @IBAction func screenTapped(_ sender: Any) {
        animateOutAlert()
    }
}
