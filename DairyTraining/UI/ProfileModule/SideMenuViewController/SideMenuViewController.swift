import UIKit

final class SideMenuViewController: UIViewController {

    //MARK: - @IBOutlets
    @IBOutlet private var tableView: UITableView!
    
    //MARK: - Properties
    private var viewModel: SideMenuViewModelProtocol
    
    //MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.extendedLayoutIncludesOpaqueBars = true
        self.setTabBarHidden(true, animated: true, duration: 0.25)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        MainCoordinator.shared.setTabBarHidden(false, duration: 0.25)
    }
    
    //MARK: - Initialization
    init(viewModel: SideMenuViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Private
private extension SideMenuViewController {
    
    func setup() {
        let cellNib = UINib(nibName: SideMenuCell.xibName, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: SideMenuCell.cellID)
    }
}

//MARK: - UITableViewDataSource
extension SideMenuViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sideMenuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let menuItem = viewModel.sideMenuItems[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: SideMenuCell.cellID, for: indexPath)
        (cell as? SideMenuCell)?.setCell(for: menuItem)
        return cell
    }
}

//MARK: - UITableViewDelegate
extension SideMenuViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.menuItemSelected(at: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
