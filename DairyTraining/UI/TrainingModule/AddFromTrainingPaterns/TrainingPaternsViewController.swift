import UIKit

protocol TrainingPaternsView: AnyObject {
    func reloadTable()
    func deleteCell(at rowIndex: Int)
    func showEmtyLabel()
    func showPaternsTable()
}

final class TrainingPaternsViewController: DTBackgroundedViewController {

    //MARK: - @IBOutlets
    @IBOutlet private var tableView: UITableView!
    @IBOutlet var emptyTrainingPaternLabel: UILabel!

    //MARK: - Properties
    private let namingPaternAlert = PaternNamingAlert.view()
    var viewModel: TrainingPaternViewModelProtocol

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideTabBar()
    }

    //MARK: - Initialization
    init(viewModel: TrainingPaternViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Actions
    @objc private func addTrainingPaternAction() {
        self.namingPaternAlert?.show()
    }
}

//MARK: - Private extension
private extension TrainingPaternsViewController {

    func setup() {
        self.title = "Training paterns"
        tableView.register(UINib(nibName: TrainingPaternCell.xibName, bundle: nil),
                           forCellReuseIdentifier: TrainingPaternCell.cellID)
        
        namingPaternAlert?.delegate = viewModel
        
        let addPaternButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                  target: self,
                                                  action: #selector(self.addTrainingPaternAction))
        navigationItem.rightBarButtonItem = addPaternButtonItem
    }
}

// MARK: - TrainingPaternsView
extension TrainingPaternsViewController: TrainingPaternsView {

    func showEmtyLabel() {
        self.emptyTrainingPaternLabel.isHidden = false
        UIView.animate(withDuration: 0.4, animations: {
            self.emptyTrainingPaternLabel.alpha = 1
        })
        self.tableView.isHidden = true
        self.tableView.alpha = 0
    }
    
    func showPaternsTable() {
        self.tableView.isHidden = false
        UIView.animate(withDuration: 0.4, animations: {
            self.tableView.alpha = 1
        })
        self.emptyTrainingPaternLabel.isHidden = true
        self.emptyTrainingPaternLabel.alpha = 0
    }
    
    
    func deleteCell(at rowIndex: Int) {
        tableView.beginUpdates()
        tableView.deleteRows(at: [IndexPath(row: rowIndex, section: 0)], with: .fade)
        tableView.endUpdates()
    }

    func reloadTable() {
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension TrainingPaternsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.paterns.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TrainingPaternCell.cellID, for: indexPath)
        (cell as? TrainingPaternCell)?.setCell(for: viewModel.paterns[indexPath.row].name)
        return cell
    }
}

//MARK: - UITableViewDelegate
extension TrainingPaternsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return TrainingPaternsHeaderView.view()
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectRow(at: indexPath.row)
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: nil) { [weak self] (_, _, completionHandler) in
            self?.viewModel.removeTrainingPatern(at: indexPath.row)
            completionHandler(true)
        }
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = DTColors.backgroundColor
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
}
