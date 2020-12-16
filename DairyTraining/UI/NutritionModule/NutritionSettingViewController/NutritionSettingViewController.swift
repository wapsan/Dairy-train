import UIKit

protocol NutritionSettingView: AnyObject {
    func selectMode(at index: Int)
}

final class NutritionSettingViewController: BaseViewController {

    // MARK: - @IBOutlets
    @IBOutlet var tableView: UITableView!
    
    private let viewModel: NutritionSettingViewModelProtocol
    
    // MARK: - Lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = viewModel.settingModel[indexPath.row].title
        return cell
    }
}

extension NutritionSettingViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectRow(at: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        viewModel.deseloctRow(at: indexPath.row)
    }
}

extension NutritionSettingViewController: NutritionSettingView {
    
    func selectMode(at index: Int) {
        print("Select mode at \(index)")
    }
}
