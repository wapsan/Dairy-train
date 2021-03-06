import UIKit

class DTHeaderView: UIView {
    
    //MARK: - GUI Properties
    private lazy var titleLabel: DTAdaptiveLabel = {
        let label = DTAdaptiveLabel()
        label.font = .systemFont(ofSize: 20)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var whiteLineUnderLabel: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: - Initialization
    init(title: String) {
        super.init(frame: .zero)
        self.titleLabel.text = title
        self.initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initView() {
        self.backgroundColor = .clear
        self.addSubview(self.titleLabel)
        self.addSubview(self.whiteLineUnderLabel)
        self.setUpConstraints()
    }
    
    //MARK: - Constraints
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            self.whiteLineUnderLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.whiteLineUnderLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.whiteLineUnderLabel.heightAnchor.constraint(equalToConstant: 1),
            self.whiteLineUnderLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.85)
        ])
        
        NSLayoutConstraint.activate([
            self.titleLabel.topAnchor.constraint(equalTo: self.topAnchor,
                                                 constant: DTEdgeInsets.small.top),
            self.titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.titleLabel.widthAnchor.constraint(equalTo: self.whiteLineUnderLabel.widthAnchor),
            self.titleLabel.bottomAnchor.constraint(equalTo: self.whiteLineUnderLabel.topAnchor,
                                                    constant: DTEdgeInsets.small.bottom)
        ])
    }
}
