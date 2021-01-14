import UIKit

protocol ReadyWorkoutViewProtocol: AnyObject {
    func reloadData()
    func showLoader()
    func hideLoader()
    func showAlert(with message: String)
}

final class ReadyWorkoutViewController: UIViewController {

    // MARK: - @IBOutlets
    @IBOutlet private var tableView: UITableView!
    
    // MARK: - GUI Properties
    private var strechableHeader: StretchableHeader?
    private lazy var refreshSpinner: UIActivityIndicatorView = {
        let indicatoor = UIActivityIndicatorView(style: .medium)
        indicatoor.color = UIColor.black
        indicatoor.hidesWhenStopped = true
        return indicatoor
    }()
    
    // MARK: - Properties
    private var viewModel: ReadyWorkoutViewModelProtocol
    
    // MARK: - Lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        viewModel.viewDidLoad()
    }
    
    // MARK: - Initialization
    init(viewModel: ReadyWorkoutViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setup() {
        tableView.register(cell: DefaultExerciseCell.self)
        tableView.tableFooterView = refreshSpinner
        setupHeader()
    }
    
    private func setupHeader() {
        let headerSize = CGSize(width: tableView.frame.size.width, height: 250)
        strechableHeader = StretchableHeader(frame: CGRect(x: 0, y: 0, width: headerSize.width, height: headerSize.height))
        strechableHeader?.backgroundColor = .black
        strechableHeader?.backButtonImageType = .goBack
        strechableHeader?.minimumContentHeight = 44
        strechableHeader?.showButtons()
        strechableHeader?.onBackButtonAction = { [unowned self] in self.viewModel.backButtonPressed() }
        strechableHeader?.onRightButtonAction = { [unowned self] in self.viewModel.createPaternButtonPressed() }
        strechableHeader?.onLeftButtonAction = { [unowned self] in self.viewModel.createTrainingButtonPressed() }
        strechableHeader?.image = viewModel.workoutImage
        strechableHeader?.title = viewModel.workoutTitle
        strechableHeader?.customDescription = viewModel.workoutDescription
        guard let header = strechableHeader else { return }
        tableView.addSubview(header)
    }
}

// MARK: - ReadyWorkoutViewpProtocol
extension ReadyWorkoutViewController: ReadyWorkoutViewProtocol {
    
    func showAlert(with message: String) {
        showDefaultAlert(title: nil,
                         message: message,
                         preffedStyle: .alert,
                         okTitle: LocalizedString.ok,
                         cancelTitle: nil,
                         completion: { [unowned self] in self.viewModel.alertCompletion() })
    }

    func reloadData() {
        tableView.reloadData()
    }
    
    func showLoader() {
        refreshSpinner.startAnimating()
    }
    
    func hideLoader() {
        refreshSpinner.stopAnimating()
    }
}

// MARK: - UITableViewDataSource
extension ReadyWorkoutViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.exerciseCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DefaultExerciseCell.cellID, for: indexPath)
        (cell as? DefaultExerciseCell)?.setCell(for: viewModel.getExercise(for: indexPath.row))
        return cell
    }
}
