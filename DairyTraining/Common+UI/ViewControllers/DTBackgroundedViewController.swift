import UIKit

class DTBackgroundedViewController: BaseViewController {
    
    //MARK: - GUI Properties
    private lazy var backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage.activitiesBackGroundImage
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
      //  self.setUpViewController()
        self.view.backgroundColor = DTColors.backgroundColor
    }
    
    //MARK: - Private methods
    private func setUpViewController() {
        self.view.addSubview(self.backgroundImage)
        self.setUpConstraints()
    }
    
    //MARK: - Setter
    func setBackgroundImageTo(_ image: UIImage?) {
        self.backgroundImage.image = image
    }
    
    //MARK: - Constraints
    private func setUpConstraints() {
        let safeArea = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            self.backgroundImage.topAnchor.constraint(equalTo: safeArea.topAnchor),
            self.backgroundImage.leftAnchor.constraint(equalTo: safeArea.leftAnchor),
            self.backgroundImage.rightAnchor.constraint(equalTo: safeArea.rightAnchor),
            self.backgroundImage.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
        ])
    }
}
