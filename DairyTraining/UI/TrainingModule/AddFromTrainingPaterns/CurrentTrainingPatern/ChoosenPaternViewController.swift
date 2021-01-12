import UIKit

protocol ChoosenPaternView: AnyObject {
    func reloadTable()
    func changePaternName(to name: String)
}

final class ChoosenPaternViewController: DTBackgroundedViewController {
    
    //MARK: - @IBOutlets
    @IBOutlet private var tableView: UITableView!
    
    //MARK: - Private properties
    private var viewModel: ChoosenPaternViewModelProtocol
    private var namingAlert = PaternNamingAlert.view()
    private let tableHeaderView = TrainingPaternHeaderView.view()
    private var firstOpen = true
    
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
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Private
private extension ChoosenPaternViewController {
    
    func setup() {
        tableView.register(cell: DefaultExerciseCell.self)
        namingAlert?.delegate = viewModel
        tableView.tableHeaderView = tableHeaderView
        tableHeaderView?.titleLabel.text = viewModel.patenrName
        tableHeaderView?.createTrainingAction = { [weak self] in
            self?.showCreateTrainingAlert()
        }
        tableHeaderView?.changePaternAction = { [weak self] in
            self?.viewModel.addExerciseToCurrnetPatern()
        }
        let menuBarButton = UIBarButtonItem(image: UIImage(named: "menu"),
                                            style: .plain,
                                            target: self,
                                            action: #selector(addBarButtonAction))
        navigationItem.rightBarButtonItem = menuBarButton
        navigationController?.navigationBar.tintColor = .white
    }
    
    func animatableChangePaternName(to name: String) {
        UIView.animate(withDuration: 0.25,
                       animations: {
                        self.tableHeaderView?.titleLabel.alpha = 0
                       }, completion: { [weak self] _ in
                        UIView.animate(withDuration: 0.23, animations: {
                            self?.tableHeaderView?.titleLabel.text = name
                            self?.tableHeaderView?.titleLabel.alpha = 1
                        })
                       })
    }
    
    @objc private func addBarButtonAction() {
        namingAlert?.show(with: viewModel.patenrName)
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
}

extension ChoosenPaternViewController: ChoosenPaternView {
    
    func changePaternName(to name: String) {
        animatableChangePaternName(to: name)
    }
    
    func reloadTable() {
        tableView.reloadData()
    }
}

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
