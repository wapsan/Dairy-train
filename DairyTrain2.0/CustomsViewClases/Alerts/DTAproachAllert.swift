import UIKit


class DTAproachAlert: UIView {
    
    lazy var tittle: UILabel = {
        let label = UILabel()
        label.text = "Aproach tittle"
        label.textAlignment = .center
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(on view: UIView) {
        let width = view.bounds.width * 0.5
        let height = width
        let y = view.center.y - (height)
        let x = view.center.x - (width / 2)
        super.init(frame: .init(x: x, y: y, width: width, height: height))
        self.backgroundColor = .red
        self.alpha = 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show(on view: UIView) {
        UIView.transition(with: self,
        duration: 0.1,
        options: [.allowAnimatedContent],
        animations: { self.alpha = 1 },
        completion: nil)
    }
    
}
