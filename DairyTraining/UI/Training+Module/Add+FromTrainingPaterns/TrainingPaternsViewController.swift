import UIKit
import RxCocoa
import RxSwift
import RxDataSources

final class TrainingPaternsViewController: DTBackgroundedViewController {

    //MARK: - @IBOutlets
    @IBOutlet private var tableView: UITableView!
    @IBOutlet var emptyTrainingPaternLabel: UILabel!
    private var disposeBag = DisposeBag()
    //MARK: - Properties
    private let namingPaternAlert = PaternNamingAlert.view()
    var viewModel: TrainingPaternViewModel

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupRX()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.extendedLayoutIncludesOpaqueBars = true
        self.setTabBarHidden(true, animated: true, duration: 0.25)
    }

    //MARK: - Initialization
    init(viewModel: TrainingPaternViewModel) {
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
    
    deinit {
        print("Patern list deinit")
    }
}

//MARK: - Private extension
private extension TrainingPaternsViewController {
    
    func setupRX() {
        
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
      
        let dataSourse = RxTableViewSectionedAnimatedDataSource<SectionItem> { dataSource, tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: TrainingPaternCell.cellID, for: indexPath)
            (cell as? TrainingPaternCell)?.setCell(for: item.name)
            return cell
        }
        
        dataSourse.animationConfiguration = AnimationConfiguration(insertAnimation: .fade,
                                                                   reloadAnimation: .fade,
                                                                   deleteAnimation: .fade)
        
        dataSourse.canEditRowAtIndexPath = { dataSource, indexPath in
            return true
        }
        
        viewModel.trainingPaterns
            .asObservable()
            .map({ $0.first?.items.isEmpty ?? true })
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] isEmpty in
                self?.setupUIvisibility(with: isEmpty)
            })
            .disposed(by: disposeBag)

        viewModel.trainingPaterns
            .asObservable()
            .bind(to: tableView.rx.items(dataSource: dataSourse))
            .disposed(by: disposeBag)

        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] index in
                self?.viewModel.goToChoosenTrainingPatern(with: index.item)
            })
            .disposed(by: disposeBag)
    }

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
    
    func setupUIvisibility(with isEmpty: Bool) {
        switch isEmpty {
        case true:
            self.emptyTrainingPaternLabel.isHidden = false
            UIView.animate(withDuration: 0.4, animations: {
                self.emptyTrainingPaternLabel.alpha = 1
            })
            self.tableView.isHidden = true
            self.tableView.alpha = 0
        case false:
            self.tableView.isHidden = false
            UIView.animate(withDuration: 0.4, animations: {
                self.tableView.alpha = 1
            })
            self.emptyTrainingPaternLabel.isHidden = true
            self.emptyTrainingPaternLabel.alpha = 0
        }
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
