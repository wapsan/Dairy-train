import UIKit

class DTActivityAllert: UIView {
    
    //MARK: - Publick properties
    var delegate: ActivityAllertDelegate?
    
    //MARK: - @IBOutlets
    @IBOutlet weak var lowButton: UIButton!
    @IBOutlet weak var mediumButton: UIButton!
    @IBOutlet weak var highButton: UIButton!
    
    //MARK: - Publick methods
    func show() {
        UIView.transition(with: self,
                          duration: 0.1,
                          options: [.allowAnimatedContent],
                          animations: { self.alpha = 1 },
                          completion: nil)
    }
    
    //MARK: - Private methods
    private func writeInfo() {
        let buttons = [self.lowButton, self.mediumButton, self.highButton]
        for button in buttons {
            guard let button = button else { return }
            if button.isSelected == true {
                guard let buttonTittle = button.titleLabel?.text else { return }
                self.delegate?.writeActivivtyLeve(buttonTittle)
            }
        }
    }
    
    private func hide() {
        UIView.transition(with: self,
                          duration: 0.1,
                          options: [.allowAnimatedContent],
                          animations: { self.alpha = 0 },
                          completion: nil)
    }
    
    //MARK: - Actions
    @IBAction func okButtonTouched(_ sender: UIButton) {
        self.delegate?.activityAllertOkTapped()
        self.writeInfo()
        self.hide()
    }
    
    @IBAction func cancelButtonTouched(_ sender: UIButton) {
        self.delegate?.activityAllertCancelTapped()
        self.hide()
    }
    

    @objc func lowTapped() {
        if self.lowButton.isSelected == false {
            self.lowButton.isSelected = true
            self.mediumButton.isSelected = false
            self.highButton.isSelected = false
            self.lowButton.tintColor = .black
        }
    }
    
    @objc func mediumTapped() {
        if self.mediumButton.isSelected == false {
            self.mediumButton.isSelected = true
            self.lowButton.isSelected = false
            self.highButton.isSelected = false
            self.mediumButton.tintColor = .black
        }
    }
    
    @objc func highTapped() {
        if self.highButton.isSelected == false {
            self.highButton.isSelected = true
            self.lowButton.isSelected = false
            self.mediumButton.isSelected = false
            self.highButton.tintColor = .black
        }
    }
    
    //MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.loadFromNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.loadFromNib()
    }
    
    init(on view: UIView) {
        let width = view.bounds.width * 0.5
        let height = width
        let y = view.center.y - (height)
        let x = view.center.x - (width / 2)
        super.init(frame: .init(x: x, y: y, width: width, height: height))
        self.loadFromNib()
        self.alpha = 0
        self.lowButton.addTarget(self, action: #selector(self.lowTapped), for: .touchUpInside)
        self.mediumButton.addTarget(self, action: #selector(self.mediumTapped), for: .touchUpInside)
        self.highButton.addTarget(self, action: #selector(self.highTapped), for: .touchUpInside)
    }
    
}


protocol ActivityAllertDelegate {
    func writeActivivtyLeve(_ activityLevel: String)
    func activityAllertOkTapped()
    func activityAllertCancelTapped()
}
