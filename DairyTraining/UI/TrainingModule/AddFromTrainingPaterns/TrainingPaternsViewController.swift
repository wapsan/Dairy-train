import UIKit

protocol TrainingPaternsView: AnyObject {
    func reloadTable()
    func deleteCell(at rowIndex: Int)
}

final class TrainingPaternsViewController: DTBackgroundedViewController {

    //MARK: - @IBOutlets
    @IBOutlet private var tableView: UITableView!

    // MARK: - GUI Properties
    private var strechableHeader: StretchableHeader?
    private let namingPaternAlert = PaternNamingAlert.loadFromXib()
    
    // MARK: - Module properties
     private let viewModel: TrainingPaternViewModelProtocol

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    //MARK: - Initialization
    init(viewModel: TrainingPaternViewModelProtocol) {
        self.viewModel = viewModel
        super.init()
    }
}

//MARK: - Private extension
private extension TrainingPaternsViewController {

    func setup() {
        tableView.register(cell: TrainingPaternCell.self)
        tableView.register(cell: ErrorCell.self)
        namingPaternAlert?.delegate = viewModel
        navigationController?.navigationBar.isHidden = true
        setupHeader()
    }
    
    func setupHeader() {
        let headerSize = CGSize(width: tableView.frame.size.width, height: 200)
        strechableHeader = StretchableHeader(frame: CGRect(x: 0, y: 0, width: headerSize.width, height: headerSize.height))
        strechableHeader?.backgroundColor = .black
        strechableHeader?.backButtonImageType = .close
        strechableHeader?.minimumContentHeight = 44
        strechableHeader?.showButtons()
        strechableHeader?.setLeftDownButton(title: "Create patern", image: UIImage(named: "addTraining"), isHiden: false)
        strechableHeader?.onBackButtonAction = { [unowned self] in self.viewModel.closeButtonPressed() }
        strechableHeader?.onLeftButtonAction = { [unowned self] in self.namingPaternAlert?.show() }
        strechableHeader?.title = viewModel.title
        strechableHeader?.customDescription = viewModel.description
        guard let header = strechableHeader else { return }
        tableView.addSubview(header)
    }
}

// MARK: - TrainingPaternsView
extension TrainingPaternsViewController: TrainingPaternsView {
    
    func deleteCell(at rowIndex: Int) {
        tableView.performBatchUpdates({
            tableView.deleteRows(at: [IndexPath(row: rowIndex, section: 0)], with: .fade)
        }, completion: nil)
    }

    func reloadTable() {
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension TrainingPaternsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.paternsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if viewModel.isPaternsExisting {
            let cell = tableView.dequeueReusableCell(withIdentifier: TrainingPaternCell.cellID, for: indexPath)
            (cell as? TrainingPaternCell)?.setCell(for: viewModel.getPatern(for: indexPath.row).name)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: ErrorCell.cellID, for: indexPath)
            (cell as? ErrorCell)?.setCell(for: viewModel.emptyPaternErrorMessage)
            return cell
        }
    }
}

//MARK: - UITableViewDelegate
extension TrainingPaternsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectRow(at: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.isPaternsExisting ? UITableView.automaticDimension : 300
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: nil) { [weak self] (_, _, completionHandler) in
            self?.viewModel.swipeRow(at: indexPath.row)
            completionHandler(true)
        }
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = DTColors.backgroundColor
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
}
