import UIKit


class DTActivityIndicator: UIView {
    
    //MARK: - GUI Properties
    private lazy var blurEffect: UIBlurEffect = {
        let blurEffect = UIBlurEffect(style: .systemChromeMaterialDark)
        return blurEffect
    }()
    
    private lazy var visualEffectView: UIVisualEffectView = {
        let visualEffectView = UIVisualEffectView(effect: self.blurEffect)
        visualEffectView.translatesAutoresizingMaskIntoConstraints = false
        return visualEffectView
    }()
    
    private lazy var indicatorContainerView: UIView = {
        let view = UIView()
        
        view.layer.cornerRadius = 20
        view.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var activvityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    //MARK: - Initialization
    init() {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initView() {
        self.addSubview(self.visualEffectView)
        self.addSubview(self.indicatorContainerView)
        self.addSubview(self.activvityIndicator)
        self.setUpConstraints()
    }
    
    //MARK: - Constraints
    private func setUpConstraints() {
        
        NSLayoutConstraint.activate([
            self.visualEffectView.topAnchor.constraint(equalTo: self.topAnchor),
            self.visualEffectView.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.visualEffectView.rightAnchor.constraint(equalTo: self.rightAnchor),
            self.visualEffectView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
        
        NSLayoutConstraint.activate([
            self.indicatorContainerView.centerYAnchor.constraint(equalTo: self.visualEffectView.centerYAnchor),
            self.indicatorContainerView.centerXAnchor.constraint(equalTo: self.visualEffectView.centerXAnchor),
            self.indicatorContainerView.widthAnchor.constraint(equalTo: self.visualEffectView.widthAnchor,
                                                               multiplier: 0.2),
            self.indicatorContainerView.heightAnchor.constraint(equalTo: self.indicatorContainerView.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.activvityIndicator.centerXAnchor.constraint(equalTo: self.indicatorContainerView.centerXAnchor),
            self.activvityIndicator.centerYAnchor.constraint(equalTo: self.indicatorContainerView.centerYAnchor),
            self.activvityIndicator.widthAnchor.constraint(equalTo: self.indicatorContainerView.widthAnchor,
                                        multiplier: 0.5),
            self.activvityIndicator.heightAnchor.constraint(equalTo: self.activvityIndicator.widthAnchor)
        ])
    }
    
    //MARK: - Public methods
    func showOn<T: UIViewController>(_ viewController: T) {
        guard let superView = viewController.view else { return }
        superView.addSubview(self)
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: superView.topAnchor),
            self.leftAnchor.constraint(equalTo: superView.leftAnchor),
            self.rightAnchor.constraint(equalTo: superView.rightAnchor),
            self.bottomAnchor.constraint(equalTo: superView.bottomAnchor)
        ])
      //  self.initView()
        self.activvityIndicator.startAnimating()
    }
    
    func remove() {
        self.activvityIndicator.stopAnimating()
        self.removeFromSuperview()
        NSLayoutConstraint.deactivate(self.constraints)
        self.subviews.forEach({ $0.removeFromSuperview() })
        self.layer.sublayers?.forEach({ $0.removeFromSuperlayer() })
    }
    
}
