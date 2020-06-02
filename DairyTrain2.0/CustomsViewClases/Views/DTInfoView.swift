import UIKit

@IBDesignable
class DTInfoView: UIView {
    
    enum InfoViewType {
        case age
        case height
        case weight
    }
    
    //MARK: - @IBOutlets
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var metricLabel: UILabel!
    
    //MARK: - Public properties
    var infoViewTapped: ((String) -> Void)? = nil
    var isSet: Bool {
        get {
            switch self.valueLabel.text {
            case "0","_":
                return false
            default:
                return true
            }
        }
    }
    
    var type: InfoViewType? {
        didSet {
            switch self.type! {
            case .age:
                break
            case .height:
                self.changeHeightMetric()
            case .weight:
                self.changeWeightMetric()
            }
        }
    }
        
    //MARK: - Actions
    @objc private func changeHeightMetric() {
        guard self.type == .some(.height) else { return }
        self.metricLabel.text = MeteringSetting.shared.heightDescription
        guard let value = self.valueLabel.text else { return }
        if let displayValue = Double(value) {
            let result = Double(displayValue * MeteringSetting.shared.heightMultiplier)
            self.valueLabel.text = String(format: "%.1f", result)
        }
    }
    
    @objc private func changeWeightMetric() {
        guard self.type == .some(.weight) else { return }
        self.metricLabel.text = MeteringSetting.shared.weightDescription
        guard let value = self.valueLabel.text else { return }
        if let displayValue = Double(value) {
            print("")
            let result = Double(displayValue * MeteringSetting.shared.weightMultiplier)
            self.valueLabel.text = String(format: "%.1f", result)
        }
    }
    

    //MARK: - Public properties @IBInspectable
    @IBInspectable
    var infoLabelText: String? {
        didSet {
            self.infoLabel.text = self.infoLabelText
        }
    }
    
    @IBInspectable
    var valueLabelText: String? {
        didSet {
            self.valueLabel.text = self.valueLabelText
        }
    }
    
    @IBInspectable
    var metricLableText: String? {
        didSet {
            self.metricLabel.text = self.metricLableText
        }
    }
    
    @IBInspectable
    var viewColor: UIColor? {
        didSet {
            self.backgroundView.backgroundColor = self.viewColor
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        didSet {
            self.backgroundView.layer.borderColor  = self.borderColor?.cgColor
        }
    }
        
    //MARK: - Private methods
    private func setCorners() {
        self.backgroundView.layer.cornerRadius = self.backgroundView.bounds.height / 3
    }
    
    private func setBirderWitdh() {
        self.backgroundView.layer.borderWidth = 1
    }
    
    private func setShadow() {
        self.layer.shadowColor = UIColor.shadowColorDarkTheme.cgColor
        self.layer.shadowOffset = .init(width: 0, height: 5)
        self.layer.shadowOpacity = 5
    }
    
    private func setTextColor() {
        self.infoLabel.textColor = .white
        self.valueLabel.textColor = .white
        self.metricLabel.textColor = .white
    }
    
    private func unableMultiTOuch() {
        self.backgroundView.isMultipleTouchEnabled = false
        self.backgroundView.isExclusiveTouch = true
    }
    
    private func setTapRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapSelector))
        self.addGestureRecognizer(tap)
    }
    
  
    //MARK: - Actions
    @objc private func tapSelector() {
        self.infoViewTapped!(self.infoLabel.text ?? "Error")
    }
    
    //MARK: - Publick methods
    override func prepareForInterfaceBuilder() {
        self.setCorners()
        self.setTextColor()
    }
    
    override func layoutSubviews() {
        self.setCorners()
        self.setTextColor()
        self.unableMultiTOuch()
        self.setShadow()
    }
    
    //MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.loadFromNib()
        self.setTapRecognizer()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.loadFromNib()
        self.setTapRecognizer()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.changeHeightMetric),
                                               name: .heightMetricChanged,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.changeWeightMetric),
                                               name: .weightMetricChanged,
                                               object: nil)
    }
    
}
