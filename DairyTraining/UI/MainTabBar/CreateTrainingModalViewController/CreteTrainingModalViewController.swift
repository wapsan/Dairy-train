import UIKit



final class CreteTrainingModalViewController: UIViewController {

    private let viewModel: CreatingTrainingModalViewModelProtocol
    
    // MARK: - @IBOutlets
    @IBOutlet private var backgroundView: UIView!
    @IBOutlet private var decorateView: UIView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var containerView: UIView!
    
    // MARK: - Lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        decorateView.layer.cornerRadius = decorateView.bounds.height / 2
    }
    
    // MARK: - Initialization
    init(viewModel: CreatingTrainingModalViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setter
    private func setup() {
        tableView.register(cell: PopUpOptionCell.self)
        containerView.layer.cornerRadius = 20
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    // MARK: - Actions
    @IBAction func backgroundViewTap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITableViewDataSource
extension CreteTrainingModalViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CreatingTrainingModalModel.Option.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PopUpOptionCell.cellID, for: indexPath)
        let popUpMenuItem = CreatingTrainingModalModel.Option.allCases[indexPath.row]
        (cell as? PopUpOptionCell)?.setCell(title: popUpMenuItem.title, and: popUpMenuItem.image)
        (cell as? PopUpOptionCell)?.action = { [unowned self] in
            self.dismiss(animated: true, completion: {
                CreatingTrainingModalModel.Option.allCases[indexPath.row].onAction()
            })
        }
        return cell
    }
}

// MARK: - UITableViewDelegate
extension CreteTrainingModalViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.bounds.height / CGFloat(CreatingTrainingModalModel.Option.allCases.count)
    }
}
