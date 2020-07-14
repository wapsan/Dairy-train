import UIKit

class DTMenuButton: UIButton {
    
    //MARK: - GUI Properties
    private lazy var lineUnderTitle: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: - Initialization
    init() {
        super.init(frame: .zero)
        self.initButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initButton() {
        self.addSubview(self.lineUnderTitle)
        self.setUpLineUnderTitleConstraints()
    }
    
    //MARK: - Constraints
    private func setUpLineUnderTitleConstraints() {
        NSLayoutConstraint.activate([
            self.lineUnderTitle.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.lineUnderTitle.widthAnchor.constraint(equalTo: self.widthAnchor),
            self.lineUnderTitle.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.lineUnderTitle.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
}
