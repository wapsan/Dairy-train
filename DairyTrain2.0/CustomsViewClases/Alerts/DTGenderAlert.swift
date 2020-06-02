import UIKit

@IBDesignable
class DTGenderAlert: UIView {
    
    //MARK: - @IBOutlets
    @IBOutlet weak var maleButton: UIButton!
    @IBOutlet weak var fmaleButton: UIButton!

    //MARK: - Publick properties
    weak var delegate: GenderAllertDelegate?
 
    //MARK: - Private methods
    private func hide() {
        UIView.transition(with: self,
                          duration: 0.1,
                          options: [.allowAnimatedContent],
                          animations: { self.alpha = 0 },
                          completion: nil)
    }
    
    private func writeInfo() {
        let buttons = [self.maleButton, self.fmaleButton]
        for button in buttons {
            guard let button = button else { return }
            if button.isSelected == true {
                guard let buttonTittle = button.titleLabel?.text else { return }
                self.delegate?.writeGender(buttonTittle)
            }
        }
    }
    
    //MARK: - Publick methods
    func show() {
        UIView.transition(with: self,
        duration: 0.1,
        options: [.allowAnimatedContent],
        animations: { self.alpha = 1 },
        completion: nil)
        
    }
    
    //MARK: - Actions
    @objc private func maleTapped() {
        if self.maleButton.isSelected == false {
            self.maleButton.isSelected = true
            self.maleButton.tintColor = .black
            self.fmaleButton.isSelected = false
        }
    }
    
    @objc private func femailTapped() {
        if self.fmaleButton.isSelected == false {
            self.fmaleButton.isSelected = true
            self.fmaleButton.tintColor = .black
            self.maleButton.isSelected = false
        }
    }
    
    
    @IBAction func okTapped(_ sender: UIButton) {
        self.writeInfo()
        self.delegate?.genderAllertOkTapped()
        self.hide()
    }
    
    @IBAction func cancelTapped(_ sender: UIButton) {
        self.delegate?.genderAllertCancelTapped()
        self.hide()
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
        let height = width / 1.5
        let y = view.center.y - (height)
        let x = view.center.x - (width / 2)
        super.init(frame: .init(x: x, y: y, width: width, height: height))
        self.loadFromNib()
        self.alpha = 0
        self.maleButton.addTarget(self, action: #selector(self.maleTapped), for: .touchUpInside)
        self.fmaleButton.addTarget(self, action: #selector(self.femailTapped), for: .touchUpInside)
    }
    
}

protocol GenderAllertDelegate: class {
    
    func genderAllertOkTapped()
    func genderAllertCancelTapped()
    func writeGender(_ gender: String)
    
}
