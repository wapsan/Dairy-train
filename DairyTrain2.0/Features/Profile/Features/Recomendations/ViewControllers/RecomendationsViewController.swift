import UIKit

class RecomendationsViewController: UIViewController {
    
    //MARK: - Privatr roperties
    private lazy var selectedSections = Set<Int>()
    private lazy var supplyModel: [RecomendationInfo] = []
    private lazy var mainInfoManagedObject = CoreDataManager.shared.readUserMainInfo()
    
    //MARK: - GUI Properties
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.dataSource = self
        table.delegate = self
        table.backgroundColor = .black
        table.register(TDRecomendationCell.self,
                       forCellReuseIdentifier: TDRecomendationCell.cellID)
        table.showsVerticalScrollIndicator = false
        table.sectionFooterHeight = 1
        table.sectionHeaderHeight = self.view.frame.height / 15
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = LocalizedString.recomendations
        self.setRecomendationInfoModel()
        self.setUpTable()
    }

    //MARK: - Private Methods
    private func setUpTable() {
        self.view.addSubview(self.tableView)
        self.setUpTableConstraints()
    }
    
    private func setRecomendationInfoModel() {
        guard let mainInfoMO = self.mainInfoManagedObject else { return }
        guard let userMainInfo = UserMainInfoModel(from: mainInfoMO) else { return }
        CaloriesCalculator.shared.getUserParameters(from: userMainInfo)
        self.supplyModel = CaloriesCalculator.shared.getRecomendatinoInfo()
    }
    
    private func indexPaths(for section: Int) -> [IndexPath] {
        var indexPaths: [IndexPath] = []
        for row in 0..<1 {
            indexPaths.append(IndexPath(row: row, section: section))
        }
        return indexPaths
    }
    
    //MARK: - Constraints
    private func setUpTableConstraints() {
        let safeArea = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            self.tableView.leftAnchor.constraint(equalTo: safeArea.leftAnchor),
            self.tableView.rightAnchor.constraint(equalTo: safeArea.rightAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension RecomendationsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.selectedSections.contains(section) ? 1 : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TDRecomendationCell.cellID,
                                                 for: indexPath)
        let recomendationInfo = self.supplyModel[indexPath.section]
        (cell as? TDRecomendationCell)?.setCell(for: recomendationInfo)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.supplyModel.count
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
        let recomendationInfoTitle = self.supplyModel[section].tittle
        headerView.setHeaderView(title: recomendationInfoTitle, and: section)
        headerView.delegate = self
        return headerView
    }
}

//MARK: - DTRecomendationFooterViewDelegate
extension RecomendationsViewController: DTRecomendationHeaderViewDelegate {
    
    func moreInfoButtonPressed(_ sender: UIButton) {
        let section = sender.tag
        if self.selectedSections.contains(section) {
            self.selectedSections.remove(section)
            self.tableView.beginUpdates()
            self.tableView.deleteRows(at: self.indexPaths(for: section), with: .top)
            self.tableView.endUpdates()
        } else {
            self.selectedSections.insert(section)
            self.tableView.beginUpdates()
            self.tableView.insertRows(at: self.indexPaths(for: section), with: .top)
            self.tableView.endUpdates()
        }
    }
}


