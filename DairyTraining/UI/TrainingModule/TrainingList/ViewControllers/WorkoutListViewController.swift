import UIKit

protocol WorkoutListViewProtocol: AnyObject {
    func reloadData()
    func deleteRow(at index: Int)
}

final class WorkoutListViewController: UIViewController {

    // MARK: - @IBOutlets
    @IBOutlet private var tableView: UITableView!
    
    // MARK: - GUI Properties
    private var strechableHeader: StretchableHeader?
    private lazy var timePeriodSelectionHeader = WorkoutListTableHeader.loadFromXib()
    
    // MARK: - Module properties
    private let viewModel: WorkoutListViewModelProtocol
    
    // MARK: - Lyfecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showTabBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        viewModel.viewDidLoad()
    }
    
    // MARK: - Initialization
    init(viewModel: WorkoutListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    private func setup() {
        tableView.register(cell: WorkoutCell.self)
        tableView.register(cell: ErrorCell.self)
        setupHeaders()
    }
    
    private func setupHeaders() {
        let headerSize = CGSize(width: tableView.frame.size.width, height: 250)
        strechableHeader = StretchableHeader(frame: CGRect(x: 0, y: 0, width: headerSize.width, height: headerSize.height))
        strechableHeader?.title = viewModel.title
        strechableHeader?.customDescription = viewModel.description
        strechableHeader?.backgroundColor = .black
        strechableHeader?.backButtonImageType = .none
        strechableHeader?.minimumContentHeight = 44
        guard let header = strechableHeader else { return }
        tableView.addSubview(header)
        
        guard let timePeriodSelectionHeader = self.timePeriodSelectionHeader else { return }
        timePeriodSelectionHeader.translatesAutoresizingMaskIntoConstraints = false
        tableView.addSubview(timePeriodSelectionHeader)
        timePeriodSelectionHeader.timePeriodIndexWasChanged = { [unowned self] index in
            self.viewModel.changeTimePeriodIndexTo(index: index)
        }
        timePeriodSelectionHeader.topAnchor.constraint(equalTo: header.bottomAnchor).isActive = true
        timePeriodSelectionHeader.heightAnchor.constraint(equalToConstant: 50).isActive = true
        timePeriodSelectionHeader.widthAnchor.constraint(equalTo: tableView.widthAnchor).isActive = true
    }
}

// MARK: - WorkoutListViewProtocol
extension WorkoutListViewController: WorkoutListViewProtocol {
    
    func deleteRow(at index: Int) {
        tableView
            .performBatchUpdates({ [unowned self] in
                self.tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .fade)
            }, completion: nil)
    }
    
    func reloadData() {
        guard tableView != nil else { return }
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension WorkoutListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.workoutsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if viewModel.isTrainingExists {
            let cell = tableView.dequeueReusableCell(withIdentifier: WorkoutCell.cellID, for: indexPath)
            let workout = viewModel.getWorkout(for: indexPath.row)
            (cell as? WorkoutCell)?.setCell(for: workout)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: ErrorCell.cellID, for: indexPath)
            (cell as? ErrorCell)?.setCell(for: viewModel.emptyWorkoutsErrorMessage)
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension WorkoutListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectRow(at: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: nil) { (_, _, completionHandler) in
            tableView.performBatchUpdates({ [unowned self] in
                self.viewModel.swipeRow(at: indexPath.row)
            }, completion: nil)
            completionHandler(true)
        }
        deleteAction.image = UIImage(systemName: "trash")?.withTintColor(.white)
        deleteAction.backgroundColor = DTColors.backgroundColor
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return viewModel.isTrainingExists ? configuration : nil
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.isTrainingExists ? UITableView.automaticDimension : 300
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}
