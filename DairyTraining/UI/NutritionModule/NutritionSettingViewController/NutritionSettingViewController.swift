import UIKit

protocol NutritionSettingView: AnyObject {
    func selectMode(at index: Int)
    func deselectMode(at index: Int)
}

final class NutritionSettingViewController: BaseViewController {

    // MARK: - @IBOutlets
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var customNutritionSettingView: UIView!
    
    private let viewModel: NutritionSettingViewModelProtocol
    
    // MARK: - Lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
        tableView.register(UINib(nibName: NutritionModeCell.xibName, bundle: nil),
                           forCellReuseIdentifier: NutritionModeCell.cellID)
    }
    
    init(viewModel: NutritionSettingViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NutritionSettingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.settingModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NutritionModeCell.cellID, for: indexPath)
        (cell as? NutritionModeCell)?.setCellName(viewModel.settingModel[indexPath.row].title)
        if viewModel.selectedIndex == indexPath.row {
            (cell as? NutritionModeCell)?.showCheckMark()
        } else {
            (cell as? NutritionModeCell)?.hideCheckMark()
        }
        return cell
    }
}

extension NutritionSettingViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectRow(at: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

extension NutritionSettingViewController: NutritionSettingView {
    
    func deselectMode(at index: Int) {
        
    }
    
    func selectMode(at index: Int) {
        let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? NutritionModeCell
        cell?.showCheckMark()
        if index == 3 {
            customNutritionSettingView.isHidden = false
        } else {
            customNutritionSettingView.isHidden = true
        }
        tableView.reloadData()
    }
}
