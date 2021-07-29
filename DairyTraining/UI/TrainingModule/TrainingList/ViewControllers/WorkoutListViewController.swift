import UIKit

protocol WorkoutListViewProtocol: AnyObject {
    func reloadData()
    func deleteRow(at indexPath: IndexPath)
    func inserRow(at indexPath: IndexPath)
}

final class WorkoutListViewController: UIViewController {

    // MARK: - @IBOutlets
    @IBOutlet private var tableView: UITableView?
    
    // MARK: - GUI Properties
    private var strechableHeader: StretchableHeader?
    private lazy var timePeriodSelectionHeader = WorkoutListTableHeader.loadFromXib()
    
    // MARK: - Module properties
    private let presenter: WorkoutListPresenterProtocol
    
    // MARK: - Lyfecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showTabBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // MARK: - Initialization
    init(presenter: WorkoutListPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    private func setup() {
       // tableView?.register(cell: WorkoutCell.self)
       // tableView?.register(cell: ErrorCell.self)
        setupHeaders()
    }
    
    private func setupHeaders() {
        let headerSize = CGSize(width: tableView!.frame.size.width, height: 250)
        strechableHeader = StretchableHeader(frame: CGRect(x: 0, y: 0, width: headerSize.width, height: headerSize.height))
        strechableHeader?.title = presenter.title
        strechableHeader?.customDescription = presenter.description
        strechableHeader?.backgroundColor = .black
        strechableHeader?.backButtonImageType = .none
        strechableHeader?.minimumContentHeight = 44
        guard let header = strechableHeader else { return }
        tableView?.addSubview(header)
        
        guard let timePeriodSelectionHeader = self.timePeriodSelectionHeader else { return }
        timePeriodSelectionHeader.translatesAutoresizingMaskIntoConstraints = false
        tableView?.addSubview(timePeriodSelectionHeader)
        timePeriodSelectionHeader.timePeriodIndexWasChanged = { [unowned self] index in
            self.presenter.segmentControlIndexDidChange(index: index)
        }
        timePeriodSelectionHeader.topAnchor.constraint(equalTo: header.bottomAnchor).isActive = true
        timePeriodSelectionHeader.heightAnchor.constraint(equalToConstant: 50).isActive = true
        timePeriodSelectionHeader.widthAnchor.constraint(equalTo: tableView!.widthAnchor).isActive = true
    }
}

// MARK: - WorkoutListViewProtocol
extension WorkoutListViewController: WorkoutListViewProtocol {
    
    func deleteRow(at indexPath: IndexPath) {
        tableView?.performBatchUpdates({ tableView?.deleteRows(at: [indexPath], with: .fade) }, completion: nil)
    }
    
    func inserRow(at indexPath: IndexPath) {
        tableView?.performBatchUpdates({ tableView?.insertRows(at: [indexPath], with: .fade) }, completion: nil)
    }
    
    func reloadData() {
        tableView?.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension WorkoutListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.workoutsCount 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if presenter.isTrainingExists {
            let cell = tableView.dequreusable(cell: WorkoutCell.self)//tableView.dequeueReusableCell(withIdentifier: WorkoutCell.cellID, for: indexPath)
            let workout = presenter.item(at: indexPath)
            cell.setCell(for: workout)
            return cell
            
        } else {
            let cell = tableView.dequreusable(cell: ErrorCell.self)//tableView.dequeueReusableCell(withIdentifier: ErrorCell.cellID , for: indexPath)
            cell.setCell(for: "You have no workouts here")
            return cell
            
        }
    }
}

// MARK: - UITableViewDelegate
extension WorkoutListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectItem(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: nil) { (_, _, completionHandler) in
            tableView.performBatchUpdates({ [unowned self] in
                self.presenter.swipeRow(at: indexPath)
            }, completion: nil)
            completionHandler(true)
        }
        deleteAction.image = UIImage(systemName: "trash")?.withTintColor(.white)
        deleteAction.backgroundColor = DTColors.backgroundColor
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return presenter.isTrainingExists ? UITableView.automaticDimension : 300
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return presenter.isTrainingExists
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}
