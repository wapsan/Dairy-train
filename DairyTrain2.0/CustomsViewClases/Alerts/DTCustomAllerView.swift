import UIKit

class DTCustomAllertView: UIView {
    
    //MARK: - @IBOutlets
    @IBOutlet weak var tittle: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    //MARK: - Publick properties
     weak var delegate: CustomAllertDelegate?
    
    //MARK: - Private methods
    private func hide() {
        UIView.transition(with: self,
                          duration: 0.1,
                          options: [.allowAnimatedContent],
                          animations: { self.alpha = 0 },
                          completion: nil)
        self.textField.text = nil
    }
    
    private func writeInfo() {
        guard let infoString = self.textField.text else { return }
        guard let tittle = self.tittle.text else {  return }
        guard let info = Double(infoString) else { return }
        self.delegate?.getInfoFromCustomAllert(tittle, and: info)
    }
    
    private func setTextField() {
        self.textField.keyboardType = .decimalPad
    }
    
    private func hideKeyboard() {
        self.textField.resignFirstResponder()
    }
    
    private func showKeyboard() {
        self.textField.becomeFirstResponder()
    }
    
    //MARK: - Public methods
    func showWith(_ tittle: String) {
        self.tittle.text = "Set \(tittle)"
        UIView.transition(with: self,
        duration: 0.1,
        options: [.allowAnimatedContent],
        animations: { self.alpha = 1 },
        completion: nil)
        self.showKeyboard()
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
        self.setTextField()
        self.alpha = 0
        
    }
    
    //MARK: - @IBActions
    @IBAction func okButtonTapped(_ sender: UIButton) {
        self.writeInfo()
        self.hide()
        self.delegate?.customAllertOkTapped()
        self.hideKeyboard()
    }
    
    @IBAction func cancelTapped(_ sender: UIButton) {
        self.hide()
        self.delegate?.customAllertCnacelTapped()
        self.hideKeyboard()
    }
    
    deinit {
        print("Custom allert destroyed")
    }
    
}

protocol CustomAllertDelegate: class {
    func customAllertOkTapped()
    func customAllertCnacelTapped()
    func getInfoFromCustomAllert(_ tittle: String, and info: Double)
}


