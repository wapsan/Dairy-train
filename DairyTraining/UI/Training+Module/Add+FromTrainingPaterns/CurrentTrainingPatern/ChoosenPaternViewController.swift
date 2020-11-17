import UIKit
import RxCocoa
import RxSwift
import SideMenu

final class ChoosenPaternViewController: DTBackgroundedViewController {
    
    //MARK: - @IBOutlets
    @IBOutlet private var tableView: UITableView!
    
    //MARK: - Private properties
    private var viewModel: ChoosenPaternViewModel
    private var namingAlert = PaternNamingAlert.view()
    private let tableHeaderView = TrainingPaternHeaderView.view()
    private var disposeBag = DisposeBag()
    private var firstOpen = true
    
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
        tableView.tableHeaderView = tableHeaderView
        self.viewModel.paternNameo.asObservable()
        .subscribe(onNext: {
            self.firstOpen ? self.tableHeaderView?.titleLabel.text = $0 : self.animatableChangePaternName(to: $0)
            self.firstOpen = false
        }).disposed(by: disposeBag)
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
    
    func setupRX() {
        viewModel.paternsExercise
            .bind(to: tableView.rx.items(cellIdentifier: DTActivitiesCell.cellID)) {
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
//        let curentPaternSideMenu = CurrentPaternSideMenu()
//        let menu = SideMenuNavigationController(rootViewController: curentPaternSideMenu)
//        menu.leftSide = false
//        menu.menuWidth = UIScreen.main.bounds.width * 0.7
//        menu.statusBarEndAlpha = 0.0
//                   
//                    menu.presentationStyle = .menuSlideIn
//                    
//                  
//        menu.presentationStyle.presentingEndAlpha = 0.4
//                    menu.navigationBar.isHidden = true
//                    menu.modalPresentationStyle = .overCurrentContext
//        present(menu, animated: true, completion: nil)
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

