import UIKit

protocol TrainingProgramsViewProtocol: AnyObject, Loadable {
    func reloadTableView()
}

final class TrainingProgramsViewController: UIViewController {

    // MARK: - @IBOutlets
    @IBOutlet private var tableView: UITableView!
    
    // MARK: - GUI Properties
    private var strechableHeader: StretchableHeader?
    
    // MARK: - Properties
    private let viewModel: TrainingProgramsViewModelProtocol
    
    // MARK: - Lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        viewModel.viewDidLoad()
    }
    
    // MARK: - Initialization
    init(viewModel: TrainingProgramsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    private func setup() {
        navigationController?.navigationBar.isHidden = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        setupHeader()
    }
    
    private func setupHeader() {
        
    }
}

// MARK: - UITableViewDataSource
extension TrainingProgramsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.trainings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = viewModel.trainings[indexPath.row].title
        return cell
    }
}

// MARK: - UITableViewDelegate
extension TrainingProgramsViewController: UITableViewDelegate {
    
}

// MARK: - TrainingProgramsViewProtocol
extension TrainingProgramsViewController: TrainingProgramsViewProtocol {
    
    func reloadTableView() {
        tableView.reloadData()
    }
}
