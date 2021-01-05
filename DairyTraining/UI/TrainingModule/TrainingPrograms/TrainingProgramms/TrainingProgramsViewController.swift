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
        tableView.register(cell: ReadyTrainingCell.self)
        tableView.contentInset.top = 8
        setupHeader()
    }
    
    private func setupHeader() {
        let headerSize = CGSize(width: tableView.frame.size.width, height: 250)
        strechableHeader = StretchableHeader(frame: CGRect(x: 0, y: 0, width: headerSize.width, height: headerSize.height))
        strechableHeader?.backgroundColor = .black
        strechableHeader?.backButtonImageType = .goBack
        strechableHeader?.minimumContentHeight = 44
        strechableHeader?.onBackButtonAction = { [unowned self] in
            self.viewModel.backButtonPressed()
        }
        strechableHeader?.title = viewModel.levelTitle
        strechableHeader?.customDescription = viewModel.levelDescription
        guard let header = strechableHeader else { return }
        tableView.addSubview(header)
    }
}

// MARK: - UITableViewDataSource
extension TrainingProgramsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.trainings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReadyTrainingCell.cellID, for: indexPath)
        (cell as? ReadyTrainingCell)?.setCell(for: viewModel.getTraining(for: indexPath.row))
        return cell
    }
}

// MARK: - UITableViewDelegate
extension TrainingProgramsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectRow(at: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}

// MARK: - TrainingProgramsViewProtocol
extension TrainingProgramsViewController: TrainingProgramsViewProtocol {
    
    func reloadTableView() {
        tableView.reloadData()
    }
}
