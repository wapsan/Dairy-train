import UIKit
import RxCocoa
import RxSwift

final class ChoosenPaternViewController: DTBackgroundedViewController {
    
    //MARK: - @IBOutlets
    @IBOutlet private var tableView: UITableView!
    
    //MARK: - Private properties
    private var viewModel: ChoosenPaternViewModel
    private var namingAlert = PaternNamingAlert.view()
    private let tableHeaderView = TrainingPaternHeaderView.view()
    private var disposeBag = DisposeBag()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupRX()
    }
    
    //MARK: - Initialization
    init(viewModel: ChoosenPaternViewModel) {
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
        extendedLayoutIncludesOpaqueBars = true
        tableView.register(DTActivitiesCell.self,
                           forCellReuseIdentifier: DTActivitiesCell.cellID)
        
        namingAlert?.delegate = viewModel
        let addBarButton = UIBarButtonItem(barButtonSystemItem: .add,
                                           target: self,
                                           action: #selector(self.addBarButtonAction))
        navigationItem.rightBarButtonItem = addBarButton
    }
    
    func setupRX() {
        viewModel.paternsExercise.bind(to: tableView.rx.items(cellIdentifier: DTActivitiesCell.cellID)) {
            (index, exercise, cell) in
            (cell as? DTActivitiesCell)?.renderCellFor(exercise)
        }
        .disposed(by: self.disposeBag)
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
        namingAlert?.show(with: viewModel.paternNameo.value)
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

//MARK: - UITableViewDelegate
extension ChoosenPaternViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section == 0 else { return nil }
        self.viewModel.paternNameo.asObservable().subscribe(onNext: {
            self.animatableChangePaternName(to: $0)
        }).disposed(by: disposeBag)
        tableHeaderView?.createTrainingAction = { [unowned self] in
            self.showCreateTrainingAlert()
        }
        tableHeaderView?.changePaternAction = { [unowned self] in
            self.viewModel.addExerciseToCurrnetPatern()
        }
        return tableHeaderView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 100 : 0
    }
}
