import UIKit

protocol ChoosenPaternView: AnyObject {
    func reloadTable()
    func changePaternName(to name: String)
}

final class ChoosenPaternViewController: DTBackgroundedViewController {
    
    //MARK: - @IBOutlets
    @IBOutlet private var tableView: UITableView!
    
    //MARK: - module properties
    private let viewModel: ChoosenPaternViewModelProtocol
    
    // MARK: - GUI Properties
    private var strechableHeader: StretchableHeader?
    private lazy var namingAlert = PaternNamingAlert.loadFromXib()

    //MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideTabBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    //MARK: - Initialization
    init(viewModel: ChoosenPaternViewModelProtocol) {
        self.viewModel = viewModel
        super.init()
    }

}

//MARK: - Private
private extension ChoosenPaternViewController {
    
    func setup() {
        tableView.register(cell: DefaultExerciseCell.self)
        namingAlert?.delegate = viewModel
        setupHeader()
        navigationController?.navigationBar.isHidden = true
    }
    
    func showCreateTrainingAlert() {
        showDefaultAlert(
            title: "Create training?",
            message: "Create training with this exercise?",
            preffedStyle: .alert,
            okTitle: "Ok",
            cancelTitle: "Cancel",
            completion: { [unowned self] in
                self.viewModel.createTraining()
                self.showSuccesTrainingCreationAlert()
        })
    }
    
    func showSuccesTrainingCreationAlert() {
        showDefaultAlert(
            title: "Training create",
            message: nil,
            preffedStyle: .alert,
            okTitle: "Ok",
            cancelTitle: nil,
            completion: nil)
    }
    
    func setupHeader() {
        let headerSize = CGSize(width: tableView.frame.size.width, height: 150)
        strechableHeader = StretchableHeader(frame: CGRect(x: 0, y: 0, width: headerSize.width, height: headerSize.height))
        strechableHeader?.backgroundColor = .black
        strechableHeader?.backButtonImageType = .goBack
        strechableHeader?.minimumContentHeight = 44
        strechableHeader?.showButtons()
        strechableHeader?.setLeftDownButton(title: "Add exercise")
        strechableHeader?.setRightDownButton(title: "Create training")
        strechableHeader?.topRightButtonAction = { [unowned self] in self.namingAlert?.show(with: viewModel.patenrName) }
        strechableHeader?.onBackButtonAction = { [unowned self] in self.viewModel.backButtonPressed() }
        strechableHeader?.onLeftButtonAction = { [unowned self] in self.viewModel.addExerciseToCurrnetPatern() }
        strechableHeader?.onRightButtonAction = { [unowned self] in self.showCreateTrainingAlert() }
        strechableHeader?.setTopRightButton( image: UIImage(named: "editPaternIcon")?.withTintColor(.black))
        strechableHeader?.title = viewModel.patenrName
        strechableHeader?.customDescription = nil
        guard let header = strechableHeader else { return }
        tableView.addSubview(header)
    }
}

// MARK: - ChoosenPaternView
extension ChoosenPaternViewController: ChoosenPaternView {
    
    func changePaternName(to name: String) {
        strechableHeader?.title = name
    }
    
    func reloadTable() {
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension ChoosenPaternViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return viewModel.exercises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DefaultExerciseCell.cellID, for: indexPath)
        (cell as? DefaultExerciseCell)?.setCell(for: viewModel.exercises[indexPath.row])
        return cell
    }
}
