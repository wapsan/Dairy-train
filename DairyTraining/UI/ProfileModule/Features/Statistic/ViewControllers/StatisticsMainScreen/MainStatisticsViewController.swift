import UIKit

final class MainStatisticsViewController: MainTabBarItemVC {

    //MARK: - @IBOutlets
    @IBOutlet var tableView: UITableView!
    
    //MARK: - Properties
    private var viewModel: MainStatisticViewModel
    
    //MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        MainCoordinator.shared.setTabBarHidden(true, duration: 0.25)
        extendedLayoutIncludesOpaqueBars = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    //MARK: - Initialization
    init(viewModel: MainStatisticViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Private
private extension MainStatisticsViewController {
    
    func setup() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
}

//MARK: - UITableViewDataSource
extension MainStatisticsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.statisticTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = viewModel.statisticTypes[indexPath.row].name
        return cell
    }
}

//MARK: - UITableViewDelegate
extension MainStatisticsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.itemWasSelected(at: indexPath.row)
    }
}
