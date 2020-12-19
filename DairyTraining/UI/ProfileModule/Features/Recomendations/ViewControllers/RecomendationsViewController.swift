import UIKit

final class RecomendationsViewController: UIViewController {
    
    //MARK: - Properties
    var viewModel: RecomendationViewModelInput?

    //MARK: - GUI Properties
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.bounces = false
        table.dataSource = self
        table.delegate = self
        table.backgroundColor = DTColors.backgroundColor
        table.register(TDRecomendationCell.self,
                       forCellReuseIdentifier: TDRecomendationCell.cellID)
        table.showsVerticalScrollIndicator = false
        table.sectionFooterHeight = 1
        table.sectionHeaderHeight = self.view.frame.height / 15
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    //MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideTabBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = LocalizedString.recomendations
        self.viewModel?.calculateRecomendation()
        self.setUpTable()
    }
    
    //MARK: - Private Methods
    private func setUpTable() {
        self.view.addSubview(self.tableView)
        self.viewModel?.calculateRecomendation()
        self.setUpTableConstraints()
    }
    
    //MARK: - Constraints
    private func setUpTableConstraints() {
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo:  self.view.topAnchor),
            self.tableView.leftAnchor.constraint(equalTo:  self.view.leftAnchor),
            self.tableView.rightAnchor.constraint(equalTo:  self.view.rightAnchor),
            self.tableView.bottomAnchor.constraint(equalTo:  self.view.bottomAnchor)
        ])
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension RecomendationsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TDRecomendationCell.cellID,
                                                 for: indexPath)
        guard let recomendationInfo = self.viewModel?.supplyModel[indexPath.section] else {
            return UITableViewCell()
        }
        (cell as? TDRecomendationCell)?.setCell(for: recomendationInfo)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel?.supplyModel.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let width = self.tableView.bounds.width
        let heigt: CGFloat = 1
        let footerView = UIView(frame: .init(x: 0, y: 0, width: width, height: heigt))
        footerView.backgroundColor = .white
        return footerView
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = DTRecomendationHeaderView()
        guard let recomendationInfoTitle = self.viewModel?.supplyModel[section].tittle else {
            return UIView()
        }
        headerView.setHeaderView(title: recomendationInfoTitle)
        return headerView
    }
}
