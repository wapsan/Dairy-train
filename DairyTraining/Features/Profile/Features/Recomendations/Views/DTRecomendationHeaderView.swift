import UIKit

final class DTRecomendationHeaderView: UIView {
    
    //MARK: - Private properties
    private lazy var moreInfobuttonIsTouched: Bool = false
    
    //MARK: - GUI Properties
    private lazy var tittle: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.backgroundColor = .clear
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    //MARK: - Initialization
    init() {
        super.init(frame: .zero)
        self.initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initView() {
        self.backgroundColor = DTColors.backgroundColor
        self.addSubview(self.tittle)
        self.setUpConstraints()
    }
    
    //MARK: - Setter
    func setHeaderView(title: String) {
        self.tittle.text = title
    }

    //MARK: - Constraints
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            self.tittle.topAnchor.constraint(equalTo: self.topAnchor,
                                             constant: DTEdgeInsets.small.top),
            self.tittle.leftAnchor.constraint(equalTo: self.leftAnchor,
                                              constant: DTEdgeInsets.small.left),
            self.tittle.rightAnchor.constraint(greaterThanOrEqualTo: self.leftAnchor,
                                               constant: DTEdgeInsets.small.right),
            self.tittle.bottomAnchor.constraint(equalTo: self.bottomAnchor,
                                                constant: DTEdgeInsets.small.bottom),
        ])
    }
}
