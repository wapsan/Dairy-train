import UIKit

final class AddPopUpViewController: UIViewController {

    //MARK: - Private properties
    private let presenter: AddPopUpPresenterProtocol
    
    // MARK: - @IBOutlets
    @IBOutlet private var backgroundView: UIView!
    @IBOutlet private var decorateView: UIView!
    @IBOutlet private var titleLabel: UILabel?
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var containerView: UIView!
    @IBOutlet private var tableViewHeightConstraint: NSLayoutConstraint!
    
    // MARK: - Lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    override func viewDidLayoutSubviews() {
        tableViewHeightConstraint.constant = tableView.contentSize.height
        super.viewDidLayoutSubviews()
        decorateView.layer.cornerRadius = decorateView.bounds.height / 2
    }
    
    // MARK: - Initialization
    init(presenter: AddPopUpPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setter
    private func setup() {
        tableView.register(cell: PopUpOptionCell.self)
        tableView.tableFooterView = .init()
        containerView.layer.cornerRadius = 20
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    // MARK: - Actions
    @IBAction func backgroundViewTap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITableViewDataSource
extension AddPopUpViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numerOfRow(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PopUpOptionCell.cellID, for: indexPath)
        let option = presenter.option(at: indexPath)
        cell.as(type: PopUpOptionCell.self)?.configureCell(for: option)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension AddPopUpViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectRow(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
