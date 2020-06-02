import UIKit

class DTRecomendationHeaderView: UIView {
    
    //MARK: - Properties
    var delegate: DTRecomendationHeaderViewDelegate?
     
    //MARK: - Private properties
    var moreInfobuttonIsTouched: Bool = false
    
    //MARK: - @IBOutlets
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var moreInfobutton: UIButton!
    
    //MARK: - Private methods
    private func rotateMoreInfoButton() {
        if !moreInfobuttonIsTouched {
            UIView.animate(withDuration: 0.4, animations: {
                self.moreInfobutton.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
            })
        } else {
            UIView.animate(withDuration: 0.4, animations: {
                self.moreInfobutton.transform = CGAffineTransform(rotationAngle: CGFloat(-2 * Double.pi))
            })
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
    
    //MARK: - Actions
    @IBAction func moreInfoButtonTouched(_ sender: UIButton) {
        if !self.moreInfobuttonIsTouched {
            self.rotateMoreInfoButton()
            self.delegate?.tapOpenCellsButton(sender)
            self.moreInfobuttonIsTouched = true
        } else {
            self.rotateMoreInfoButton()
            self.delegate?.tapOpenCellsButton(sender)
            self.moreInfobuttonIsTouched = false
        }
    }
    
}

protocol DTRecomendationHeaderViewDelegate {
    func tapOpenCellsButton(_ sender: UIButton)
}
