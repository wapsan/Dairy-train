import UIKit

final class TimerControllView: UIView {
    
    // MARK: - Properties
    private lazy var progressLineLayer = CAShapeLayer()
    private lazy var trackLayer = CAShapeLayer()
    
    // MARK: - GUI Properties
    private lazy var minuteLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 35)
        label.textColor = .white
        label.text = "00:"
        return label
    }()
    
    private lazy var secndLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 35)
        label.textColor = .white
        label.text = "00:"
        return label
    }()
    private lazy var milisecondsLabelLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 35)
        label.textColor = .white
        label.text = "00"
        return label
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        addShapeLayer()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    // MARK: - Lyfecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        addShapeLayer()
    }
    
    // MARK: - Private methods
    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        addSubview(minuteLabel)
        addSubview(secndLabel)
        addSubview(milisecondsLabelLabel)
        NSLayoutConstraint.activate([
            secndLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            secndLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            minuteLabel.centerYAnchor.constraint(equalTo: secndLabel.centerYAnchor),
            minuteLabel.rightAnchor.constraint(equalTo: secndLabel.leftAnchor),
            milisecondsLabelLabel.centerYAnchor.constraint(equalTo: secndLabel.centerYAnchor),
            milisecondsLabelLabel.leftAnchor.constraint(equalTo: secndLabel.rightAnchor),
        ])
    }
    
    private func addShapeLayer() {
        let centerY = self.bounds.origin.x + self.bounds.width / 2
        let centerX = self.bounds.origin.y + self.bounds.height / 2
        let center = CGPoint(x: centerY, y: centerX)
        let radius = bounds.height / 2
        let circularPath = UIBezierPath(arcCenter: center,
                                        radius: radius,
                                        startAngle: -CGFloat.pi / 2,
                                        endAngle: 2 * CGFloat.pi,
                                        clockwise: true)
        
        trackLayer.path = circularPath.cgPath
        trackLayer.strokeColor = UIColor.lightGray.cgColor
        trackLayer.lineWidth = 20
        trackLayer.fillColor = UIColor.clear.cgColor
        
        layer.addSublayer(trackLayer)
        
        progressLineLayer.path = circularPath.cgPath
        progressLineLayer.strokeColor = DTColors.controllSelectedColor.cgColor
        progressLineLayer.lineWidth = 15
        progressLineLayer.fillColor = UIColor.clear.cgColor
        progressLineLayer.lineCap = .round
        progressLineLayer.strokeEnd = 0
        
        layer.addSublayer(progressLineLayer)
    }
    
    // MARK: - Public methods
    func update(minutes: String, sconds: String, miliseconds: String) {
        minuteLabel.text = minutes
        secndLabel.text = sconds
        milisecondsLabelLabel.text = miliseconds
    }
    
    func startDownloadAnimationWith(duration: TimeInterval) {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        
        basicAnimation.duration = duration * 1.25
        basicAnimation.fromValue = 0
        basicAnimation.speed = 1
        basicAnimation.toValue = 1
        basicAnimation.fillMode = .forwards
        basicAnimation.isRemovedOnCompletion = false
        self.progressLineLayer.add(basicAnimation, forKey: "uorSoBasic")
    }
    
    func stopAnimation() {
        progressLineLayer.removeAllAnimations()
    }
}
