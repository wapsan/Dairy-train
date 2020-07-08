import UIKit

class DTDownloadHud: UIView {
    
    //MARK: - Private properties
    private lazy var progressLineLayer = CAShapeLayer()
    private lazy var trackLayer = CAShapeLayer()
    
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
    
    private lazy var logoImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.image = UIImage.mainLogo
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView() {
        self.addSubview(self.visualEffectView)
        self.addSubview(self.logoImageView)
        self.setUpConstraints()
    }
    
    override func layoutSubviews() {
          super.layoutSubviews()
          self.logoImageView.layer.masksToBounds = true
          self.logoImageView.layer.cornerRadius = self.logoImageView.bounds.height / 2
      }
    
    //MARK: - Public methods
    func showOn(_ viewController: UIViewController) {
        guard let superView = viewController.view else { return }
        superView.addSubview(self)
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: superView.topAnchor),
            self.leftAnchor.constraint(equalTo: superView.leftAnchor),
            self.rightAnchor.constraint(equalTo: superView.rightAnchor),
            self.bottomAnchor.constraint(equalTo: superView.bottomAnchor)
        ])
        self.animateInView(completion: { [weak self] in
            guard let self = self else { return }
            self.addShapeLayer()
            self.startDownloadAnimationWith(duration: 1)
        })
    }
    
    func remove() {
        self.removeFromSuperview()
        NSLayoutConstraint.deactivate(self.constraints)
        self.subviews.forEach({ $0.removeFromSuperview() })
        self.layer.sublayers?.forEach({ $0.removeFromSuperlayer() })
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
            self.logoImageView.centerYAnchor.constraint(equalTo: self.visualEffectView.centerYAnchor),
            self.logoImageView.centerXAnchor.constraint(equalTo: self.visualEffectView.centerXAnchor),
            self.logoImageView.widthAnchor.constraint(equalTo: self.visualEffectView.widthAnchor,
                                                      multiplier: 1/3),
            self.logoImageView.heightAnchor.constraint(equalTo: self.logoImageView.widthAnchor)
        ])
    }

    //MARK: - Private methods
    private func animateInView(completion: @escaping () -> Void) {
        self.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.alpha = 0
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 1
            self.transform = CGAffineTransform.identity
        }, completion: { _ in
            completion()
        })
    }
    
    private func addShapeLayer() {
        let center = self.logoImageView.center
        let radius = self.logoImageView.bounds.height / 2
        let circularPath = UIBezierPath(arcCenter: center,
                                        radius: radius,
                                        startAngle: -CGFloat.pi / 2,
                                        endAngle: 2 * CGFloat.pi,
                                        clockwise: true)
        
        self.trackLayer.path = circularPath.cgPath
        self.trackLayer.strokeColor = UIColor.darkGray.cgColor
        self.trackLayer.lineWidth = 10
        self.trackLayer.fillColor = UIColor.clear.cgColor
        self.layer.addSublayer(trackLayer)
        
        self.progressLineLayer.path = circularPath.cgPath
        self.progressLineLayer.strokeColor = UIColor.red.cgColor
        self.progressLineLayer.lineWidth = 5
        self.progressLineLayer.fillColor = UIColor.clear.cgColor
        self.progressLineLayer.lineCap = .round
        self.progressLineLayer.strokeEnd = 0
        self.layer.addSublayer(progressLineLayer)
    }
    
    private func startDownloadAnimationWith(duration: CFTimeInterval) {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 1
        basicAnimation.duration = duration
        basicAnimation.fillMode = .forwards
        basicAnimation.isRemovedOnCompletion = false
        self.progressLineLayer.add(basicAnimation, forKey: "uorSoBasic")
    }
}

