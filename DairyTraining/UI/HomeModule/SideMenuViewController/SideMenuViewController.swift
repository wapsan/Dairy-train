import UIKit

final class SideMenuViewController: RequredViewController {

    //MARK: - Constants
    private struct Constants {
        static let cellHeight: CGFloat = 70
    }
    
    //MARK: - @IBOutlets
    @IBOutlet private var tableView: UITableView!
    
    //MARK: - Properties
    private var presenter: SideMenuPresenterProtocol
    
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
    init(presenter: SideMenuPresenter) {
        self.presenter = presenter
        super.init()
    }
    
    //MARK: - Setup
    func setup() {
        let cellNib = UINib(nibName: SideMenuCell.xibName, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: SideMenuCell.cellID)
    }
}

//MARK: - UITableViewDataSource
extension SideMenuViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.sideMenuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let menuItem = presenter.sideMenuItems[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: SideMenuCell.cellID, for: indexPath)
        (cell as? SideMenuCell)?.setCell(for: menuItem)
        return cell
    }
}

//MARK: - UITableViewDelegate
extension SideMenuViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.menuItemSelected(at: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.cellHeight
    }
}
